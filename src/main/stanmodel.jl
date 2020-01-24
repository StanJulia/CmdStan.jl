import Base: show

"""

# Available top level Method

### Method
```julia
*  Sample::Method             : Sampling
*  Optimize::Method           : Optimization
*  Diagnose::Method           : Diagnostics
*  Variational::Method        : Variational Bayes
```
""" 
abstract type Method end

const DataDict = Dict{String, Any}

mutable struct Random
  seed::Int64
end
Random(;seed::Number=-1) = Random(seed)

mutable struct Output
  file::String
  diagnostic_file::String
  refresh::Int64
end
Output(;file::String="", diagnostic_file::String="", refresh::Number=100) =
  Output(file, diagnostic_file, refresh)

mutable struct Stanmodel
  name::String
  nchains::Int
  num_warmup::Int
  num_samples::Int
  thin::Int
  id::Int
  model::String
  model_file::String
  monitors::Vector{String}
  data_file::String
  command::Vector{Base.AbstractCmd}
  method::Method
  random::Random
  init_file::String
  output::Output
  printsummary::Bool
  pdir::String
  tmpdir::String
  output_format::Symbol
end

"""
# Method Stanmodel 

Create a Stanmodel. 

### Constructors
```julia
Stanmodel(
  method=Sample();
  name="noname", 
  nchains=4,
  num_warmup=1000, 
  num_samples=1000,
  thin=1,
  model="",
  monitors=String[],
  random=Random(),
  output=Output(),
  printsummary=false,
  pdir::String=pwd(),
  tmpdir::String=joinpath(pwd(), "tmp"),
  output_format=:array
)

```
### Required arguments
```julia
* `method::Method`             : See ?Method
```

### Optional arguments
```julia
* `name::String`               : Name for the model
* `nchains::Int`               : Number of chains
* `num_warmup::Int`            : Number of samples used for num_warmup
* `num_samples::Int`           : Sample iterations
* `thin::Int`                  : Stan thinning factor
* `model::String`              : Stan program source
* `monitors::String[] `        : Variables saved for post-processing
* `random::Random`             : Random seed settings
* `output::Output`             : File output options
* `printsummary=true`          : Show computed stan summary
* `pdir::String`               : Working directory
* `tmpdir::String`             : Directory where output files are stored
* `output_format::Symbol `     : Output format
```

Note: `data` or `init` can no longer be specified in Stanmodel. 
Please use stan() for this purpose.

### CmdStan.jl supports 3 output_format values:
```julia     
1. :array           # Returns an array of draws (default)
2. :mcmcchains      # Return an MCMCChains.Chains object
3. :dataframes      # Return an DataFrames.DataFrame object

The first options (the default) returns an Array{Float64, 3} with ndraws, nvars, nchains
as indices. The 2nd option returns an MCMCChains.Chains object, the 3rd a DataFrame object.
```

### Example
```julia
stanmodel = Stanmodel(num_samples=1200, thin=2, name="bernoulli", 
  model=bernoullimodel);
```

### Related help
```julia
?stan                                  : Run a Stanmodel
?CmdStan.Sample                        : Sampling settings
?CmdStan.Method                        : List of available methods
?CmdStan.Output                        : Output file settings
?CmdStan.DataDict                      : Input data
?CmdStan.convert_a3d                   : Options for output formats
```
"""
function Stanmodel(
  method=Sample();
  name="noname", 
  nchains=4,
  num_warmup=1000, 
  num_samples=1000,
  thin=1,
  model="",
  monitors=String[],
  random=Random(),
  output=Output(),
  printsummary=true,
  pdir::String=pwd(),
  tmpdir::String=joinpath(pwd(), "tmp"),
  output_format::Symbol=:array)
  
  if !isdir(tmpdir)
    mkdir(tmpdir)
  end

  model_file = "$(name).stan"
  if length(model) > 0
    update_model_file(joinpath(tmpdir, "$(name).stan"), strip(model))
  end
  
  id::Int=0
  data_file::String=""
  init_file::String=""
  cmdarray = fill(``, nchains)
  
  if num_samples != 1000
    method.num_samples=num_samples
  end
  
  if num_warmup != 1000
    method.num_warmup=num_warmup
  end
  
  if thin != 1
    method.thin=thin
  end

  Stanmodel(name, nchains, 
    num_warmup, num_samples, thin,
    id, model, model_file, monitors,
    data_file, cmdarray, method, random,
    init_file, output, printsummary, pdir, tmpdir, output_format);
end

function model_show(io::IO, m::Stanmodel, compact)
  println(io, "  name =                    \"$(m.name)\"")
  println(io, "  nchains =                 $(m.nchains)")
  println(io, "  num_samples =             $(m.num_samples)")
  println(io, "  num_warmup =                $(m.num_warmup)") 
  println(io, "  thin =                    $(m.thin)")
  println(io, "  monitors =                $(m.monitors)")
  println(io, "  model_file =              \"$(m.model_file)\"")
  println(io, "  data_file =               \"$(m.data_file)\"")
  println(io, "  output =                  Output()")
  println(io, "    file =                    \"$(m.output.file)\"")
  println(io, "    diagnostics_file =        \"$(m.output.diagnostic_file)\"")
  println(io, "    refresh =                 $(m.output.refresh)")
  println(io, "  pdir =                   \"$(m.pdir)\"")
  println(io, "  tmpdir =                 \"$(m.tmpdir)\"")
  println(io, "  output_format =           :$(m.output_format)")
  if isa(m.method, Sample)
    sample_show(io, m.method, compact)
  elseif isa(m.method, Optimize)
    optimize_show(io, m.method, compact)
  elseif isa(m.method, Variational)
    variational_show(io, m.method, compact)
  else
    diagnose_show(io, m.method, compact)
  end
end

show(io::IO, m::Stanmodel) = model_show(io, m, false)
