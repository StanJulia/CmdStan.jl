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
  data::Vector{DataDict}
  data_file::String
  command::Vector{Base.AbstractCmd}
  method::Method
  random::Random
  init::Vector{DataDict}
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
  data=DataDict[],
  random=Random(),
  init=DataDict[],
  output=Output(),
  printsummary=true,
  pdir::String=pwd(),
  tmpdir::String=joinpath(pwd(), "tmp"),
  output_format=:mcmcchains
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
* `data::DataDict[]`           : Observed input data
* `random::Random`             : Random seed settings
* `init::DataDict[]`           : Initial values for parameters
* `output::Output`             : File output options
* `printsummary=true`          : Show computed stan summary
* `pdir::String`               : Working directory
* `tmpdir::String`             : Directory where output files are stored
* `output_format::Symbol `     : Output format
```

### CmdStan.jl supports 3 output_format values:
```julia     
1. :array           # Returns an array of draws
2. :namedarray      # Returns a NamedArrays object 
3. :mcmcchains      # Return an MCMCChains.Chains object (default)

The first 2 return an Array{Float64, 3} with ndraws, nvars, nchains
as indices. The 3rd option (the default) returns an
MCMCChains.Chains object.

Other options are availableby in:
1. StanDataFrames.jl
2. StanMamba.jl

See also `?CmdStan.convert_a3d`.
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
  data=DataDict[],
  random=Random(),
  init=DataDict[],
  output=Output(),
  printsummary=true,
  pdir::String=pwd(),
  tmpdir::String=joinpath(pwd(), "tmp"),
  output_format::Symbol=:mcmcchains)
  
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
    data, data_file, cmdarray, method, random,
    init, init_file, output, printsummary, pdir, tmpdir, output_format);
end

function model_show(io::IO, m::Stanmodel, compact::Bool)
  println("  name =                    \"$(m.name)\"")
  println("  nchains =                 $(m.nchains)")
  println("  num_samples =             $(m.num_samples)")
  println("  num_warmup =                $(m.num_warmup)")
  println("  thin =                    $(m.thin)")
  println("  monitors =                $(m.monitors)")
  println("  model_file =              \"$(m.model_file)\"")
  println("  data_file =               \"$(m.data_file)\"")
  println("  output =                  Output()")
  println("    file =                    \"$(m.output.file)\"")
  println("    diagnostics_file =        \"$(m.output.diagnostic_file)\"")
  println("    refresh =                 $(m.output.refresh)")
  println("  pdir =                   \"$(m.pdir)\"")
  println("  tmpdir =                 \"$(m.tmpdir)\"")
  println("  output_format =           :$(m.output_format)")
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
