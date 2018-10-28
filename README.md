# CmdStan

*A package to run Stan's cmdstan executable from Julia.*

| **Documentation**                                                               | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][travis-img]][travis-url] [![][appveyor-img]][appveyor-url] [![][codecov-img]][codecov-url] |


## Purpose

A package to use cmdstan (as an external program) from Julia v1.x and up. 

For more info on Stan and cmdstan, please go to <http://mc-stan.org>.

Documentation can be found [here](https://stanjulia.github.io/CmdStan.jl/latest/)

Cmdstan needs to be installed separatedly. Please see [cmdstan installation](http://StanJulia.github.io/CmdStan.jl/latest/INSTALLATION.html). 

For more info on Stan, please go to <http://mc-stan.org>.

## Documentation

- [**STABLE**][docs-stable-url] &mdash; **documentation of the most recently tagged version.**
- [**DEVEL**][docs-dev-url] &mdash; *documentation of the in-development version.*

## Added feature in version 4.4.0

This version is Pkg3 based, i.e. contains a Project.toml file.

Al;so includes NamedArray as output_format.

## Added feature in version 4.2.0/4.3.0

The call to stan() now has an option `file_run_log=true`. By default it will create the runlog file in the tmp directory. Setting it to false will write sampling progess to stdout. This is useful for cases where the sampling process is slow.

## Breaking change

The location of the cmdstan executable and related programs is now obtained from the environment variable JULIA_CMDSTAN_HOME. This used to be CMDSTAN_HOME.

Right now `versioninfo()` will show its setting (if defined).

## Questions and issues

Question and contributions are very welcome, as are feature requests and suggestions. Please open an [issue][issues-url] if you encounter any problems or have a question. 


## Notes

Note 1: CmdStan.jl is part of the Github StanJulia organization set of packages. It's the primary interface to Stan's cmdstan executable. Most other envisaged packages are for post-sampling steps. The intention is to deprecate Stan.jl (or in fact under the cover use CmdStan.jl and StanMamba.jl as a replacement).

Note 2: Works with several other packages in the StanJulia organization, i.e. StanMamba,
StanDataFrames and StanMCMCChain. StanMambaExamples.jl and StanMCMCChainExamples are under development.

Note 3: Tested on Julia v1.0 and Julia 1.1-dev

Note 4: For now the build.jl is skipped. Please let me know if this is inconvenient.


[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://stanjulia.github.io/CmdStan.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://stanjulia.github.io/CmdStan.jl/stable

[travis-img]: https://travis-ci.org/StanJulia/CmdStan.jl.svg?branch=master
[travis-url]: https://travis-ci.org/StanJulia/CmdStan.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/xx7nimfpnl1r4gx0?svg=true
[appveyor-url]: https://ci.appveyor.com/project/StanJulia/CmdStan-jl

[codecov-img]: https://codecov.io/gh/StanJulia/CmdStan.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/StanJulia/CmdStan.jl

[issues-url]: https://github.com/StanJulia/CmdStan.jl/issues
