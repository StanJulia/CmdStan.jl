# A walk-through example


## Bernoulli example

Make CmdStan.jl available:
```
using CmdStan
```

Define a variable, e.g. 'bernoullistanmodel', to hold the Stan model definition:
```
bernoullistanmodel = "
data { 
  int<lower=0> N; 
  int<lower=0,upper=1> y[N];
} 
parameters {
  real<lower=0,upper=1> theta;
} 
model {
  theta ~ beta(1,1);
    y ~ bernoulli(theta);
}
"
```
Create a Stanmodel object by giving the model a name and pass in the Stan model:
```
stanmodel = Stanmodel(name="bernoulli", model=bernoullistanmodel);
```

This creates a default model for sampling. A subsequent call to stan() will return an array of samples.

Other arguments to Stanmodel() can be found in [`Stanmodel`](@ref)

The observed input data is defined below.
```
bernoullidata = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])
```

Each chain will use this data. If needed, an Array{Dict} can be defined with the same number of entries as the number of chains. This is also true for the optional `init` argument to stan(). Use these features with care, particularly providing different data as the chains are supposed to be from identical observed data.

Run the simulation by calling stan(), passing in the data and the intended working directory. 
```
ProjDir = @__DIR__
rc, chns, cnames = stan(stanmodel, bernoullidata, ProjDir, CmdStanDir=CMDSTAN_HOME)
```

More documentation on stan() can be found in [`stan`](@ref)

If the return code rc indicated success (rc == 0), cmdstan execution completed succesfully.

Next possible steps can be:
```
sdf = read_summary(stanmodel)
```

The first time (or when updates to the model have been made) stan() will compile the model and create the executable. 

On Windows, the CmdStanDir argument appears needed (this is still being investigated). On OSX/Unix CmdStanDir is obtained from an environment variable (see the Requirements section).

By default stan() will run 4 chains and optionally display a combined summary. Some other CmdStan methods, e.g. optimize, return a dictionary.

If `summary = true`, the default, the stan summary is also written to a .csv file and can be read in using:
```
csd = read_summary(stanmodel)
csd[:theta, :mean] # Select mean as computed by the stansummary binary.
```

Stanmodel has an optional argument `printsummary=false` to have cmdstan create the summary .csv file but not display the stansummary.


## Output format options

CmdStan.jl supports 3 output formats: 

1. A 3 dimensional array ("a3d") where the first index refers to samples, the 2nd index to parameters and the 3rd index to chains.

2. A MCMCChains.Chains object, see the examples in subdirectory examples_mcmcchains.

3. A DataFrames object. 

The default output format is :array. 

To specify options 2 and 3 use:
```
stammodel= Stanmodel(..., output_format=:mcmcchains, ...)
```

or

```
stanmodel = Stanmodel(..., output_format=:dataframes, ...)
```

when creating the Stanmodel.

It is very important that in order to use option 2 the package MCMCChains.jl needs to be installed and loaded in your script, e.g. see the `bernoulli.jl` example in the ```examples_mcmcchains``` directory.


## Running a CmdStan script, some details

CmdStan.jl really only consists of 2 functions, Stanmodel() and stan().

### [`Stanmodel`](@ref)

Stanmodel() is used to define the basic attributes for a model:
```
monitor = ["theta", "lp__", "accept_stat__"]
stanmodel = Stanmodel(name="bernoulli", model=bernoullistanmodel,
  monitors=monitor);
stanmodel
```

Above script, in the Julia REPL, shows all parameters in the model, in this case (by default) a sample model.

Compared to the call to Stanmodel() above, the keyword argument monitors has been added. This means that after the simulation is complete, only the monitored variables will be read in from the .csv file produced by Stan. This can be useful if many, e.g. 100s, nodes are being observed.

If the requested result is an MCMCChains.Chains object, another option is available by using ```set_section(chain, section_map_dict)```, e.g. see the example in ```examples_mcmcchains/Dyes/dyes.jl```.

If the samples are stored in a vector of DataFrames, the usual DataFrames selection options are available.

Below an example of updating default model values when creating a model: 

```
stanmodel2 = Stanmodel(Sample(adapt=CmdStan.Adapt(delta=0.9)), name="bernoulli2", nchains=6)
```

The format is slightly different from cmdstan, but the parameters are as described in the cmdstan Interface User's Guide. This is also the case for the Stanmodel() optional arguments random, init and output (refresh only).

In the REPL, the stanmodel2 can be shown by:
```
stanmodel2
```
After the Stanmodel object has been created fields can be updated, e.g.
```
stanmodel2.method.adapt.delta=0.85
```

### [`stan`](@ref)
 
After a Stanmodel has been created, the workhorse function stan() is called to run the simulation. Note that some fields in the Stanmodel are updated by stan().

After the stan() call, the stanmodel.command contains an array of Cmd fields that contain the actual run commands for each chain. These are executed in parallel if that is possible. The call to stan() might update other info in the StanModel, e.g. the names of diagnostics files.

The stan() call uses 'make' to create (or update when needed) an executable with the given model.name, e.g. bernoulli in the above example. If no model AbstractString (or of zero length) is found, a message will be shown.
