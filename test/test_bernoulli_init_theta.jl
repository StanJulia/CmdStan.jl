
using Test


ProjDir = joinpath(dirname(@__FILE__), "..", "examples", "BernoulliInitTheta")
cd(ProjDir) do

  isdir("tmp") &&
    rm("tmp", recursive=true);

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

  bernoullidata = [
    Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1]),
    Dict("N" => 10, "y" => [0, 1, 0, 0, 0, 0, 1, 0, 0, 1]),
    Dict("N" => 10, "y" => [0, 0, 0, 0, 0, 0, 1, 0, 1, 1]),
    Dict("N" => 10, "y" => [0, 0, 0, 1, 0, 0, 0, 1, 0, 1])
  ]
  
  theta_init = [0.1, 0.4, 0.5, 0.9]
  bernoulliinit = Dict[
    Dict("theta" => theta_init[1]),
    Dict("theta" => theta_init[2]),
    Dict("theta" => theta_init[3]),
    Dict("theta" => theta_init[4]),
  ]

  monitor = ["theta", "lp__", "accept_stat__"]

  stanmodel = Stanmodel(name="bernoulli",
    model=bernoullimodel,
    init=Stan.Init(init=bernoulliinit),
    adapt=1);

  rc, a3d, cnames = stan(stanmodel, bernoullidata, CmdStanDir=CMDSTAN_HOME)

  if rc == 0
    sdf  = read_summary(stanmodel)
    @test sdf[sdf.parameters .== :theta, :mean][1] ≈ 0.34 rtol=0.1
  end

  isdir("tmp") &&
    rm("tmp", recursive=true);

end # cd
