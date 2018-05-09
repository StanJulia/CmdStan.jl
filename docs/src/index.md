# Programs

## CMDSTAN_HOME
```@docs
CMDSTAN_HOME
```

## set_cmdstan_home!
```@docs
set_cmdstan_home!
```

## stanmodel()

```@docs
Stanmodel
CmdStan.update_model_file
```

## stan()

```@docs
stan
CmdStan.stan_summary(filecmd::Cmd; CmdStanDir=CMDSTAN_HOME)
CmdStan.stan_summary(file::String; CmdStanDir=CMDSTAN_HOME)
```

## Types
```@docs
CmdStan.Method
CmdStan.Sample
CmdStan.Adapt
CmdStan.SamplingAlgorithm
CmdStan.Hmc
CmdStan.Metric
CmdStan.Engine
CmdStan.Nuts
CmdStan.Static
CmdStan.Diagnostics
CmdStan.Gradient
CmdStan.Diagnose
CmdStan.OptimizeAlgorithm
CmdStan.Optimize
CmdStan.Lbfgs
CmdStan.Bfgs
CmdStan.Newton
CmdStan.Variational
```

## Utilities
```@docs
CmdStan.cmdline
CmdStan.check_dct_type
CmdStan.update_R_file
CmdStan.par
CmdStan.read_stanfit(model::Stanmodel)
```

## Index
```@index
```
