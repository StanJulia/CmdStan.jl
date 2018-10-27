# CmdStan

[![Build Status](https://travis-ci.org/StanJulia/CmdStan.jl.svg?branch=master)](https://travis-ci.org/StanJulia/CmdStan.jl) [![Coverage Status](https://coveralls.io/repos/StanJulia/CmdStan.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/StanJulia/CmdStan.jl?branch=master) [![codecov.io](http://codecov.io/github/StanJulia/CmdStan.jl/coverage.svg?branch=master)](http://codecov.io/github/StanJulia/CmdStan.jl?branch=master)

## Purpose

A package to use cmdstan (as an external program) from Julia v1.x and up. 

For more info on Stan and cmdstan, please go to <http://mc-stan.org>.

Documentation can be found [here](https://stanjulia.github.io/CmdStan.jl/latest/)

Cmdstan needs to be installed separatedly. Please see [cmdstan installation](http://StanJulia.github.io/CmdStan.jl/latest/INSTALLATION.html). 

For more info on Stan, please go to <http://mc-stan.org>.

## Added feature in version 4.4.0

This version is Pkg3 based, i.e. contains a Project.toml file.

Al;so includes NamedArray as output_format.

## Added feature in version 4.2.0

The call to stan() now has an option `file_run_log=true`. By default it will create the runlog file in the tmp directory. Setting it to false will write sampling progess to stdout. This is useful for cases where the sampling process is slow.

## Breaking change

The location of the cmdstan executable and related programs is now obtained from the environment variable JULIA_CMDSTAN_HOME. This used to be CMDSTAN_HOME.

Right now `versioninfo()` will show its setting (if defined).

## Notes

Note 1: CmdStan.jl is part of the Github StanJulia organization set of packages. It's the primary interface to Stan's cmdstan executable. Most other envisaged packages are for post-sampling steps. The intention is to deprecate Stan.jl (or in fact under the cover use CmdStan.jl and StanMamba.jl as a replacement).

Note 2: Works with several other packages in the StanJulia organization, i.e. StanMamba,
StanDataFrames and StanMCMCChain. StanMambaExamples.jl and StanMCMCChainExamples are under development.
Note 3: Tested on Julia v1.0 and Julia 1.1-dev

Note 4: For now the build.jl is skipped. Please let me know if this is inconvenient.
