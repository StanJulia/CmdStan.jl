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

## Note

Release 5.0.0 of CmdStan.jl is a major level update as it breaks several examples. The simplest way to revert back to the pre-5.0.0 behavior is to use the ```output_format=:array``` option in the call to StanModel().

By default a call to stan() will now return an MCMCChains.Chains object (which has been derived from the Mamba.Chains object). The Chains object has facilities for summarizing, diagnostics, plotting and further processing.

Release  5.1.1 contains:

1. Fixed an issue with ```save_warmup``` in Variational (thanks to fargolo).
2. Fixed a documentation issue in ```rel_path_cmdstan```.
3. Enabled specifying ```data``` and ```init``` using an existing file.

Release 5.1.0 contains:

1. Support for retrieving stansummary data (read_summary()).
2. Support for using mktempdir() (might improve issue #47).
3. Fixed handling of save_warmup.
4. Read all optimization iterations (thanks to sdewaele).
5. Several other minor documentation and type definition updates.
6. Fixeda bug related to Array{Dict} inputs to init and data (thanks to sdewaele).
7. Added a test to compare Stan's ESS values with MCMCChains ESS values.
8. Updated all examples to have a single Dict as data input (suggested by sdewaele).

CmdStan.jl has been tested on cmdstan v2.19.1.

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
