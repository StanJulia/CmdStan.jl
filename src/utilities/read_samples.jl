using DelimitedFiles, Unicode

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
function read_samples(m::Stanmodel, diagnostics=false, warmup_samples=false)

  local monitors, index, idx, indvec, ftype, noofsamples

  # a3d will contain the samples such that a3d[s, i, c] where

  #   s:  the sample index (corrected warmup samples and thinning by cmdstan)
  #   i:  variable name (either from monitors or read from .csv file produiced by cmdstan)
  #   c:  chain number (from m.chains)

  if isa(m.method, Sample)
    ftype = diagnostics ? "diagnostics" : "samples"
    
    # The sample index s runs from 1:noofsamples
  
    if m.method.save_warmup
      noofsamples = floor(Int, (m.method.num_samples+m.method.num_warmup)/m.method.thin)
    else
      noofsamples = floor(Int, m.method.num_samples/m.method.thin)
    end
  else
    ftype = lowercase(string(typeof(m.method)))
    
    # The noofsamples is obtained from method.output_samples
  
    noofsamples = m.method.output_samples
  end
  
  # Read .csv files created by each chain
  
  for i in 1:m.nchains
    if isfile("$(m.name)_$(ftype)_$(i).csv")
      
      instream = open("$(m.name)_$(ftype)_$(i).csv")
        
      # Skip initial set of commented lines, e.g. containing
      # cmdstan version info, etc.
      
      skipchars(isspace, instream, linecomment='#')
      
      # First non-comment line contains names of variables
      
      line = Unicode.normalize(readline(instream), newline2lf=true)
      idx = split(strip(line), ",")
      index = [idx[k] for k in 1:length(idx)]
      
      # Only continue with monitored variables
      
      if length(m.monitors) == 0
        indvec = 1:length(index)
      else
        indvec = findall((in)(m.monitors), index)
      end
      
      # Preserve cnames and create a3d
      
      if i == 1
        global cnames = convert.(String, idx[indvec])
        global a3d = fill(0.0, noofsamples, length(indvec), m.nchains)
      end
      
      # Read in the samples for all chains
      
      skipchars(isspace, instream, linecomment='#')
      for j in 1:noofsamples
        skipchars(isspace, instream, linecomment='#')
        line = Unicode.normalize(readline(instream), newline2lf=true)
        if eof(instream) && length(line) < 2
          return
        else
          flds = parse.(Float64, split(strip(line), ","))
          flds = reshape(flds[indvec], 1, length(indvec))
          a3d[j,:,i] = flds
        end
      end   # read in samples  
    end   # select next file if it exists
  end   # loop over all chains
  
  (a3d, cnames)
  
end   # end of read_samples
