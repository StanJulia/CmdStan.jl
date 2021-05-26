using DataFrames, CSV

"""

# read_summary

Read summary output file created by stansummary. 

### Method
```julia
read_summary(m::Stanmodel)
```

### Required arguments
```julia
* `m::Stanmodel`    : Stanmodel object
```

"""
function read_summary(m::Stanmodel)

  fname = joinpath(m.tmpdir, "$(m.name)_summary.csv")
  !isfile(fname) && stan_summary(m)
  
  df = CSV.read(fname, DataFrame; delim=",", comment="#")
  
  cnames = lowercase.(convert.(String, String.(names(df))))
  cnames[1] = "parameters"
  cnames[4] = "std"
  cnames[8] = "ess"
  #names!(df, Symbol.(cnames))
  rename!(df, Symbol.(cnames), makeunique = true)
  df.parameters = Symbol.(df.parameters)
  
  df
  
end   # end of read_samples
