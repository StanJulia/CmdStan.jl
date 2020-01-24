# A Julia interface to cmdstan

## CmdStan.jl

[Stan](https://github.com/stan-dev/stan) is a system for statistical modeling, data analysis, and prediction. It is extensively used in social, biological, and physical sciences, engineering, and business. The Stan program language and interfaces are documented [here](http://mc-stan.org/documentation/).

[cmdstan](http://mc-stan.org/interfaces/cmdstan.html) is the shell/command line interface to run Stan language programs. 

[CmdStan.jl](https://github.com/StanJulia/CmdStan.jl) wraps cmdstan and captures the samples for further processing.

## StanJulia

CmdStan.jl is part of the [StanJulia Github organization](https://github.com/StanJulia) set of packages. It captures draws from a Stan language program.

On a very high level, a typical workflow for using StanJulia and handle postprocessing by TuringLang's MCMCChains.jl, will look like:

```
using CmdStan

# Define a Stan language program.
bernoulli = "..."

# Prepare for calling cmdstan.
stanmodel = StanModel(...)

# Compile and run Stan program, collect draws.
rc, samples, cnames = stan(...)

# Cmdstan summary of result
sdf = read_summary(stanmodel)

# Dsplay the summary
sdf |> display

# Show the draws
samples |> display
```

This workflow creates an array of draws, the default value for the `output_format` argument in Stanmodel(). Other options are `:dataframes` and `:mcmcchains`.

## References

There is no shortage of good books on Bayesian statistics. A few of my favorites are:

1. [Bolstad: Introduction to Bayesian statistics](http://www.wiley.com/WileyCDA/WileyTitle/productCd-1118593227.html)

2. [Bolstad: Understanding Computational Bayesian Statistics](http://www.wiley.com/WileyCDA/WileyTitle/productCd-0470046090.html)

3. [Gelman, Hill: Data Analysis using regression and multileve,/hierachical models](http://www.stat.columbia.edu/~gelman/arm/)

4. [McElreath: Statistical Rethinking](http://xcelab.net/rm/statistical-rethinking/)

5. [Gelman, Carlin, and others: Bayesian Data Analysis](http://www.stat.columbia.edu/~gelman/book/)

and a great read (and implementation in DynamicHMC.jl):

5. [Betancourt: A Conceptual Introduction to Hamiltonian Monte Carlo](https://arxiv.org/abs/1701.02434)
