# Version approach and history

## Approach

A version of a Julia package is labeled (tagged) as v"major.minor.patch".

My intention is to update the patch level whenever I make updates which are not visible to any of the existing examples.

New functionality will be introduced in minor level updates. This includes adding new examples, tests and the introduction of new arguments if they default to previous behavior, e.g. in v"4.2.0" the `run_log_file` argument to stan().

Changes that require updates to some examples bump the major level.

Updates for new releases of Julia and cmdstan bump the appropriate level.

## Testing

Versions 5.x of the package has been tested on Mac OSX 10.14.4, Julia 1.1+ and cmdstan 2.19.1.

### Version 5.1.1

1. Fixed an issue with ```save_warmup``` in Variational (thanks to fargolo).
2. Fixed a documentation issue in ```rel_path_cmdstan```.
3. Enabled specifying ```data``` and ```init``` using an existing file.

### Version 5.1.0

1. Added support for retrieving stansummary data (read_summary()).
2. Added support for using mktempdir() (might improve issue #47).
3. Fixed handling of save_warmup.
4. Read all optimization iterations (thanks to sdewaele).
5. Several other minor documentation and type definitions.
6. Added a test to compare Stan's ESS values with MCMCChains ESS values.
7. An issue with the `init` Array{Dict} length not equal to the `data` Array{Dict} length is fixed (thanks to sdewaele).

### Version 5.0.0 (major level bump)

1. Incorporating MCMCChains.jl directly into CmdStan.jl. The old behavior is available by defining the ```output_format=:array``` in the call to StanModel.
2. Documentation typo corrections by @szcf-weiya.
3. StanMCMCChain.jl has been renamed to StanMCMCChains.jl.
4. More documentation fixes thanks to Oliver Dechant.

### Version 4.5.2

1. Mostly minor (but important) fixes in documentation (thanks to Oliver Dechant).
2. Supports non-array versions of input data and inits.
3. Announcement v5.x.x will be based on MCMCChains.jl. StanMCMCChains.jl will also be renamed accordingly (StanMCMCChains.jl) once MCMCChains.jl is registered.

### Version 4.4.0

1. Pkg3 based.
2. Added the output_format option :namedarray which will return a NamesArrays object instead of the a3d array.

### Version 4.2.0/4.3.0

1. Added ability to reformat a3d_array to a TuringLang/MCMCChain object.
2. Added the ability to display the sample drawing progress in stdout (instead of storing these updated in the run_log_file)

### Version 4.1.0

1. Added ability to reformat a3d_array, e.g. to a DataFrame or a Mamba.Chains object using add-on packages such as StanDataFrames and StanMamba.
2. Allowed passing zero-length arrays as input.

### Version 4.0.0

1. Initial Julia 1.0 release of CmdStan.jl (based on Stan.jl).
_


