import Base:*

"""

# stan 

Execute a Stan model. 

### Method
```julia
rc, sim, cnames = stan(
  model::Stanmodel, 
  data=Nothing, 
  ProjDir=pwd();
  init=Nothing,
  summary=true, 
  diagnostics=false, 
  CmdStanDir=CMDSTAN_HOME,
  file_run_log=true
)
```
### Required arguments
```julia
* `model::Stanmodel`              : See ?Method
```

### Optional positional arguments

```julia
* `data=Nothing`                  : Observed input data dictionary 
* `ProjDir=pwd()`                 : Project working directory
```

### Keyword arguments
```julia
* `init=Nothing`                  : Initial parameter value dictionary
* `summary=true`                  : Use CmdStan's stansummary to display results
* `diagnostics=false`             : Generate diagnostics file
* `CmdStanDir=CMDSTAN_HOME`       : Location of cmdstan directory
* `file_run_log=true`             : Create run log file (if false, write log to stdout)
* `file_make_log=true`            : Create make log file (if false, write log to stdout)
```

If the type the `data` or `init` arguments are an AbstartcString this is interpreted as
a path name to an existing .R file. This file is copied to the coresponding .R data
and/or init files for for each chain.

### Return values
```julia
* `rc::Int`                       : Return code from stan(), rc == 0 if all is well
* `sim`                           : Chain results
* `cnames`                        : Vector of variable names
```

### Examples

```julia
# no data, use default ProjDir (pwd)
stan(mymodel)
# default ProjDir (pwd)
stan(mymodel, mydata)
# specify ProjDir
stan(mymodel, mydata, "~/myproject/")
# keyword arguments
stan(mymodel, mydata, "~/myproject/", diagnostics=true, summary=false)
# use default ProjDir (pwd), with keyword arguments
stan(mymodel, mydata, diagnostics=true, summary=false)
```

### Related help
```julia
?Stanmodel                         : Create a StanModel
```
"""
function stan(
  model::Stanmodel, 
  data=Nothing, 
  ProjDir=pwd();
  init=Nothing,
  summary=true, 
  diagnostics=false, 
  CmdStanDir=CMDSTAN_HOME,
  file_run_log=true,
  file_make_log=true)
  
  old = pwd()
  local rc = 0
  local res = Dict[]
  
  if length(model.model) == 0
    println("\nNo proper model specified in \"$(model.name).stan\".")
    println("This file is typically created from a String passed to Stanmodel().\n")
    return((-1, res))
  end
  
  @assert isdir(ProjDir) "Incorrect ProjDir specified: $(ProjDir)"
  @assert isdir(model.tmpdir) "$(model.tmpdir) not created"
  
  cd(model.tmpdir)
  isfile("$(model.name)_build.log") && rm("$(model.name)_build.log")
  isfile("$(model.name)_make.log") && rm("$(model.name)_make.log")
  isfile("$(model.name)_run.log") && rm("$(model.name)_run.log")

  cd(CmdStanDir)
  local tmpmodelname::String
  tmpmodelname = joinpath(model.tmpdir, model.name)
  if @static Sys.iswindows() ? true : false
    tmpmodelname = replace(tmpmodelname*".exe", "\\" => "/")
  end
  try
    if file_make_log
      run(pipeline(`make $(tmpmodelname)`,
        stdout="$(tmpmodelname)_make.log",
        stderr="$(tmpmodelname)_build.log"))
    else
      run(pipeline(`make $(tmpmodelname)`,
        stderr="$(tmpmodelname)_build.log"))
    end
  catch
    println("\nAn error occurred while compiling the Stan program.\n")
    print("Please check your Stan program in variable '$(model.name)' ")
    print("and the contents of $(tmpmodelname)_build.log.\n")
    println("Note that Stan does not handle blanks in path names.")
    error("Return code = -3");
  end
        
  cd(model.tmpdir)
  
  if data != Nothing && (typeof(data) <: AbstractString || check_dct_type(data))
    if typeof(data) <: AbstractString
      for i in 1:model.nchains
        cp(data, "$(model.name)_$(i).data.R", force=true)
      end   
    else
      if typeof(data) <: Array && length(data) == model.nchains
        for i in 1:model.nchains
          if length(keys(data[i])) > 0
            update_R_file("$(model.name)_$(i).data.R", data[i])
          end
        end
      else
        if typeof(data) <: Array
          for i in 1:model.nchains
            if length(keys(data[1])) > 0
              update_R_file("$(model.name)_$(i).data.R", data[1])
            end
          end
        else
          for i in 1:model.nchains
            if length(keys(data)) > 0
              update_R_file("$(model.name)_$(i).data.R", data)
            end
          end
        end
      end
    end
  end
  
  if init != Nothing && (typeof(init) <: AbstractString || check_dct_type(init))
    if typeof(init) <: AbstractString
      for i in 1:model.nchains
        cp(init, "$(model.name)_$(i).init.R", force=true)
      end   
    else
      if typeof(init) <: Array && length(init) == model.nchains
        for i in 1:model.nchains
          if length(keys(init[i])) > 0
            update_R_file("$(model.name)_$(i).init.R", init[i])
          end
        end
      else
        if typeof(init) <: Array
          for i in 1:model.nchains
            if length(keys(init[1])) > 0
              update_R_file("$(model.name)_$(i).init.R", init[1])
            end
          end
        else
          for i in 1:model.nchains
            if length(keys(init)) > 0
              update_R_file("$(model.name)_$(i).init.R", init)
            end
          end
        end
      end
    end
  end
  
  for i in 1:model.nchains
    model.id = i
    model.data_file ="$(model.name)_$(i).data.R"
    if !(model.init == Nothing)
        model.init_file = "$(model.name)_$(i).init.R"
    end
    if isa(model.method, Sample)
      model.output.file = model.name*"_samples_$(i).csv"
      isfile("$(model.name)_samples_$(i).csv") && rm("$(model.name)_samples_$(i).csv")
      if diagnostics
        model.output.diagnostic_file = model.name*"_diagnostics_$(i).csv"
        isfile("$(model.name)_diagnostics_$(i).csv") && rm("$(model.name)_diagnostics_$(i).csv")
      end
    elseif isa(model.method, Optimize)
      isfile("$(model.name)_optimize_$(i).csv") && rm("$(model.name)_optimize_$(i).csv")
      model.output.file = model.name*"_optimize_$(i).csv"
    elseif isa(model.method, Variational)
      isfile("$(model.name)_variational_$(i).csv") && rm("$(model.name)_variational_$(i).csv")
      model.output.file = model.name*"_variational_$(i).csv"
    elseif isa(model.method, Diagnose)
      isfile("$(model.name)_diagnose_$(i).csv") && rm("$(model.name)_diagnose_$(i).csv")
      model.output.file = model.name*"_diagnose_$(i).csv"
    end
    model.command[i] = cmdline(model)
  end
  
  try
    if file_run_log
      run(pipeline(par(model.command), stdout="$(model.name)_run.log"))
    else
      run(par(model.command))
    end
  catch e
    println("\nAn error occurred while running the previously compiled Stan program.\n")
    print("Please check the contents of file $(tmpmodelname)_run.log and the")
    println("'command' field in the Stanmodel, e.g. stanmodel.command.\n")
    cd(old)
    error("Return code = -5")
  end
  
  local samplefiles = String[]
  local ftype
  local cnames = String[]
  
  if typeof(model.method) in [Sample, Variational]
    if isa(model.method, Sample)
      ftype = diagnostics ? "diagnostics" : "samples"
    else
      ftype = lowercase(string(typeof(model.method)))
    end
    
    for i in 1:model.nchains
      push!(samplefiles, "$(model.name)_$(ftype)_$(i).csv")
    end
    
    if summary
      stan_summary(model, par(samplefiles), CmdStanDir=CmdStanDir)
    end
    
    (res, cnames) = read_samples(model, diagnostics)
    
  elseif isa(model.method, Optimize)
    res, cnames = read_optimize(model)

  elseif isa(model.method, Diagnose)
    res, cnames = read_diagnose(model)

  else
    println("\nAn unknown method is specified in the call to stan().")
    cd(old)
    error("Return code = -10")
  end
  
  if model.output_format != :array
    start_sample = 1
    if isa(model.method, Sample) && !model.method.save_warmup
      start_sample = model.method.num_warmup+1
    end
    res = convert_a3d(res, cnames, Val(model.output_format);
      start=start_sample)
  end
  
  cd(old)

  (rc, res, cnames)
  
end
