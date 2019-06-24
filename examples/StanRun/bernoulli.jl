######### CmdStan program example  ###########

using CmdStan: update_model_file, convert_a3d
using MCMCChains
using StanDump, StanRun, StanSample
using Unicode, DelimitedFiles, CSV

include("read_stanrun_samples.jl")

ProjDir = @__DIR__
cd(ProjDir) #do

  bernoulli_model = "
  data { 
    int<lower=1> N; 
    int<lower=0,upper=1> y[N];
  } 
  parameters {
    real<lower=0,upper=1> theta;
  } 
  model {
    theta ~ beta(1,1);
    y ~ bernoulli(theta);
  }
  ";

  data = [
    Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1]),
    Dict("N" => 10, "y" => [0, 1, 0, 0, 0, 0, 1, 0, 0, 1]),
    Dict("N" => 10, "y" => [0, 0, 0, 0, 0, 0, 1, 0, 1, 1]),
    Dict("N" => 10, "y" => [0, 0, 0, 1, 0, 0, 0, 1, 0, 1])
  ]

  tmpdir = joinpath(ProjDir, "tmp")
  if !isdir(tmpdir)
    mkdir(tmpdir)
  end
  
  for (i, d) in enumerate(data)
    stan_dump(joinpath(tmpdir, "bernoulli_data_$i.R"), d, force=true)
  end
  
  update_model_file(joinpath(tmpdir, "bernoulli.stan"), strip(bernoulli_model))
  sm = StanModel(joinpath(tmpdir, "bernoulli.stan"))
  
  stan_compile(sm)
  
  stan_sample(sm, joinpath(tmpdir, "bernoulli_data_1.R"), 4)
  
  exec_path = StanRun.ensure_executable(sm)
  output_base = StanRun.default_output_base(sm)
  pipelin_cmd = StanSample.stan_cmd_and_paths(exec_path, output_base, 1)
  
  nt = read_samples(output_base*"_chain_1.csv")
  display(nt)
  println()
  
  a3d, cnames = read_stanrun_samples(output_base, "_chain")
  chns = convert_a3d(a3d, cnames, Val(:mcmcchains); start=1)
  describe(chns)
  
#end # cd
