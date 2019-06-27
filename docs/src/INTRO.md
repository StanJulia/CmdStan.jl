# A Julia interface to cmdstan

## CmdStan.jl

[Stan](https://github.com/stan-dev/stan) is a system for statistical modeling, data analysis, and prediction. It is extensively used in social, biological, and physical sciences, engineering, and business. The Stan program language and interfaces are documented [here](http://mc-stan.org/documentation/).

[cmdstan](http://mc-stan.org/interfaces/cmdstan.html) is the shell/command line interface to run Stan language programs. 

[CmdStan.jl](https://github.com/StanJulia/CmdStan.jl) wraps cmdstan and captures the samples for further processing.

## StanJulia

CmdStan.jl is part of the [StanJulia Github organization](https://github.com/StanJulia) set of packages. It captures draws from a Stan language program and returns by default an MCMCChains.Chains object. As much as possible an attempt has been made to leverage the MCMCChains.jl package for diagnostics, postprocessing and to make comparisons with other mcmc packages easier.

On a very high level, a typical workflow for using StanJulia and handle postprocessing by TuringLang's MCMCChains.jl, will look like:

```
using CmdStan, StatsBase

# Define a Stan language program.
bernoulli = "..."

# Prepare for calling cmdstan.
stanmodel = StanModel(...)

# Compile and run Stan program, collect draws.
rc, chns, cnames = stan(...)

# Summary of result
describe(chns) 

# Example of postprocessing, e.g. Highest Posterior Density Interval.
MCMCChains.hpd(chns)

# Plot the draws.
plot(chns)
```

This workflow creates an [MCMCChains.Chains](https://github.com/TuringLang/MCMCChains.jl) object for summarizing, diagnostics, plotting and further processing.

Another option is to convert the array of draws to a DataFrame using [StanDataFrames.jl](https://github.com/StanJulia/StanDataFrames.jl). This latter option is also available in the MCMCChains package through methods like `DataFrame(...)` and `Array(...)`. A similar workflow is available for Mamba [StanMamba.jl](https://github.com/StanJulia/StanMamba.jl). 

The default value for the `output_format` argument in Stanmodel() is :mcmcchains which causes stan() to call a conversion method ```convert_a3d()``` that returns the MCMCChains.Chains object.

Other values for `output_format` are available, i.e. :array, :namedarray, :dataframe and :mambachain. CmdStan.jl provides the output_format options :mcmcchains, :array and :namedarray. The associated methods for the latter two options are provided by StanDataFrames and StanMamba. 

## Other MCMC options in Julia

[Mamba.jl](http://mambajl.readthedocs.io/en/latest/),  [Klara.jl](http://klarajl.readthedocs.io/en/latest/), [DynamicHMC.jl](https://github.com/tpapp/DynamicHMC.jl) and [Turing.jl](https://github.com/TuringLang/Turing.jl) are other Julia packages to run MCMC models (all in pure Julia!). Several other packages that address aspects of MCMC sampling are available. 

Of particular interest might be the ongoing work in [DiffEqBayes.jl](https://github.com/JuliaDiffEq/DiffEqBayes.jl) on using MCMC for ODE parameter estimation.

[Jags.jl](https://github.com/JagsJulia/Jags.jl) is another option, but like StanJulia/CmdStan.jl, Jags runs as an external program.

## References

There is no shortage of good books on Bayesian statistics. A few of my favorites are:

1. [Bolstad: Introduction to Bayesian statistics](http://www.wiley.com/WileyCDA/WileyTitle/productCd-1118593227.html)

2. [Bolstad: Understanding Computational Bayesian Statistics](http://www.wiley.com/WileyCDA/WileyTitle/productCd-0470046090.html)

3. [Gelman, Hill: Data Analysis using regression and multileve,/hierachical models](http://www.stat.columbia.edu/~gelman/arm/)

4. [McElreath: Statistical Rethinking](http://xcelab.net/rm/statistical-rethinking/)

5. [Gelman, Carlin, and others: Bayesian Data Analysis](http://www.stat.columbia.edu/~gelman/book/)

and a great read (and implementation in DynamicHMC.jl):

5. [Betancourt: A Conceptual Introduction to Hamiltonian Monte Carlo](https://arxiv.org/abs/1701.02434)
