# Version approach and history

## Approach

A version of a Julia package is labeled (tagged) as v"major.minor.patch".

My intention is to update the patch level whenever I make updates which are not visible to any of the existing examples.

New functionality will be introduced in minor level updates. This includes adding new examples, tests and the introduction of new arguments if they default to previous behavior, e.g. in v"1.1.0" the useMamba and init arguments to Stanmodel().

Changes that require updates to some examples bump the major level.

Updates for new releases of Julia and cmdstan bump the appropriate level.

## Testing

Version 4.x of the package has been tested on Mac OSX 10.13 &14, Julia 0.7+ and cmdstan 2.17.1.

### Version 4.2.0

1. Added ability to reformat a3d_array to a TuringLang/MCMCChain object.
2. Added the ability to display the sample drawing progress in stdout (instead of storing these updated in the run_log_file)

### Version 4.1.0

1. Added ability to reformat a3d_array, e.g. to a DataFrame or a Mamba.Chains object using add-on packages such as StanDataFrames and StanMamba.
2. Allowed passing zero-length arrays as input.

### Version 4.0.0

1. Initial Julia 1.0 release of CmdStan.jl (based on Stan.jl).
_


