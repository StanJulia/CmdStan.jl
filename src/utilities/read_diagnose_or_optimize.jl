"""

# read_stanfit 

Rewrite dct to R format in file. 

### Method
```julia
par(cmds)
```

### Required arguments
```julia
* `cmds::Array{Base.AbstractCmd,1}`    : Multiple commands to concatenate

or

* `cmd::Base.AbstractCmd`              : Single command to be
* `n::Number`                            inserted n times into cmd


or
* `cmd::Array{String, 1}`              : Array of cmds as Strings
```

"""
function read_diagnose_or_optimize(model::Stanmodel)
  
  ## Collect the results of a chain in an array ##
  
  chainarray = Dict[]
  cnames = String[]
  
  ## Each chain dictionary can contain up to 5 types of results ##
  
  result_type_files = ["optimize", "diagnose"]
  rtdict = Dict()
  
  ## tdict contains the arrays of values ##
  tdict = Dict()
  
  for i in 1:model.nchains
    for res_type in result_type_files
      if isfile("$(model.name)_$(res_type)_$(i).csv")
        ## A result type file for chain i is present ##
        ## Result type diagnose needs special treatment ##
        instream = open("$(model.name)_$(res_type)_$(i).csv")
        if res_type == "diagnose"
          tdict = Dict()
          str = read(instream, String)
          sstr = split(str)
          tdict = merge(tdict, Dict(:stan_major_version => [parse(Int, sstr[4])]))
          tdict = merge(tdict, Dict(:stan_minor_version => [parse(Int, sstr[8])]))
          tdict = merge(tdict, Dict(:stan_patch_version => [parse(Int, sstr[12])]))
          sstr_lp = sstr[79]
          sstr_lp = parse(Float64, split(sstr_lp, '=')[2])
          tdict = merge(tdict, Dict(:lp => [sstr_lp]))
          tdict = merge(tdict, Dict(:var_id => [parse(Int, sstr[90])]))
          tdict = merge(tdict, Dict(:value => [parse(Float64, sstr[91])]))
          tdict = merge(tdict, Dict(:model => [parse(Float64, sstr[92])]))
          tdict = merge(tdict, Dict(:finite_dif => [parse(Float64, sstr[93])]))
          tdict = merge(tdict, Dict(:error => [parse(Float64, sstr[94])]))
        else
          #println("Type of result file is $(res_type)")
          tdict = Dict()
          skipchars(isspace, instream, linecomment='#')
          line = Unicode.normalize(readline(instream), newline2lf=true)
          idx = split(strip(line), ",")
          index = [idx[k] for k in 1:length(idx)]
          cnames = convert.(String, idx)
  
          #res_type == "optimize" && println(index)
          
          j = 0
          skipchars(isspace, instream, linecomment='#')
          while true
            j += 1
            #skipchars(isspace, instream, linecomment='#')
            line = Unicode.normalize(readline(instream), newline2lf=true)
            flds = Float64[]
            if eof(instream) && length(line) < 2
              #println("EOF detected")
              close(instream)
              #return(tdict)
              break
            else
              #println(split(strip(line)))
              flds = parse.(Float64, split(strip(line), ","))
              for k in 1:length(index)
                if j ==1
                  tdict = merge(tdict, Dict(index[k] => [flds[k]]))
                else
                  tdict[index[k]] = push!(tdict[index[k]], flds[k])
                end
              end
            end
          end
        end
        
      end
      
      ## End of processing result type file ##
      ## If any keys were found, merge it in the rtdict ##
      
      if length(keys(tdict)) > 0
        #println("Merging $(res_type) with keys $(keys(tdict))")
        rtdict = merge(rtdict, Dict(res_type => tdict))
        tdict = Dict()
      end
    end
    
    ## If rtdict has keys, push it to the chain array ##
    
    if length(keys(rtdict)) > 0
      #println("Pushing the rtdict with keys $(keys(rtdict))")
      push!(chainarray, rtdict)
      rtdict = Dict()
    end
  end
  
  (chainarray, cnames)
  
end

