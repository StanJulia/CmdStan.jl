var documenterSearchIndex = {"docs": [

{
    "location": "INTRO/#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "INTRO/#A-Julia-interface-to-cmdstan-1",
    "page": "Home",
    "title": "A Julia interface to cmdstan",
    "category": "section",
    "text": ""
},

{
    "location": "INTRO/#CmdStan.jl-1",
    "page": "Home",
    "title": "CmdStan.jl",
    "category": "section",
    "text": "Stan is a system for statistical modeling, data analysis, and prediction. It is extensively used in social, biological, and physical sciences, engineering, and business. The Stan program language and interfaces are documented here.cmdstan is the shell/command line interface to run Stan language programs. CmdStan.jl wraps cmdstan and captures the samples for further processing."
},

{
    "location": "INTRO/#StanJulia-1",
    "page": "Home",
    "title": "StanJulia",
    "category": "section",
    "text": "CmdStan.jl is part of the StanJulia Github organization set of packages. It captures draws from a Stan language program and returns an array of values for each accepted draw for each monitored varable in all chains.Other packages in StanJulia are either extensions, postprocessing of the draws or plotting of the results. as much as possible an attempt has been made to leverage below mentioned MCMC package options available in Julia to make comparisons easier.On a very high level, a typical workflow for using StanJulia, e.g. to handle postprocessing by TuringLang\'s MCMCChain.jl, will look like:using CmdStan, StanMCMCChain, MCMCChain, StatsBase\n\n# Define a Stan language program.\nbernoulli = \"...\"\n\n# Prepare for calling cmdstan.\nstanmodel = StanModel(..., output_format=:mcmcchain)\n\n# Compile and run Stan program, collect draws.\nrc, mcmcchain, cnames = stan(...)    \n\n# Example of postprocessing, e.g. Highest Posterior Density Interval.\nMCMCChain.hpd(mcmcchain[:, 8, :])\n\n# Plot the draws for a variable.\nplot(mcmcchain[:, 8, :], [:mixeddensity, :autocor, :mean])\nsavefig(\"bernoulli.pdf\")  # save to a pdf fileThis workflow uses StanMCMCChain.jl to create an MCMCChain.jl object for further processing by TuringLang/MCMCChain. A similar workflow is available for Mamba [StanMamba.jl. Another option is to convert the array of draw values to a DataFrame using StanDataFrames.jl.The default value for the output_format argument in Stanmodel() is :array which causes stan() to call a (dummy) conversion method convert_a3d() and returns an array of values.Currently 4 other values for output_format are used, i.e. :dataframe, :mambachain and :mcmcchain. The associated methods for convert_a3d are provided by StanDataFrames, StanMamba and StanMCMCChain. CmdStan.jl also provides the output_format option :namedarray"
},

{
    "location": "INTRO/#Other-MCMC-options-in-Julia-1",
    "page": "Home",
    "title": "Other MCMC options in Julia",
    "category": "section",
    "text": "Mamba.jl,  Klara.jl, DynamicHMC.jl and Turing.jl are other Julia packages to run MCMC models (all in pure Julia!). Several other packages that address aspects of MCMC sampling are available. Of particular interest might be the ongoing work in DiffEqBayes.jl on using MCMC for ODE parameter estimation.Jags.jl is another option, but like StanJulia/CmdStan.jl, Jags runs as an external program."
},

{
    "location": "INTRO/#References-1",
    "page": "Home",
    "title": "References",
    "category": "section",
    "text": "There is no shortage of good books on Bayesian statistics. A few of my favorites are:Bolstad: Introduction to Bayesian statistics\nBolstad: Understanding Computational Bayesian Statistics\nGelman, Hill: Data Analysis using regression and multileve,/hierachical models\nMcElreath: Statistical Rethinking\nGelman, Carlin, and others: Bayesian Data Analysisand a great read (and implementation in DynamicHMC.jl):Betancourt: A Conceptual Introduction to Hamiltonian Monte Carlo"
},

{
    "location": "INSTALLATION/#",
    "page": "Installation",
    "title": "Installation",
    "category": "page",
    "text": ""
},

{
    "location": "INSTALLATION/#cmdstan-installation-1",
    "page": "Installation",
    "title": "cmdstan installation",
    "category": "section",
    "text": ""
},

{
    "location": "INSTALLATION/#Minimal-requirement-1",
    "page": "Installation",
    "title": "Minimal requirement",
    "category": "section",
    "text": "Note: CmdStan.jl and CmdStan refer this Julia package. The executable C++ program is \'cmdstan\'.To run this version of the CmdStan.jl package on your local machine, it assumes that the  cmdstan executable is properly installed.In order for CmdStan.jl to find the cmdstan you need to set the environment variable JULIA_CMDSTAN_HOME to point to the cmdstan directory, e.g. addexport JULIA_CMDSTAN_HOME=/Users/rob/Projects/Stan/cmdstan\nlaunchctl setenv JULIA_CMDSTAN_HOME /Users/rob/Projects/Stan/cmdstanto ~/.bashprofile or add `ENV[\"JULIACMDSTAN_HOME\"]=\"./cmdstan\"to./julia/etc/julia/startup.jl`. I typically prefer cmdstan not to include the cmdstan version number so no update is needed when cmdstan is updated.Currently tested with cmdstan 2.18.0"
},

{
    "location": "WALKTHROUGH/#",
    "page": "Walkthrough",
    "title": "Walkthrough",
    "category": "page",
    "text": ""
},

{
    "location": "WALKTHROUGH/#A-walk-through-example-1",
    "page": "Walkthrough",
    "title": "A walk-through example",
    "category": "section",
    "text": ""
},

{
    "location": "WALKTHROUGH/#Bernoulli-example-1",
    "page": "Walkthrough",
    "title": "Bernoulli example",
    "category": "section",
    "text": "In this walk-through, it is assumed that \'ProjDir\' holds a path to where transient files will be created (in a subdirectory /tmp of ProjDir).Make CmdStan.jl available:using CmdStanNext define the variable \'bernoullistanmodel\' to hold the Stan model definition:const bernoullistanmodel = \"\ndata { \n  int<lower=0> N; \n  int<lower=0,upper=1> y[N];\n} \nparameters {\n  real<lower=0,upper=1> theta;\n} \nmodel {\n  theta ~ beta(1,1);\n    y ~ bernoulli(theta);\n}\n\"The next step is to create a Stanmodel object. The most common way to create such an object is by giving the model a name while the Stan model is passed in, both through keyword (hence optional) arguments:stanmodel = Stanmodel(name=\"bernoulli\", model=bernoullistanmodel);\nstanmodel Above Stanmodel() call creates a default model for sampling. Other arguments to Stanmodel() can be found in StanmodelThe observed input data is defined below.bernoullidata = Dict(\"N\" => 10, \"y\" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])Each chain will use this data. If needed, an Array{Dict} can be defined with the same number of entries as the number of chains. This is also true for the optional init argument to stan().Run the simulation by calling stan(), passing in the data and the intended working directory. rc, sim1, cnames = stan(stanmodel, bernoullidata, ProjDir, CmdStanDir=CMDSTAN_HOME)More documentation on stan() can be found in stanIf the return code rc indicated success (rc == 0), cmdstan execution completed succesfully.The first time (or when updates to the model have been made) stan() will compile the model and create the executable.On Windows, the CmdStanDir argument appears needed (this is still being investigated). On OSX/Unix CmdStanDir is obtained from an environment variable (see the Requirements section).By default stan() will run 4 chains and optionally display a combined summary. Some other CmdStan methods, e.g. optimize, return a dictionary."
},

{
    "location": "WALKTHROUGH/#Running-a-CmdStan-script,-some-details-1",
    "page": "Walkthrough",
    "title": "Running a CmdStan script, some details",
    "category": "section",
    "text": "CmdStan.jl really only consists of 2 functions, Stanmodel() and stan()."
},

{
    "location": "WALKTHROUGH/#[Stanmodel](@ref)-1",
    "page": "Walkthrough",
    "title": "Stanmodel",
    "category": "section",
    "text": "Stanmodel() is used to define the basic attributes for a model:monitor = [\"theta\", \"lp__\", \"accept_stat__\"]\nstanmodel = Stanmodel(name=\"bernoulli\", model=bernoulli, monitors=monitor);\nstanmodelAbove script, in the Julia REPL, shows all parameters in the model, in this case (by default) a sample model.Compared to the call to Stanmodel() above, the keyword argument monitors has been added. This means that after the simulation is complete, only the monitored variables will be read in from the .csv file produced by Stan. This can be useful if many, e.g. 100s, nodes are being observed.stanmodel2 = Stanmodel(Sample(adapt=Adapt(delta=0.9)), name=\"bernoulli2\", nchains=6)An example of updating default model values when creating a model. The format is slightly different from cmdstan, but the parameters are as described in the cmdstan Interface User\'s Guide. This is also the case for the Stanmodel() optional arguments random, init and output (refresh only).Now, in the REPL, the stanmodel2 can be shown by:stanmodel2After the Stanmodel object has been created fields can be updated, e.g.stanmodel2.method.adapt.delta=0.85"
},

{
    "location": "WALKTHROUGH/#[stan](@ref)-1",
    "page": "Walkthrough",
    "title": "stan",
    "category": "section",
    "text": "After a Stanmodel has been created, the workhorse function stan() is called to run the simulation. Note that some fields in the Stanmodel are updated by stan().After the stan() call, the stanmodel.command contains an array of Cmd fields that contain the actual run commands for each chain. These are executed in parallel if that is possible. The call to stan() might update other info in the StanModel, e.g. the names of diagnostics files.The stan() call uses \'make\' to create (or update when needed) an executable with the given model.name, e.g. bernoulli in the above example. If no model AbstractString (or of zero length) is found, a message will be shown."
},

{
    "location": "VERSIONS/#",
    "page": "Versions",
    "title": "Versions",
    "category": "page",
    "text": ""
},

{
    "location": "VERSIONS/#Version-approach-and-history-1",
    "page": "Versions",
    "title": "Version approach and history",
    "category": "section",
    "text": ""
},

{
    "location": "VERSIONS/#Approach-1",
    "page": "Versions",
    "title": "Approach",
    "category": "section",
    "text": "A version of a Julia package is labeled (tagged) as v\"major.minor.patch\".My intention is to update the patch level whenever I make updates which are not visible to any of the existing examples.New functionality will be introduced in minor level updates. This includes adding new examples, tests and the introduction of new arguments if they default to previous behavior, e.g. in v\"4.2.0\" the run_log_file argument to stan().Changes that require updates to some examples bump the major level.Updates for new releases of Julia and cmdstan bump the appropriate level."
},

{
    "location": "VERSIONS/#Testing-1",
    "page": "Versions",
    "title": "Testing",
    "category": "section",
    "text": "Versions 4.4 of the package has been tested on Mac OSX 10.14, Julia 1.0 and cmdstan 2.18.0."
},

{
    "location": "VERSIONS/#Version-4.4.0-1",
    "page": "Versions",
    "title": "Version 4.4.0",
    "category": "section",
    "text": "Pkg3 based.\nAdded the output_format option :namedarray which will return a NamesArrays object instead of the a3d array."
},

{
    "location": "VERSIONS/#Version-4.2.0/4.3.0-1",
    "page": "Versions",
    "title": "Version 4.2.0/4.3.0",
    "category": "section",
    "text": "Added ability to reformat a3d_array to a TuringLang/MCMCChain object.\nAdded the ability to display the sample drawing progress in stdout (instead of storing these updated in the runlogfile)"
},

{
    "location": "VERSIONS/#Version-4.1.0-1",
    "page": "Versions",
    "title": "Version 4.1.0",
    "category": "section",
    "text": "Added ability to reformat a3d_array, e.g. to a DataFrame or a Mamba.Chains object using add-on packages such as StanDataFrames and StanMamba.\nAllowed passing zero-length arrays as input."
},

{
    "location": "VERSIONS/#Version-4.0.0-1",
    "page": "Versions",
    "title": "Version 4.0.0",
    "category": "section",
    "text": "Initial Julia 1.0 release of CmdStan.jl (based on Stan.jl)._"
},

{
    "location": "#",
    "page": "Index",
    "title": "Index",
    "category": "page",
    "text": ""
},

{
    "location": "#Programs-1",
    "page": "Index",
    "title": "Programs",
    "category": "section",
    "text": ""
},

{
    "location": "#CmdStan.CMDSTAN_HOME",
    "page": "Index",
    "title": "CmdStan.CMDSTAN_HOME",
    "category": "constant",
    "text": "The directory which contains the cmdstan executables such as bin/stanc and bin/stansummary. Inferred from the environment variable JULIA_CMDSTAN_HOME or ENV[\"JULIA_CMDSTAN_HOME\"] when available.\n\nIf these are not available, use set_cmdstan_home! to set the value of CMDSTAN_HOME.\n\nExample: set_cmdstan_home!(homedir() * \"/Projects/Stan/cmdstan/\")\n\nExecuting versioninfo() will display the value of JULIA_CMDSTAN_HOME if defined.\n\n\n\n\n\n"
},

{
    "location": "#CMDSTAN_HOME-1",
    "page": "Index",
    "title": "CMDSTAN_HOME",
    "category": "section",
    "text": "CMDSTAN_HOME"
},

{
    "location": "#CmdStan.set_cmdstan_home!",
    "page": "Index",
    "title": "CmdStan.set_cmdstan_home!",
    "category": "function",
    "text": "Set the path for the CMDSTAN_HOME environment variable.\n\nExample: set_cmdstan_home!(homedir() * \"/Projects/Stan/cmdstan/\")\n\n\n\n\n\n"
},

{
    "location": "#set_cmdstan_home!-1",
    "page": "Index",
    "title": "set_cmdstan_home!",
    "category": "section",
    "text": "CmdStan.set_cmdstan_home!"
},

{
    "location": "#CmdStan.Stanmodel",
    "page": "Index",
    "title": "CmdStan.Stanmodel",
    "category": "type",
    "text": "Method Stanmodel\n\nCreate a Stanmodel. \n\nConstructors\n\nStanmodel(\n  method=Sample();\n  name=\"noname\", \n  nchains=4,\n  num_warmup=1000, \n  num_samples=1000,\n  thin=1,\n  model=\"\",\n  monitors=String[],\n  data=DataDict[],\n  random=Random(),\n  init=DataDict[],\n  output=Output(),\n  pdir::String=pwd(),\n  output_format=:array\n)\n\n\nRequired arguments\n\n* `method::Method`            : See ?Method\n\nOptional arguments\n\n* `name::String`               : Name for the model\n* `nchains::Int`               : Number of chains, if possible execute in parallel\n* `num_warmup::Int`            : Number of samples used for num_warmupation \n* `num_samples::Int`           : Sample iterations\n* `thin::Int`                  : Stan thinning factor\n* `model::String`              : Stan program source\n* `data::DataDict[]`           : Observed input data as an array of Dicts\n* `random::Random`             : Random seed settings\n* `init::DataDict[]`           : Initial values for parameters in parameter block\n* `output::Output`             : File output options\n* `pdir::String`               : Working directory\n* `monitors::String[] `        : Filter for variables used in Mamba post-processing\n* `output_format::Symbol ` : Specifies the required output format (:array for CmdStan.jl)\n\nCmdStan.jl supports 2 output_format values:\n\n1. :array                 # Returns an array of draws (default value)\n2. :namedarray      # Returns a NamedArrays object \n\nboth return an Array{Float64, 3} with ndraws, nvars, nchains as indices.\n\nOther options are availableby `importing` or `using` packages such as:\n1. StanDataFrames.jl\n2. StanMamba.jl or\n3. StanMCMCChain.jl.\n\nSee also `?CmdStan.convert_a3d`.\n\nExample\n\nbernoullimodel = \"\ndata { \n  int<lower=1> N; \n  int<lower=0,upper=1> y[N];\n} \nparameters {\n  real<lower=0,upper=1> theta;\n} \nmodel {\n  theta ~ beta(1,1);\n  y ~ bernoulli(theta);\n}\n\"\n\nstanmodel = Stanmodel(num_samples=1200, thin=2, name=\"bernoulli\", model=bernoullimodel);\n\nRelated help\n\n?stan                          : Run a Stanmodel\n?CmdStan.Sample                        : Sampling settings\n?CmdStan.Method                         : List of available methods\n?CmdStan.Output                        : Output file settings\n?CmdStan.DataDict                      : Input data dictionaries, will be converted to R syntax\n?CmdStan.convert_a3d                   : Options for output formats\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.update_model_file",
    "page": "Index",
    "title": "CmdStan.update_model_file",
    "category": "function",
    "text": "Method update_model_file\n\nUpdate Stan language model file if necessary \n\nMethod\n\nCmdStan.update_model_file(\n  file::String, \n  str::String\n)\n\nRequired arguments\n\n* `file::AbstractString`                : File holding existing Stan model\n* `str::AbstractString`                 : Stan model string\n\nRelated help\n\n?CmdStan.Stanmodel                 : Create a StanModel\n\n\n\n\n\n"
},

{
    "location": "#stanmodel()-1",
    "page": "Index",
    "title": "stanmodel()",
    "category": "section",
    "text": "Stanmodel\nCmdStan.update_model_file"
},

{
    "location": "#CmdStan.stan",
    "page": "Index",
    "title": "CmdStan.stan",
    "category": "function",
    "text": "stan\n\nExecute a Stan model. \n\nMethod\n\nrc, sim, cnames = stan(\n  model::Stanmodel, \n  data=Nothing, \n  ProjDir=pwd();\n  init=Nothing,\n  summary=true, \n  diagnostics=false, \n  CmdStanDir=CMDSTAN_HOME,\n  file_run_log=true\n)\n\nRequired arguments\n\n* `model::Stanmodel`              : See ?Method\n\nOptional positional arguments\n\n* `data=Nothing`                     : Observed input data dictionary \n* `ProjDir=pwd()`                 : Project working directory\n\nKeyword arguments\n\n* `init=Nothing`                     : Initial parameter value dictionary\n* `summary=true`                  : Use CmdStan\'s stansummary to display results\n* `diagnostics=false`             : Generate diagnostics file\n* `CmdStanDir=CMDSTAN_HOME`       : Location of cmdstan directory\n* `file_run_log=true`             : Create run log file (if false, write log to stdout)\n\nReturn values\n\n* `rc::Int`                       : Return code from stan(), rc == 0 if all is well\n* `sim`                          : Chain results\n* `cnames`                   : Vector of variable names\n\nExamples\n\n# no data, use default ProjDir (pwd)\nstan(mymodel)\n# default ProjDir (pwd)\nstan(mymodel, mydata)\n# specify ProjDir\nstan(mymodel, mydata, \"~/myproject/\")\n# keyword arguments\nstan(mymodel, mydata, \"~/myproject/\", diagnostics=true, summary=false)\n# use default ProjDir (pwd), with keyword arguments\nstan(mymodel, mydata, diagnostics=true, summary=false)\n\nRelated help\n\n?Stanmodel                      : Create a StanModel\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.stan_summary-Tuple{Cmd}",
    "page": "Index",
    "title": "CmdStan.stan_summary",
    "category": "method",
    "text": "Method stan_summary\n\nDisplay cmdstan summary \n\nMethod\n\nstan_summary(\n  filecmd::Cmd; \n  CmdStanDir=CMDSTAN_HOME\n)\n\nRequired arguments\n\n* `filecmd::Cmd`                : Run command containing names of sample files\n\nOptional arguments\n\n* CmdStanDir=CMDSTAN_HOME       : cmdstan directory for stansummary program\n\nRelated help\n\n?Stan.stan                      : Create a StanModel\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.stan_summary-Tuple{String}",
    "page": "Index",
    "title": "CmdStan.stan_summary",
    "category": "method",
    "text": "Method stan_summary\n\nDisplay cmdstan summary \n\nMethod\n\nstan_summary(\n  file::String; \n  CmdStanDir=CMDSTAN_HOME\n)\n\nRequired arguments\n\n* `file::String`                : Name of file with samples\n\nOptional arguments\n\n* CmdStanDir=CMDSTAN_HOME       : cmdstan directory for stansummary program\n\nRelated help\n\n?Stan.stan                      : Execute a StanModel\n\n\n\n\n\n"
},

{
    "location": "#stan()-1",
    "page": "Index",
    "title": "stan()",
    "category": "section",
    "text": "stan\nCmdStan.stan_summary(filecmd::Cmd; CmdStanDir=CMDSTAN_HOME)\nCmdStan.stan_summary(file::String; CmdStanDir=CMDSTAN_HOME)"
},

{
    "location": "#CmdStan.Method",
    "page": "Index",
    "title": "CmdStan.Method",
    "category": "type",
    "text": "Available top level Method\n\nMethod\n\n*  Sample::Method             : Sampling\n*  Optimize::Method           : Optimization\n*  Diagnose::Method           : Diagnostics\n*  Variational::Method        : Variational Bayes\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Sample",
    "page": "Index",
    "title": "CmdStan.Sample",
    "category": "type",
    "text": "Sample type and constructor\n\nSettings for method=Sample() in Stanmodel. \n\nMethod\n\nSample(;\n  num_samples=1000,\n  num_warmup=1000,\n  save_warmup=false,\n  thin=1,\n  adapt=Adapt(),\n  algorithm=SamplingAlgorithm()\n)\n\nOptional arguments\n\n* `num_samples::Int64`          : Number of sampling iterations ( >= 0 )\n* `num_warmup::Int64`           : Number of warmup iterations ( >= 0 )\n* `save_warmup::Bool`           : Include warmup samples in output\n* `thin::Int64`                 : Period between saved samples\n* `adapt::Adapt`                : Warmup adaptation settings\n* `algorithm::SamplingAlgorithm`: Sampling algorithm\n\n\nRelated help\n\n?Stanmodel                      : Create a StanModel\n?Adapt\n?SamplingAlgorithm\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Adapt",
    "page": "Index",
    "title": "CmdStan.Adapt",
    "category": "type",
    "text": "Adapt type and constructor\n\nSettings for adapt=Adapt() in Sample(). \n\nMethod\n\nAdapt(;\n  engaged=true,\n  gamma=0.05,\n  delta=0.8,\n  kappa=0.75,\n  t0=10.0,\n  init_buffer=75,\n  term_buffer=50,\n  window::25\n)\n\nOptional arguments\n\n* `engaged::Bool`              : Adaptation engaged?\n* `gamma::Float64`             : Adaptation regularization scale\n* `delta::Float64`             : Adaptation target acceptance statistic\n* `kappa::Float64`             : Adaptation relaxation exponent\n* `t0::Float64`                : Adaptation iteration offset\n* `init_buffer::Int64`         : Width of initial adaptation interval\n* `term_buffer::Int64`         : Width of final fast adaptation interval\n* `window::Int64`              : Initial width of slow adaptation interval\n\nRelated help\n\n?Sample                        : Sampling settings\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.SamplingAlgorithm",
    "page": "Index",
    "title": "CmdStan.SamplingAlgorithm",
    "category": "type",
    "text": "Available sampling algorithms\n\nCurrently limited to Hmc().\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Hmc",
    "page": "Index",
    "title": "CmdStan.Hmc",
    "category": "type",
    "text": "Hmc type and constructor\n\nSettings for algorithm=Hmc() in Sample(). \n\nMethod\n\nHmc(;\n  engine=Nuts(),\n  metric=Stan.diag_e,\n  stepsize=1.0,\n  stepsize_jitter=1.0\n)\n\nOptional arguments\n\n* `engine::Engine`            : Engine for Hamiltonian Monte Carlo\n* `metric::Metric`            : Geometry for base manifold\n* `stepsize::Float64`         : Stepsize for discrete evolutions\n* `stepsize_jitter::Float64`  : Uniform random jitter of the stepsize [%]\n\nRelated help\n\n?Sample                        : Sampling settings\n?Engine                        : Engine for Hamiltonian Monte Carlo\n?Nuts                          : Settings for Nuts\n?Static                        : Settings for Static\n?Metric                        : Base manifold geometries\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Metric",
    "page": "Index",
    "title": "CmdStan.Metric",
    "category": "type",
    "text": "Metric types\n\nGeometry of base manifold\n\nTypes defined\n\n* unit_e::Metric      : Euclidean manifold with unit metric\n* dense_e::Metric     : Euclidean manifold with dense netric\n* diag_e::Metric      : Euclidean manifold with diag netric\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Engine",
    "page": "Index",
    "title": "CmdStan.Engine",
    "category": "type",
    "text": "Engine types\n\nEngine for Hamiltonian Monte Carlo\n\nTypes defined\n\n* Nuts       : No-U-Tyrn sampler\n* Static     : Static integration time\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Nuts",
    "page": "Index",
    "title": "CmdStan.Nuts",
    "category": "type",
    "text": "Nuts type and constructor\n\nSettings for engine=Nuts() in Hmc(). \n\nMethod\n\nNuts(;max_depth=10)\n\nOptional arguments\n\n* `max_depth::Number`           : Maximum tree depth\n\nRelated help\n\n?Sample                        : Sampling settings\n?Engine                        : Engine for Hamiltonian Monte Carlo\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Static",
    "page": "Index",
    "title": "CmdStan.Static",
    "category": "type",
    "text": "Static type and constructor\n\nSettings for engine=Static() in Hmc(). \n\nMethod\n\nStatic(;int_time=2 * pi)\n\nOptional arguments\n\n* `;int_time::Number`          : Static integration time\n\nRelated help\n\n?Sample                        : Sampling settings\n?Engine                        : Engine for Hamiltonian Monte Carlo\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Diagnostics",
    "page": "Index",
    "title": "CmdStan.Diagnostics",
    "category": "type",
    "text": "Available method diagnostics\n\nCurrently limited to Gradient().\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Gradient",
    "page": "Index",
    "title": "CmdStan.Gradient",
    "category": "type",
    "text": "Gradient type and constructor\n\nSettings for diagnostic=Gradient() in Diagnose(). \n\nMethod\n\nGradient(;epsilon=1e-6, error=1e-6)\n\nOptional arguments\n\n* `epsilon::Float64`           : Finite difference step size\n* `error::Float64`             : Error threshold\n\nRelated help\n\n?Diagnose                      : Diagnostic method\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Diagnose",
    "page": "Index",
    "title": "CmdStan.Diagnose",
    "category": "type",
    "text": "Diagnose type and constructor\n\nMethod\n\nDiagnose(;d=Gradient())\n\nOptional arguments\n\n* `d::Diagnostics`            : Finite difference step size\n\nRelated help\n\n```julia ?Diagnostics                  : Diagnostic methods ?Gradient                     : Currently sole diagnostic method\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.OptimizeAlgorithm",
    "page": "Index",
    "title": "CmdStan.OptimizeAlgorithm",
    "category": "type",
    "text": "OptimizeAlgorithm types\n\nTypes defined\n\n* Lbfgs::OptimizeAlgorithm   : Euclidean manifold with unit metric\n* Bfgs::OptimizeAlgorithm    : Euclidean manifold with unit metric\n* Newton::OptimizeAlgorithm  : Euclidean manifold with unit metric\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Optimize",
    "page": "Index",
    "title": "CmdStan.Optimize",
    "category": "type",
    "text": "Optimize type and constructor\n\nSettings for Optimize top level method. \n\nMethod\n\nOptimize(;\n  method=Lbfgs(),\n  iter=2000,\n  save_iterations=false\n)\n\nOptional arguments\n\n* `method::OptimizeMethod`      : Optimization algorithm\n* `iter::Int`                   : Total number of iterations\n* `save_iterations::Bool`       : Stream optimization progress to output\n\nRelated help\n\n?Stanmodel                      : Create a StanModel\n?OptimizeAlgorithm              : Available algorithms\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Lbfgs",
    "page": "Index",
    "title": "CmdStan.Lbfgs",
    "category": "type",
    "text": "Lbfgs type and constructor\n\nSettings for method=Lbfgs() in Optimize(). \n\nMethod\n\nLbfgs(;init_alpha=0.001, tol_obj=1e-8, tol_grad=1e-8, tol_param=1e-8, history_size=5)\n\nOptional arguments\n\n* `init_alpha::Float64`        : Linear search step size for first iteration\n* `tol_obj::Float64`           : Convergence tolerance for objective function\n* `tol_rel_obj::Float64`       : Relative change tolerance in objective function\n* `tol_grad::Float64`          : Convergence tolerance on norm of gradient\n* `tol_rel_grad::Float64`      : Relative change tolerance on norm of gradient\n* `tol_param::Float64`         : Convergence tolerance on parameter values\n* `history_size::Int`          : No of update vectors to use in Hessian approx\n\nRelated help\n\n?OptimizeMethod               : List of available optimize methods\n?Optimize                      : Optimize arguments\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Bfgs",
    "page": "Index",
    "title": "CmdStan.Bfgs",
    "category": "type",
    "text": "Bfgs type and constructor\n\nSettings for method=Bfgs() in Optimize(). \n\nMethod\n\nBfgs(;init_alpha=0.001, tol_obj=1e-8, tol_rel_obj=1e4, \n  tol_grad=1e-8, tol_rel_grad=1e7, tol_param=1e-8)\n\nOptional arguments\n\n* `init_alpha::Float64`        : Linear search step size for first iteration\n* `tol_obj::Float64`           : Convergence tolerance for objective function\n* `tol_rel_obj::Float64`       : Relative change tolerance in objective function\n* `tol_grad::Float64`          : Convergence tolerance on norm of gradient\n* `tol_rel_grad::Float64`      : Relative change tolerance on norm of gradient\n* `tol_param::Float64`         : Convergence tolerance on parameter values\n\nRelated help\n\n?OptimizeMethod               : List of available optimize methods\n?Optimize                      : Optimize arguments\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Newton",
    "page": "Index",
    "title": "CmdStan.Newton",
    "category": "type",
    "text": "Newton type and constructor\n\nSettings for method=Newton() in Optimize(). \n\nMethod\n\nNewton()\n\nRelated help\n\n?OptimizeMethod               : List of available optimize methods\n?Optimize                      : Optimize arguments\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Variational",
    "page": "Index",
    "title": "CmdStan.Variational",
    "category": "type",
    "text": "Variational type and constructor\n\nSettings for method=Variational() in Stanmodel. \n\nMethod\n\nVariational(;\n  grad_samples=1,\n  elbo_samples=100,\n  eta_adagrad=0.1,\n  iter=10000,\n  tol_rel_obj=0.01,\n  eval_elbo=100,\n  algorithm=:meanfield,          \n  output_samples=10000\n)\n\nOptional arguments\n\n* `algorithm::Symbol`             : Variational inference algorithm\n                                    :meanfiedl;\n                                    :fullrank\n* `iter::Int64`                   : Maximum number of iterations\n* `grad_samples::Int`             : No of samples for MC estimate of gradients\n* `elbo_samples::Int`             : No of samples for MC estimate of ELBO\n* `eta::Float64`                  : Stepsize weighing parameter for adaptive sequence\n* `adapt::Adapt`                  : Warmupadaptations\n* `tol_rel_obj::Float64`          : Tolerance on the relative norm of objective\n* `eval_elbo::Int`                : Tolerance on the relative norm of objective\n* `output_samples::Int`           : Numberof posterior samples to draw and save\n\nRelated help\n\n?Stanmodel                      : Create a StanModel\n?Stan.Method                   : Available top level methods\n?Stan.Adapt                     : Adaptation settings\n\n\n\n\n\n"
},

{
    "location": "#Types-1",
    "page": "Index",
    "title": "Types",
    "category": "section",
    "text": "CmdStan.Method\nCmdStan.Sample\nCmdStan.Adapt\nCmdStan.SamplingAlgorithm\nCmdStan.Hmc\nCmdStan.Metric\nCmdStan.Engine\nCmdStan.Nuts\nCmdStan.Static\nCmdStan.Diagnostics\nCmdStan.Gradient\nCmdStan.Diagnose\nCmdStan.OptimizeAlgorithm\nCmdStan.Optimize\nCmdStan.Lbfgs\nCmdStan.Bfgs\nCmdStan.Newton\nCmdStan.Variational"
},

{
    "location": "#CmdStan.cmdline",
    "page": "Index",
    "title": "CmdStan.cmdline",
    "category": "function",
    "text": "cmdline\n\nRecursively parse the model to construct command line. \n\nMethod\n\ncmdline(m)\n\nRequired arguments\n\n* `m::Stanmodel`                : Stanmodel\n\nRelated help\n\n?Stanmodel                      : Create a StanModel\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.check_dct_type",
    "page": "Index",
    "title": "CmdStan.check_dct_type",
    "category": "function",
    "text": "checkdcttype(\n\nCheck if dct == Dict[] and has length > 0. \n\nMethod\n\ncheck_dct_type((dct)\n\nRequired arguments\n\n* `dct::Dict{String, Any}`      : Observed data or parameter init data\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.convert_a3d",
    "page": "Index",
    "title": "CmdStan.convert_a3d",
    "category": "function",
    "text": "convert_a3d\n\nConvert the output file created by cmdstan to the shape of choice.\n\nMethod\n\nconvert_a3d(a3d_array, cnames, ::Val{Symbol})\n\nRequired arguments\n\n* `a3d_array::Array{Float64}(n_draws, n_variables, n_chains`      : Read in from output files created by cmdstan                                   \n* `cnames::Vector{AbstractString}`                                                 : Monitored variable names\n\nOptional arguments\n\n* `::Val{Symbol} = :array`                                                                             : Output format\n\nMethod called is based on the output_format defined in the stanmodel, e.g.:\n\nstanmodel = Stanmodel(num/samples=1200, thin=2, name=\"bernoulli\",     model=bernoullimodel, outputformat=:array);\n\nCurrent formats supported are:\n\n:array (a3d_array format, the default for CmdStan)\n:namedarray (NamedArrays object)\n:dataframe (DataFrames object)\n:mambachains (Mamba.Chains object)\n:mcmcchain (TuringLang/Chains object)\n\nOptions 3 through 5 are respectively provided by the packages StanDataFrames, StanMamba and StanMCMCChain.\n\n\n### Return values\n\njulia\n\nres                       : Draws converted to the specified format.\n\n```\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.Fixed_param",
    "page": "Index",
    "title": "CmdStan.Fixed_param",
    "category": "type",
    "text": "Fixed_param type and constructor\n\nSettings for algorithm=Fixed_param() in Sample(). \n\nMethod\n\nFixed_param()\n\nRelated help\n\n?Sample                        : Sampling settings\n?Engine                        : Engine for Hamiltonian Monte Carlo\n?Nuts                          : Settings for Nuts\n?Static                        : Settings for Static\n?Metric                        : Base manifold geometries\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.par",
    "page": "Index",
    "title": "CmdStan.par",
    "category": "function",
    "text": "par\n\nRewrite dct to R format in file. \n\nMethod\n\npar(cmds)\n\nRequired arguments\n\n* `cmds::Array{Base.AbstractCmd,1}`    : Multiple commands to concatenate\n\nor\n\n* `cmd::Base.AbstractCmd`              : Single command to be\n* `n::Number`                            inserted n times into cmd\n\n\nor\n* `cmd::Array{String, 1}`              : Array of cmds as Strings\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.read_optimize",
    "page": "Index",
    "title": "CmdStan.read_optimize",
    "category": "function",
    "text": "read_optimize\n\nRead optimize output file created by cmdstan. \n\nMethod\n\nread_optimize(m::Stanmodel)\n\nRequired arguments\n\n* `m::Stanmodel`    : Stanmodel object\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.read_samples",
    "page": "Index",
    "title": "CmdStan.read_samples",
    "category": "function",
    "text": "read_samples\n\nRead sample output files created by cmdstan. \n\nMethod\n\nread_samples(m::Stanmodel)\n\nRequired arguments\n\n* `m::Stanmodel`    : Stanmodel object\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.read_variational",
    "page": "Index",
    "title": "CmdStan.read_variational",
    "category": "function",
    "text": "read_variational\n\nRead variational sample output files created by cmdstan. \n\nMethod\n\nread_variational(m::Stanmodel)\n\nRequired arguments\n\n* `m::Stanmodel`    : Stanmodel object\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.read_diagnose",
    "page": "Index",
    "title": "CmdStan.read_diagnose",
    "category": "function",
    "text": "read_diagnose\n\nRead diagnose output file created by cmdstan. \n\nMethod\n\nread_diagnose(m::Stanmodel)\n\nRequired arguments\n\n* `m::Stanmodel`    : Stanmodel object\n\n\n\n\n\n"
},

{
    "location": "#CmdStan.update_R_file",
    "page": "Index",
    "title": "CmdStan.update_R_file",
    "category": "function",
    "text": "updateRfile\n\nRewrite a dictionary of observed data or initial parameter values in R dump file format to a file. \n\nMethod\n\nupdate_R_file{T<:Any}(file, dct)\n\nRequired arguments\n\n* `file::String`                : R file name\n* `dct::Dict{String, T}`        : Dictionary to format in R\n\n\n\n\n\n"
},

{
    "location": "#Utilities-1",
    "page": "Index",
    "title": "Utilities",
    "category": "section",
    "text": "CmdStan.cmdline\nCmdStan.check_dct_type\nCmdStan.convert_a3d\nCmdStan.Fixed_param\nCmdStan.par\nCmdStan.read_optimize\nCmdStan.read_samples\nCmdStan.read_variational\nCmdStan.read_diagnose\nCmdStan.update_R_file"
},

{
    "location": "#Index-1",
    "page": "Index",
    "title": "Index",
    "category": "section",
    "text": ""
},

]}
