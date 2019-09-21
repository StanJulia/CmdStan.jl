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
    if isfile("$(model.name)_$(res_type)_$(i).csv")
      
      ## A result type file for chain i is present ##
      
      if i == 1
        
        # Extract cmdstan version
        
        str = read("$(model.name)_$(res_type)_$(i).csv", String)
        sstr = split(str)
        tdict[:stan_major_version] = [parse(Int, sstr[4])]
        tdict[:stan_minor_version] = [parse(Int, sstr[8])]
        tdict[:stan_patch_version] = [parse(Int, sstr[12])]
      end
      
      # Position sstr at the beginning of last comment line
      
      sstr_lp = sstr[80]
      sstr_lp = parse(Float64, split(sstr_lp, '=')[2])
      
      if :lp in keys(tdict)
        append!(tdict[:lp], sstr_lp)
        append!(tdict[:var_id], parse(Int, sstr[91]))
        append!(tdict[:value], parse(Float64, sstr[92]))
        append!(tdict[:model], parse(Float64, sstr[93]))
        append!(tdict[:finite_dif], parse(Float64, sstr[94]))
        append!(tdict[:error], parse(Float64, sstr[95]))
      else
        
        # First time around, create value array
        
        tdict[:lp] = [sstr_lp]
        tdict[:var_id] = [parse(Int, sstr[91])]
        tdict[:value] = [parse(Float64, sstr[92])]
        tdict[:model] = [parse(Float64, sstr[93])]
        tdict[:finite_dif] = [parse(Float64, sstr[94])]
        tdict[:error] = [parse(Float64, sstr[95])]
      end
    end
  end
      
  (tdict, cnames)
  
end

