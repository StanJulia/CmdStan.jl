# cmdstan installation

## Minimal requirement

Note: CmdStan.jl and CmdStan refer to this Julia package. The executable C++ program is 'cmdstan'.

To run this version of the CmdStan.jl package on your local machine, it assumes that the  [cmdstan](http://mc-stan.org/interfaces/cmdstan) executable is properly installed.

In order for CmdStan.jl to find the cmdstan you need to set the environment variable `JULIA_CMDSTAN_HOME` to point to the cmdstan directory, e.g. add

```
export JULIA_CMDSTAN_HOME=/Users/rob/Projects/Stan/cmdstan
launchctl setenv JULIA_CMDSTAN_HOME /Users/rob/Projects/Stan/cmdstan
```

to `~/.bash_profile` or add `ENV["JULIA_CMDSTAN_HOME"]="./cmdstan"` to `./julia/etc/startup.jl`. 

I typically prefer cmdstan not to include the cmdstan version number so no update is needed when cmdstan is updated.

Currently tested with cmdstan 2.19.0
