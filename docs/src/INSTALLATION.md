# cmdstan installation

## Minimal requirement

Note: CmdStan.jl and CmdStan refer this Julia package. The executable C++ program is 'cmdstan'.

To run this version of the CmdStan.jl package on your local machine, it assumes that the  [cmdstan](http://mc-stan.org/interfaces/cmdstan) executable is properly installed.

In order for CmdStan.jl to find the cmdstan you need to set the environment variable `JULIA_CMDSTAN_HOME` to point to the cmdstan directory, e.g. add

```
export JULIA_CMDSTAN_HOME=/Users/rob/Projects/Stan/cmdstan
launchctl setenv JULIA_CMDSTAN_HOME /Users/rob/Projects/Stan/cmdstan
```

to `~/.bash_profile` or add `ENV["JULIA_CMDSTAN_HOME"]="./cmdstan"` to `./julia/etc/startup.jl`. 

I typically prefer cmdstan not to include the cmdstan version number so no update is needed when cmdstan is updated.

Currently tested with cmdstan 2.18.1

## Important note

Over the next month (February 2019) all _master_ versions of StanJulia and StatisticalRethinkingJulia packages will start using MCMCChains.jl (and, for practical reasons, mostly will be tested on Julia v1.2-DEV). As long as MCMCChains.jl has not been registered in METADATA.jl, I use:
`] dev https://github.com/TuringLang/MCMCChains.jl` to install MCMCChains.jl. Note that currently Turing.jl expects MCMCChain.jl.
