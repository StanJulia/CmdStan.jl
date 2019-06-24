"""

# Method stan_summary

Display cmdstan summary 

### Method
```julia
stan_summary(
  model::StanModel,
  file::String; 
  CmdStanDir=CMDSTAN_HOME
)
```
### Required arguments
```julia
* `model::Stanmodel             : Stanmodel
* `file::String`                : Name of file with samples
```

### Optional arguments
```julia
* CmdStanDir=CMDSTAN_HOME       : cmdstan directory for stansummary program
```

### Related help
```julia
?Stan.stan                      : Execute a StanModel
```
"""
function stan_summary(model::Stanmodel, file::String; 
  CmdStanDir=CMDSTAN_HOME)
  try
    pstring = joinpath("$(CmdStanDir)", "bin", "stansummary")
    csvfile = "$(model.name)_summary.csv"
    isfile(csvfile) && rm(csvfile)
    cmd = `$(pstring) --csv_file=$(csvfile) $(file)`
    resfile = open(cmd; read=true)
    println("Setting $(model.printsummary)")
    model.printsummary && print(read(resfile, String))
  catch e
    println(e)
  end
end

"""

# Method stan_summary

Display cmdstan summary 

### Method
```julia
stan_summary(
  model::Stanmodel
  filecmd::Cmd; 
  CmdStanDir=CMDSTAN_HOME
)
```
### Required arguments
```julia
* `model::Stanmodel`            : Stanmodel
* `filecmd::Cmd`                : Run command containing names of sample files
```

### Optional arguments
```julia
* CmdStanDir=CMDSTAN_HOME       : cmdstan directory for stansummary program
```

### Related help
```julia
?Stan.stan                      : Create a StanModel
```
"""
function stan_summary(model::Stanmodel, filecmd::Cmd;
    CmdStanDir=CMDSTAN_HOME)
  try
    pstring = joinpath("$(CmdStanDir)", "bin", "stansummary")
    csvfile = "$(model.name)_summary.csv"
    isfile(csvfile) && rm(csvfile)
    cmd = `$(pstring) --csv_file=$(csvfile) $(filecmd)`
    if model.printsummary
      resfile = open(cmd; read=true)
      print(read(resfile, String))
    else
      run(pipeline(cmd, stdout="out.txt"))
    end
  catch e
    println(e)
    println("Stan.jl caught above exception in Stan's 'stansummary' program.")
    println("This is a usually caused by the setting:")
    println("  Sample(save_warmup=true, thin=n)")
    println("in the call to stanmodel() with n > 1.")
    println()
  end
end
