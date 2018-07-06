# Just an example of convert_a3d, never called as the array format is
# the intermediate format

convert_a3d(res, cnames, ::Val{:array}) = res

#=

# Would be called if output_format=:dataframe, e.g.:

#   stanmodel = Stanmodel(num_samples=1200, thin=2, name="bernoulli", 
#   model=bernoullimodel, output_format=:dataframe);

using DataFrames

function convert_a3d(res, cnames, ::Val{:dataframe})
  [DataFrame(sim[:,:,i], convert(Array{Symbol}, cnames)) for i in 1:size(res, 3)]
end

# CmdStan does not depend on DataFrames. 

=#