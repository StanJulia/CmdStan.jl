# CmdStan

[![Build Status](https://travis-ci.org/StanJulia/CmdStan.jl.svg?branch=master)](https://travis-ci.org/StanJulia/CmdStan.jl) [![Coverage Status](https://coveralls.io/repos/StanJulia/CmdStan.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/StanJulia/CmdStan.jl?branch=master) [![codecov.io](http://codecov.io/github/StanJulia/CmdStan.jl/coverage.svg?branch=master)](http://codecov.io/github/StanJulia/CmdStan.jl?branch=master)

## Purpose

A package to use cmdstan (as an external program) from Julia v1.x and up. 

Documentation can be found [here](https://stanjulia.github.io/CmdStan.jl/latest/)

Cmdstan needs to be installed separatedly. Please see [cmdstan installation](http://StanJulia.github.io/CmdStan.jl/latest/INSTALLATION.html). 

For more info on Stan, please go to <http://mc-stan.org>.

##

Note 1: CmdStan.jl is part of the Github StanJulia organization set of packages. It's the primary interface to Stan's cmdstan executable. Most other envisaged packages are for post-sampling steps. The intention is to deprecate Stan.jl.

Note 2: This is a pre-release, additional work is needed on documentation and at least on the next couple of packages in the StanJulia organization, i.e. StanDataFrames.jl and StanMamba.jl.
