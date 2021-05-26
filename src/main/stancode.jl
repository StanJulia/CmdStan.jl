
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
* `samples`                       : Samples
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
  
  # old = pwd()
  local rc = 0
  local res = Dict[]
  cnames = String[]
    
  if length(model.model) == 0
    println("\nNo proper model specified in \"$(model.name).stan\".")
    println("This file is typically created from a String passed to Stanmodel().\n")
    return((-1, res))
  end
  
  @assert isdir(ProjDir) "Incorrect ProjDir specified: $(ProjDir)"
  @assert isdir(model.tmpdir) "$(model.tmpdir) not created"
  
  local tmpmodelname::String
  tmpmodelname = joinpath(model.tmpdir, model.name)
  file_paths = [
    joinpath(tmpmodelname * "_build.log"),
    joinpath(tmpmodelname * "_make.log"),
    joinpath(tmpmodelname * "_run.log")]

  for path in file_paths
    isfile(path) && rm(path)
  end

  if @static Sys.iswindows() ? true : false
    tmpmodelname = replace(tmpmodelname*".exe", "\\" => "/")
  end
  try
    cmd = setenv(`make $(tmpmodelname)`, ENV; dir=CmdStanDir)
    if file_make_log
      run(pipeline(cmd,
        stdout="$(tmpmodelname)_make.log",
        stderr="$(tmpmodelname)_build.log"))
    else
      run(pipeline(cmd,
        stderr="$(tmpmodelname)_build.log"))
    end
  catch
    println("\nAn error occurred while compiling the Stan program.\n")
    print("Please check your Stan program in variable '$(model.name)' ")
    print("and the contents of $(tmpmodelname)_build.log.\n")
    println("Note that Stan does not handle blanks in path names.")
    error("Return code = -3");
  end

  if data != Nothing && (typeof(data) <: AbstractString || check_dct_type(data))
    if typeof(data) <: AbstractString
      data_path = isabspath(data) ? data : joinpath(model.tmpdir, data)
      for i in 1:model.nchains
        cp(data_path, joinpath(model.tmpdir, "$(model.name)_$(i).data.R"), force=true)
      end
    else
      if typeof(data) <: Array && length(data) == model.nchains
        for i in 1:model.nchains
          if length(keys(data[i])) > 0
            update_R_file(joinpath(model.tmpdir, "$(model.name)_$(i).data.R"), data[i])
          end
        end
      else
        if typeof(data) <: Array
          for i in 1:model.nchains
            if length(keys(data[1])) > 0
              update_R_file(joinpath(model.tmpdir, "$(model.name)_$(i).data.R"), data[1])
            end
          end
        else
          for i in 1:model.nchains
            if length(keys(data)) > 0
              update_R_file(joinpath(model.tmpdir, "$(model.name)_$(i).data.R"), data)
            end
          end
        end
      end
    end
  end
  
  if init != Nothing && (typeof(init) <: AbstractString || check_dct_type(init))
    if typeof(init) <: AbstractString
      init_str = isabspath(init) ? init : joinpath(model.tmpdir, init)
      for i in 1:model.nchains
        cp(init_str, joinpath(model.tmpdir, "$(model.name)_$(i).init.R"), force=true)
      end
    else
      if typeof(init) <: Array && length(init) == model.nchains
        for i in 1:model.nchains
          if length(keys(init[i])) > 0
            update_R_file(joinpath(model.tmpdir, "$(model.name)_$(i).init.R"), init[i])
          end
        end
      else
        if typeof(init) <: Array
          for i in 1:model.nchains
            if length(keys(init[1])) > 0
              update_R_file(joinpath(model.tmpdir, "$(model.name)_$(i).init.R"), init[1])
            end
          end
        else
          for i in 1:model.nchains
            if length(keys(init)) > 0
              update_R_file(joinpath(model.tmpdir, "$(model.name)_$(i).init.R"), init)
            end
          end
        end
      end
    end
  end
  
  for i in 1:model.nchains
    model.id = i
    model.data_file = joinpath(model.tmpdir, "$(model.name)_$(i).data.R")
    if init != Nothing
        model.init_file = joinpath(model.tmpdir, "$(model.name)_$(i).init.R")
    end
    if isa(model.method, Sample)
      sample_file = joinpath(model.tmpdir, model.name*"_samples_$(i).csv")
      model.output.file = sample_file
      isfile(sample_file) && rm(sample_file)
      if diagnostics
        diagnostic_file = joinpath(model.tmpdir, model.name*"_diagnostics_$(i).csv")
        model.output.diagnostic_file = diagnostic_file
        isfile(diagnostic_file) && rm(diagnostic_file)
      end
    elseif isa(model.method, Optimize)
      optimize_file = joinpath(model.tmpdir, "$(model.name)_optimize_$(i).csv")
      isfile(optimize_file) && rm(optimize_file)
      model.output.file = optimize_file
    elseif isa(model.method, Variational)
      variational_file = joinpath(model.tmpdir, "$(model.name)_variational_$(i).csv")
      isfile(variational_file) && rm(variational_file)
      model.output.file = variational_file
    elseif isa(model.method, Diagnose)
      diagnose_file = joinpath(model.tmpdir, "$(model.name)_diagnose_$(i).csv")
      isfile(diagnose_file) && rm(diagnose_file)
      model.output.file = diagnose_file
    end
    model.command[i] = cmdline(model)
  end
  
  try
    if file_run_log
      run(pipeline(par(setenv.(model.command, Ref(ENV); dir=model.tmpdir)), stdout="$(model.name)_run.log"))
    else
      run(par(setenv.(model.command, Ref(ENV); dir=model.tmpdir)))
    end
  catch e
    println("\nAn error occurred while running the previously compiled Stan program.\n")
    print("Please check the contents of file $(model.name)_run.log and the")
    println("'command' field in the Stanmodel, e.g. stanmodel.command.\n")
    error("Return code = -5")
  end
  
  local samplefiles = String[]
  local ftype
  
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
    error("Return code = -10")
  end

  if model.output_format != :array
    start_sample = 1
    if isa(model.method, Sample) && !model.method.save_warmup
      start_sample = model.method.num_warmup+1
    end
    res = convert_a3d(res, cnames, Val(model.output_format);
      start=start_sample)
  end # cd(model.tmpdir)
  (rc, res, cnames)
end
