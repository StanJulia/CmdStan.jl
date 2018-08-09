# CmdStan

[![Build Status](https://travis-ci.org/StanJulia/CmdStan.jl.svg?branch=master)](https://travis-ci.org/StanJulia/CmdStan.jl) [![Coverage Status](https://coveralls.io/repos/StanJulia/CmdStan.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/StanJulia/CmdStan.jl?branch=master) [![codecov.io](http://codecov.io/github/StanJulia/CmdStan.jl/coverage.svg?branch=master)](http://codecov.io/github/StanJulia/CmdStan.jl?branch=master)

## Purpose

A package to use cmdstan (as an external program) from Julia v1.x and up. 

Documentation can be found [here](https://stanjulia.github.io/CmdStan.jl/latest/)

Cmdstan needs to be installed separatedly. Please see [cmdstan installation](http://StanJulia.github.io/CmdStan.jl/latest/INSTALLATION.html). 

For more info on Stan, please go to <http://mc-stan.org>.

## Breaking change

The location of the cmdstan executable and related programs is now obtained from the environment variable JULIA_CMDSTAN_HOME. This used to be CMDSTAN_HOME.

Right now `versioninfo()` will show its setting (if defined).

## Notes

Note 1: CmdStan.jl is part of the Github StanJulia organization set of packages. It's the primary interface to Stan's cmdstan executable. Most other envisaged packages are for post-sampling steps. The intention is to deprecate Stan.jl (or in fact under the cover use CmdStan.jl and StanMamba.jl as a replacement).

Note 2: Additional work is needed on documentation and at least on the next couple of packages in the StanJulia organization, i.e. StanDataFrames.jl and StanMamba.jl.

Note 3: Tested on Julia v0.7.0 and Julia v1.0.0
