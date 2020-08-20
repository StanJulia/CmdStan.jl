using DataFrames

# convert_a3d

# Method that allows federation by setting the `output_format`  in the Stanmodel().

"""

# convert_a3d

Convert the output file created by cmdstan to the shape of choice.

### Method
```julia
convert_a3d(a3d_array, cnames, ::Val{Symbol}; start=1)
```
### Required arguments
```julia
* `a3d_array::Array{Float64, 3},`      : Read in from output files created by cmdstan                                   
* `cnames::Vector{AbstractString}`     : Monitored variable names
```

### Optional arguments
```julia
* `::Val{Symbol}`                      : Output format, default is :mcmcchains
* `::start=1`                          : First draw for MCMCChains.Chains
```
Method called is based on the output_format defined in the stanmodel, e.g.:

   stanmodel = Stanmodel(`num_samples`=1200, thin=2, name="bernoulli", 
     model=bernoullimodel, `output_format`=:mcmcchains);

Current formats supported are:

1. :array (a3d_array format, the default for CmdStan)
2. :mcmcchains (MCMCChains.Chains object)
3. :dataframes (Array of DataFrames.DataFrame objects)
4. :namedtuple (NamedTuple object)

Option 2 is available if MCMCChains is loaded.
```

### Return values
```julia
* `res`                       : Draws converted to the specified format.
```
"""
convert_a3d(a3d_array, cnames, ::Val{:array}; start=1) = a3d_array

"""

# convert_a3d

# Convert the output file created by cmdstan to an Array of DataFrames.

$(SIGNATURES)

"""
function convert_a3d(a3d_array, cnames, ::Val{:dataframes}; start=1)
  snames = [Symbol(cnames[i]) for i in 1: length(cnames)]
  [DataFrame(a3d_array[:,:,i], snames) for i in 1:size(a3d_array, 3)]
end

"""

# convert_a3d

# Convert the output file created by cmdstan to NamedTuples.

$(SIGNATURES)

"""
function convert_a3d(a3d_array, cnames, ::Val{:namedtuple}; start=1)
  extract(a3d_array, cnames)
end

