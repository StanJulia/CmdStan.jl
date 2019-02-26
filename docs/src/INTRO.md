# A Julia interface to cmdstan

## CmdStan.jl

[Stan](https://github.com/stan-dev/stan) is a system for statistical modeling, data analysis, and prediction. It is extensively used in social, biological, and physical sciences, engineering, and business. The Stan program language and interfaces are documented [here](http://mc-stan.org/documentation/).

[cmdstan](http://mc-stan.org/interfaces/cmdstan.html) is the shell/command line interface to run Stan language programs. 

[CmdStan.jl](https://github.com/StanJulia/CmdStan.jl) wraps cmdstan and captures the samples for further processing.

## StanJulia

CmdStan.jl is part of the [StanJulia Github organization](https://github.com/StanJulia) set of packages. It captures draws from a Stan language program and returns an array of values for each accepted draw for each monitored varable in all chains.

Other packages in StanJulia are either extensions, postprocessing of the draws or plotting of the results. as much as possible an attempt has been made to leverage below mentioned MCMC package options available in Julia to make comparisons easier.

On a very high level, a typical workflow for using StanJulia, e.g. to handle postprocessing by TuringLang's MCMCChain.jl, will look like:

```
using CmdStan, StanMCMCChain, MCMCChain, StatsBase

# Define a Stan language program.
bernoulli = "..."

# Prepare for calling cmdstan.
stanmodel = StanModel(..., output_format=:mcmcchain)

# Compile and run Stan program, collect draws.
rc, mcmcchain, cnames = stan(...)    

# Example of postprocessing, e.g. Highest Posterior Density Interval.
MCMCChain.hpd(mcmcchain[:, 8, :])

# Plot the draws for a variable.
plot(mcmcchain[:, 8, :], [:mixeddensity, :autocor, :mean])
savefig("bernoulli.pdf")  # save to a pdf file
```

This workflow uses [StanMCMCChain.jl](https://github.com/StanJulia/StanMCMCChain.jl) to create an [MCMCChain.jl](https://github.com/TuringLang/MCMCChain.jl) object for further processing by TuringLang/MCMCChain. A similar workflow is available for Mamba [StanMamba.jl[](https://github.com/StanJulia/StanMamba.jl). Another option is to convert the array of draw values to a DataFrame using [StanDataFrames.jl](https://github.com/StanJulia/StanDataFrames.jl).

The default value for the `output_format` argument in Stanmodel() is :array which causes stan() to call a (dummy) conversion method convert_a3d() and returns an array of values.

Currently 4 other values for `output_format` are used, i.e. :dataframe, :mambachain and :mcmcchain. The associated methods for `convert_a3d` are provided by StanDataFrames, StanMamba and StanMCMCChain. CmdStan.jl also provides the output_format option :namedarray

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
