module CmdStan

using Compat, Pkg, Documenter, DelimitedFiles, Unicode

"""
The directory which contains the cmdstan executables such as `bin/stanc` and 
`bin/stansummary`. Inferred from `Main.CMDSTAN_HOME` or `ENV["CMDSTAN_HOME"]`
when available. Use `set_cmdstan_home!` to modify.
"""
CMDSTAN_HOME=""

function __init__()
    global CMDSTAN_HOME = if isdefined(Main, :CMDSTAN_HOME)
        eval(Main, :CMDSTAN_HOME)
    elseif haskey(ENV, "CMDSTAN_HOME")
        ENV["CMDSTAN_HOME"]
    else
        warn("Environment variable CMDSTAN_HOME not found. Use set_cmdstan_home!.")
        ""
    end
end

"""Set the path for the `CMDSTAN_HOME` environment variable.
    
Example: `set_cmdstan_home!(homedir() * "/Projects/Stan/cmdstan/")`
"""
set_cmdstan_home!(path) = global CMDSTAN_HOME=path

include("main/stanmodel.jl")
include("main/stancode.jl")

# preprocessing

include("utilities/update_model_file.jl")
include("utilities/create_r_files.jl")
include("utilities/create_cmd_line.jl")

# run cmdstan

include("utilities/parallel.jl")

# used in postprocessing

include("utilities/read_samples_or_diagnostics.jl")
include("utilities/read_variational.jl")
include("utilities/read_diagnose_or_optimize.jl")

# type definitions

include("types/sampletype.jl")
include("types/optimizetype.jl")
include("types/diagnosetype.jl")
include("types/variationaltype.jl")

export

# from this file
set_cmdstan_home!,
CMDSTAN_HOME,

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
Variational

end # module
