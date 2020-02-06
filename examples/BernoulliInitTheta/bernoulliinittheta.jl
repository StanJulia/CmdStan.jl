######### CmdStan program example  ###########

using CmdStan, Test, Statistics

ProjDir = dirname(@__FILE__)
cd(ProjDir) do

  bernoullimodel = "
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
  "

  bernoullidata = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])
  inittheta = Dict("theta" => 0.60)

  global stanmodel, sdf
  stanmodel = Stanmodel(name="bernoulli", model=bernoullimodel,
    random=CmdStan.Random(seed=-1),
    num_warmup=1000, printsummary=false);

  global rc, sim
  rc, a3d, cnames = stan(stanmodel, bernoullidata, ProjDir, 
    init=inittheta, CmdStanDir=CMDSTAN_HOME)
  
  if rc == 0
    sdf  = read_summary(stanmodel)
    @test sdf[sdf.parameters .== :theta, :mean][1] ≈ 0.34 rtol=0.1
  end

  
end # cd
