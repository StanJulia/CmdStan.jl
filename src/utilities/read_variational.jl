"""

# read_variational

Read variational sample output files created by cmdstan. 

### Method
```julia
read_variational(m::Stanmodel)
```

### Required arguments
```julia
* `m::Stanmodel`    : Stanmodel object
```

"""
function read_variational(m::Stanmodel)

  local a3d, monitors, index, idx, indvec, ftype
  
  ftype = lowercase(string(typeof(m.method)))
  
  for i in 1:m.nchains
    if isfile("$(m.name)_$(ftype)_$(i).csv")
      instream = open("$(m.name)_$(ftype)_$(i).csv")
      skipchars(isspace, instream, linecomment='#')
      line = Unicode.normalize(readline(instream), newline2lf=true)
      idx = split(strip(line), ",")
      index = [idx[k] for k in 1:length(idx)]
      if length(m.monitors) == 0
        indvec = 1:length(index)
      else
        indvec = findall((in)(m.monitors), index)
      end
      if i == 1
        a3d = fill(0.0, m.method.output_samples, length(indvec), m.nchains)
      end
      skipchars(isspace, instream, linecomment='#')
      for j in 1:m.method.output_samples
        skipchars(isspace, instream, linecomment='#')
        line = Unicode.normalize(readline(instream), newline2lf=true)
        if eof(instream) && length(line) < 2
          close(instream)
          break
        else
          flds = parse.(Float64, (split(strip(line), ",")))
          flds = reshape(flds[indvec], 1, length(indvec))
          a3d[j,:,i] = flds
        end
      end
    end
  end
  
  cnames = convert.(String, idx[indvec])
  
  (a3d, cnames)
  
end

