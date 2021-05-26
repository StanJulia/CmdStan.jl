using DelimitedFiles, Unicode

"""

# read_diagnose

Read diagnose output file created by cmdstan. 

### Method
```julia
read_diagnose(m::Stanmodel)
```

### Required arguments
```julia
* `m::Stanmodel`    : Stanmodel object
```

"""
function read_diagnose(model::Stanmodel)
  
  ## Collect the results of a chain in an array ##
  
  cnames = String[]
  res_type = "diagnose"
  tdict = Dict()
  local sstr
  
  for i in 1:model.nchains
    file_path = joinpath(model.tmpdir, "$(model.name)_$(res_type)_$(i).csv")
    if isfile(file_path)
      
      ## A result type file for chain i is present ##
      
      if i == 1
        
        # Extract cmdstan version
        
        str = read(file_path, String)
        sstr = split(str)
        tdict[:stan_version] = "$(parse(Int, sstr[4])).$(parse(Int, sstr[8])).$(parse(Int, sstr[12]))"
      end
      
      # Position sstr at element with with `probability=...`
      
      indx = findall(x -> length(x)>11 && x[1:11] == "probability", sstr)[1]
      sstr_lp = sstr[indx]
      sstr_lp = parse(Float64, split(sstr_lp, '=')[2])
      
      if :lp in keys(tdict)
        append!(tdict[:lp], sstr_lp)
        append!(tdict[:var_id], parse(Int, sstr[indx+11]))
        append!(tdict[:value], parse(Float64, sstr[indx+12]))
        append!(tdict[:model], parse(Float64, sstr[indx+13]))
        append!(tdict[:finite_dif], parse(Float64, sstr[indx+14]))
        append!(tdict[:error], parse(Float64, sstr[indx+15]))
      else
        
        # First time around, create value array
        
        tdict[:lp] = [sstr_lp]
        tdict[:var_id] = [parse(Int, sstr[indx+11])]
        tdict[:value] = [parse(Float64, sstr[indx+12])]
        tdict[:model] = [parse(Float64, sstr[indx+13])]
        tdict[:finite_dif] = [parse(Float64, sstr[indx+14])]
        tdict[:error] = [parse(Float64, sstr[indx+15])]
      end
    end
  end
      
  (tdict, cnames)
  
end

