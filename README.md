# CmdStan

*A package to run Stan's cmdstan executable from Julia.*

| **Documentation**                                                               | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][travis-img]][travis-url] [![][codecov-img]][codecov-url] |

## Prerequisites

For more info on Stan, please go to <http://mc-stan.org>.

The Julia package CmdStan.jl is based on Stan's command line interface, 'cmdstan'.

The 'cmdstan' interface needs to be installed separatedly. Please see [cmdstan installation](https://github.com/StanJulia/CmdStan.jl/blob/master/docs/src/INSTALLATION.md) for further details. 

The location of the cmdstan executable and related programs is now obtained from the environment variable JULIA_CMDSTAN_HOME. This used to be CMDSTAN_HOME.

Right now `versioninfo()` will show its setting (if defined).

## Versions

Release 6.0.2

1. Init files were not properly included in cmd. Thanks to ueliwechsler and andrstef.

Release 6.0.1

1. Removed dependency on Documenter.

Release 6.0.0 contains:

1. Revert back to output an array by default.
2. Switch to Requires.jl to delay/prevent loading of MCMCChains if not needed (thanks to suggestions by @Byrth and Stijn de Waele).
3. Updates to documentation. 

Release 6.0.0 is a breaking release. To revert back to v5.x behavior a script needs to include `using MCMCChains` (which thus must be installed) and specify `output_format=:mcmcchains` in the call to `stanmodel()`. This option is not tested on Travis. A sub-directory examples_mcmcchains has been added which demonstrate this usage pattern.

Release 5.6.0 contains:

1. Simplification were possible, removal of some older constructs.
2. Removal of NamedArrays. This is mildly breaking. If needed it can be brought back using Requires.

Release 5.5.0 contains:

1. Upper bound fixes.

Release 5.4.0 contains:

1. Removed init and data from Stanmodel. Data and init needs to be specified (if needed) in stan(). This is a breaking change although it wasn't handled properly. Thanks to Andrei R. Akhmetzhanov and Chris Fisher.

Release 5.2.3 contains:

1. Fixed an issue in running read_samples from the REPL (thanks to Graydon Marz).

Release 5.2.2 contains:

1. Made sure by default no files are created in Julia's `package` directory.
2. Removed some DataFrame update warnings.

Release 5.2.1 contains:

1. Fixed an issue with read_diagnose.jl which failed on either linux or osx because of slightly different .csv file layout.

Release 5.2.0 contains:

1. Specified Julia 1 dependency in Project
2. Updates from sdewaele to fix resource busy or locked error messages
3. Thanks to Daniel Coutinho an issue was fixed which made running CmdStan using Atom bothersome.
4. Contains a fix in diagnostics testing

Release 5.1.1 contains:

1. Fixed an issue with ```save_warmup``` in Variational (thanks to fargolo).
2. Fixed a documentation issue in ```rel_path_cmdstan```.
3. Enabled specifying ```data``` and ```init``` using an existing file.
4. Support for Stan's include facility (thanks to Chris Fisher).

Release 5.1.0 contains:

1. Support for retrieving stansummary data (read_summary()).
2. Support for using mktempdir() (might improve issue #47).
3. Fixed handling of save_warmup.
4. Read all optimization iterations (thanks to sdewaele).
5. Several other minor documentation and type definition updates.
6. Fixeda bug related to Array{Dict} inputs to init and data (thanks to sdewaele).
7. Added a test to compare Stan's ESS values with MCMCChains ESS values.
8. Updated all examples to have a single Dict as data input (suggested by sdewaele).

CmdStan.jl tested on cmdstan v2.21.0.

## Documentation

- [**STABLE**][docs-stable-url] &mdash; **documentation of the most recently tagged version.**
- [**DEVEL**][docs-dev-url] &mdash; *documentation of the in-development version.*

## Questions and issues

Question and contributions are very welcome, as are feature requests and suggestions. Please open an [issue][issues-url] if you encounter any problems or have a question.

## References

There is no shortage of good books on Bayesian statistics. A few of my favorites are:

1. [Bolstad: Introduction to Bayesian statistics](http://www.wiley.com/WileyCDA/WileyTitle/productCd-1118593227.html)

2. [Bolstad: Understanding Computational Bayesian Statistics](http://www.wiley.com/WileyCDA/WileyTitle/productCd-0470046090.html)

3. [Gelman, Hill: Data Analysis using regression and multileve,/hierachical models](http://www.stat.columbia.edu/~gelman/arm/)

4. [McElreath: Statistical Rethinking](http://xcelab.net/rm/statistical-rethinking/)

5. [Gelman, Carlin, and others: Bayesian Data Analysis](http://www.stat.columbia.edu/~gelman/book/)

6. [Lee, Wagenmakers: Bayesian Cognitive Modeling](https://www.cambridge.org/us/academic/subjects/psychology/psychology-research-methods-and-statistics/bayesian-cognitive-modeling-practical-course?format=PB&isbn=9781107603578)

7. [Kruschke:Doing Bayesian Data Analysis](https://sites.google.com/site/doingbayesiandataanalysis/what-s-new-in-2nd-ed)

and a great read (and implemented in DynamicHMC.jl):

8. [Betancourt: A Conceptual Introduction to Hamiltonian Monte Carlo](https://arxiv.org/abs/1701.02434)

CmdStan.jl and several other Julia based mcmc packages are used in  [StatisticalRethinking.jl](https://github.com/StatisticalRethinkingJulia)

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
