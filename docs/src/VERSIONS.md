# Version approach and history

## Approach

A version of a Julia package is labeled (tagged) as v"major.minor.patch".

My intention is to update the patch level whenever I make updates which are not visible to any of the existing examples.

New functionality will be introduced in minor level updates. This includes adding new examples, tests and the introduction of new arguments if they default to previous behavior, e.g. in v"4.2.0" the `run_log_file` argument to stan().

Changes that require updates to some examples bump the major level.

Updates for new releases of Julia and cmdstan bump the appropriate level.

## Testing

Versions 6.x of the package has been developed and tested on Mac OSX 10.15.3, Julia 1.3+ and tested on cmdstan v2.21.0.

## Versions

### Release 6.0.2

1. Init files were not properly included in cmd. Thanks to ueliwechsler and andrstef.

### Release 6.0.1

1. Removed dependency on Documenter.

### Version 6.0.0

Release 6.0.0 is a breaking release. To revert back to v5.x behavior a script needs to include `using MCMCChains` (which thus must be installed) and specify `output_format=:mcmcchains` in the call to `stanmodel()`. This option is not tested on Travis, a sub-directory examples_mcmcchains has been added which demonstrate this usage pattern.

1. Revert back to output an array by default.
2. Switch to Requires.jl to delay/prevent loading of MCMCChains if not needed (thanks to suggestions by @Byrth and Stijn de Waele).
3. WIP: Redoing documentation. 

### Version 5.6.0

1. Simplification were possible, removal of some older constructs.
2. Removal of NamedArrays. This is mildly breaking. If needed it can be brought back using Requires.

### Version 5.5.0

1. Upper bound fixes.

### Version 5.4.0

1. Removed init and data from Stanmodel. Data and init needs to be specified (if needed) in stan(). This is a breaking change although it wasn't handled properly. Thanks to Andrei R. Akhmetzhanov and Chris Fisher.

### Version 5.2.3

1. Fixed an issue in running read_samples from the REPL (thanks to Graydon Marz).

### Version 5.2.2

1. Made sure by default no files are created in Julia's `package` directory.
2. Removed some DataFrame update warnings.

### Version 5.2.1 contains:

1. Fixed an issue with read_diagnose.jl which failed on either linux or osx because of slightly different .csv file layout.

### Version 5.2.0 contains:

1. Specified Julia 1 dependency in Project
2. Updates from sdewaele to fix resource busy or locked error messages
3. Thanks to Daniel Coutinho an issue was fixed which made running CmdStan using Atom bothersome.
4. Contains a fix in diagnostics testing

### Version 5.1.1 contains:

1. Fixed an issue with ```save_warmup``` in Variational (thanks to fargolo).
2. Fixed a documentation issue in ```rel_path_cmdstan```.
3. Enabled specifying ```data``` and ```init``` using an existing file.
4. Support for Stan's include facility (thanks to Chris Fisher).

CmdStan.jl tested on cmdstan v2.20.0.

### Version 5.1.0 contains:

1. Support for retrieving stansummary data (read_summary()).
2. Support for using mktempdir() (might improve issue #47).
3. Fixed handling of save_warmup.
4. Read all optimization iterations (thanks to sdewaele).
5. Several other minor documentation and type definition updates.
6. Fixeda bug related to Array{Dict} inputs to init and data (thanks to sdewaele).
7. Added a test to compare Stan's ESS values with MCMCChains ESS values.
8. Updated all examples to have a single Dict as data input (suggested by sdewaele).

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


