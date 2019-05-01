using DataFrames, Unicode, DelimitedFiles, MCMCChains
"""

# read_samples

Read sample output files created by cmdstan. 

### Method
```julia
read_samples(m::Stanmodel)
```

### Required arguments
```julia
* `m::Stanmodel`    : Stanmodel object
```

"""
function read_summary(m::Stanmodel, pdir=ProjDir)

#    if isfile("$(m.name)_$(ftype)_$(i).csv")

  instream = open(pdir*"/tmp/$(m.name)_summary.csv")
  skipchars(isspace, instream, linecomment='#')
  #
  # First non-comment line contains names of variables
  #
  line = Unicode.normalize(readline(instream), newline2lf=true)
  idx = split(strip(line), ",")
  index = [idx[k] for k in 1:length(idx)]

  if length(m.monitors) == 0
    indvec = 1:length(index)
  else
    indvec = findall((in)(m.monitors), index)
  end

  cnames = lowercase.(convert.(String, idx[indvec]))
  cnames[1] = "parameters"
  cnames[4] = "std"
  cnames[8] = "ess"
  
  rowno = 1; no_of_cols = 10
  mat = [[]]  
  for i in 1:no_of_cols-1
    append!(mat, [[]])
  end
  row = Vector{Any}(undef, no_of_cols)
  while !eof(instream)
    skipchars(isspace, instream, linecomment='#')
    line = Unicode.normalize(readline(instream), newline2lf=true)
    if eof(instream) && length(line) < 2
      close(instream)
      break
    else
      skipchars(isspace, instream, linecomment='#')
      line = split(line, ",")
      append!(mat[1], [Symbol(line[1][2:end-1])])
      for i in 2:no_of_cols
        append!(mat[i], [parse.(Float64, line[i])])
      end
    end
  end
  
  df = DataFrame()
  
  for (i, var) in enumerate(cnames)
    df[Symbol(var)] = mat[i]
  end
  
  ChainDataFrame("CmdStan Summary", df)
  
end   # end of read_samples
