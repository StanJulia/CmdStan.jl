# CmdStan

*A package to run Stan's cmdstan executable from Julia.*

| **Documentation**                                                               | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][travis-img]][travis-url] [![][appveyor-img]][appveyor-url] [![][codecov-img]][codecov-url] |


## Prerequisites

For more info on Stan, please go to <http://mc-stan.org>.

The Julia package CmdStan.jl is based on Stan's command line interface, 'cmdstan'.

The 'cmdstan' interface needs to be installed separatedly. Please see [cmdstan installation](http://StanJulia.github.io/CmdStan.jl/latest/INSTALLATION.html) for further details. 

The location of the cmdstan executable and related programs is now obtained from the environment variable JULIA_CMDSTAN_HOME. This used to be CMDSTAN_HOME.

Right now `versioninfo()` will show its setting (if defined).

## Documentation

- [**STABLE**][docs-stable-url] &mdash; **documentation of the most recently tagged version.**
- [**DEVEL**][docs-dev-url] &mdash; *documentation of the in-development version.*

## Questions and issues

Question and contributions are very welcome, as are feature requests and suggestions. Please open an [issue][issues-url] if you encounter any problems or have a question. 

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
