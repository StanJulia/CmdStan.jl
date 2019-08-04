module CmdStan

using Reexport, NamedArrays, Pkg, DelimitedFiles, Unicode
@reexport using MCMCChains, Statistics

"""
The directory which contains the cmdstan executables such as `bin/stanc` and
`bin/stansummary`. Inferred from the environment variable `JULIA_CMDSTAN_HOME` or `ENV["JULIA_CMDSTAN_HOME"]`
when available.

If these are not available, use `set_cmdstan_home!` to set the value of CMDSTAN_HOME.

Example: `set_cmdstan_home!(homedir() * "/Projects/Stan/cmdstan/")`

Executing `versioninfo()` will display the value of `JULIA_CMDSTAN_HOME` if defined.
"""
CMDSTAN_HOME=""

function __init__()
  global CMDSTAN_HOME = if isdefined(Main, :JULIA_CMDSTAN_HOME)
    Main.JULIA_CMDSTAN_HOME
  elseif haskey(ENV, "JULIA_CMDSTAN_HOME")
    ENV["JULIA_CMDSTAN_HOME"]
  elseif haskey(ENV, "CMDSTAN_HOME")
    ENV["CMDSTAN_HOME"]
  else
    @warn("Environment variable CMDSTAN_HOME not set. Use set_cmdstan_home!.")
    ""
  end
end

"""Set the path for the `CMDSTAN_HOME` environment variable.

Example: `set_cmdstan_home!(homedir() * "/Projects/Stan/cmdstan/")`
"""
set_cmdstan_home!(path) = global CMDSTAN_HOME=path

const src_path = @__DIR__

"""

# `rel_path_cmdstan`

Relative path using the CmdStan.jl src directory. This approach has been copied from
[DynamicHMCExamples.jl](https://github.com/tpapp/DynamicHMCExamples.jl)

### Example to get access to the data subdirectory
```julia
rel_path_cmdstan("..", "data")
```
"""
rel_path_cmdstan(parts...) = normpath(joinpath(src_path, parts...))


include("main/stanmodel.jl")
include("main/stancode.jl")

# preprocessing

include("utilities/update_model_file.jl")
include("utilities/create_r_files.jl")
include("utilities/create_cmd_line.jl")

# run cmdstan

include("utilities/parallel.jl")

# used in postprocessing

include("utilities/read_samples.jl")
include("utilities/read_variational.jl")
include("utilities/read_diagnose.jl")
include("utilities/read_optimize.jl")
include("utilities/convert_a3d.jl")
include("utilities/stan_summary.jl")
include("utilities/read_summary.jl")
include("utilities/findall.jl")

# type definitions

include("types/sampletype.jl")
include("types/optimizetype.jl")
include("types/diagnosetype.jl")
include("types/variationaltype.jl")

export

# from this file
set_cmdstan_home!,
CMDSTAN_HOME,
rel_path_cmdstan,

# From stanmodel.jl
Stanmodel,

# From stancode.jl
stan,

# From sampletype.jl
Sample,

# From optimizetype.jl
Optimize,

# From diagnosetype.jl
Diagnose,

# From variationaltype.jl
Variational,

# From read_summary.jl
read_summary

end # module
