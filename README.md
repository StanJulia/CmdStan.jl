# CmdStan

*A package to run Stan's cmdstan executable from Julia.*

| **Documentation**                                                               | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][travis-img]][travis-url] [![][codecov-img]][codecov-url] |

## CmdStan.jl stargazers over time

[![Stargazers over time](https://starchart.cc/StanJulia/CmdStan.jl.svg)](https://starchart.cc/StanJulia/CmdStan.jl)

## Stan.jl stargazers over time

[![Stargazers over time](https://starchart.cc/StanJulia/Stan.jl.svg)](https://starchart.cc/StanJulia/Stan.jl)

## Prerequisites

For more info on Stan, please go to <http://mc-stan.org>.

The Julia package CmdStan.jl is based on Stan's command line interface, 'cmdstan'.

The 'cmdstan' interface needs to be installed separatedly. Please see [cmdstan installation](https://github.com/StanJulia/CmdStan.jl/blob/master/docs/src/INSTALLATION.md) for further details. 

The location of the cmdstan executable and related programs is now obtained from the environment variable JULIA_CMDSTAN_HOME. This used to be CMDSTAN_HOME.

Right now `versioninfo()` will show its setting (if defined).

## Versions

Release 6.0.8

1. Thanks to @yiyuezhuo, a function `extract` has been added to simplify grouping variables into a NamedTuple of Arrays.
2. Updated CSV.read to specify Dataframe argument

Release 6.0.7

1. Compatibility updates
2. Cmdstan version updates.

Release 6.0.2-6

1. Fixed an issue related to naming of created files. Thanks to mkshirazi.
2. Several bumps to deal with package versions.
3. Re-enabling Coverage.

Release 6.0.2

1. Init files were not properly included in cmd. Thanks to ueliwechsler and andrstef.

Release 6.0.1

1. Removed dependency on Documenter.

Release 6.0.0 contains:

1. Revert back to output an array by default.
2. Switch to Requires.jl to delay/prevent loading of MCMCChains if not needed (thanks to suggestions by @Byrth and Stijn de Waele).
3. Updates to documentation.

Release 6.0.0 is a breaking release. 

To revert back to v5.x behavior a script needs to include `using MCMCChains` (which thus must be installed) and specify `output_format=:mcmcchains` in the call to `stanmodel()`. This option is not tested on Travis. A sub-directory examples_mcmcchains has been added which demonstrate this usage pattern.

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
