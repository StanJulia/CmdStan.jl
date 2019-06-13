"""

# read_stanrun_samples

Read sample output files created by stanrun. 

### Method
```julia
read_stanrun_samples(loc, base_name, nsample, nchains)
```

### Required arguments
```julia
* `output_base`    : Location of tmp directoty
* `name_base`    : Base name of .csv files
* `nsamples=1000`    : No of samples
* `nchains=4`    :  No of chains
```

"""
function read_stanrun_samples(output_base, name_base, nsamples=1000, nchains=4)

  local a3d, monitors, index, idx, indvec, ftype, noofsamples

  # a3d will contain the samples such that a3d[s, i, c] where

  #   s: nsamples
  #   i: variables (read from .csv file produiced by cmdstan)
  #   c: nchains

  # Read .csv files created by each chain
  
  for i in 1:nchains
    if isfile(output_base*name_base*"_$(i).csv")
      #noofsamples = 0
      instream = open(output_base*name_base*"_$(i).csv")
      #
      # Skip initial set of commented lines, e.g. containing cmdstan version info, etc.
      #
      skipchars(isspace, instream, linecomment='#')
      #
      # First non-comment line contains names of variables
      #
      line = Unicode.normalize(readline(instream), newline2lf=true)
      idx = split(strip(line), ",")
      index = [idx[k] for k in 1:length(idx)]      
      indvec = 1:length(index)
      
      if i == 1
        a3d = fill(0.0, nsamples, length(indvec), nchains)
      end
      
      #println(size(a3d))
      skipchars(isspace, instream, linecomment='#')
      for j in 1:nsamples
        skipchars(isspace, instream, linecomment='#')
        line = Unicode.normalize(readline(instream), newline2lf=true)
        if eof(instream) && length(line) < 2
          close(instream)
          break
        else
          flds = parse.(Float64, split(strip(line), ","))
          flds = reshape(flds[indvec], 1, length(indvec))
          a3d[j,:,i] = flds
        end
      end   # read in samples
    end   # read in next file
  end   # read in file for each chain
  
  cnames = convert.(String, idx[indvec])
  
  (a3d, cnames)
  
end   # end of read_samples
