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

  bernoullidata = [
    Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1]),
    Dict("N" => 10, "y" => [0, 1, 0, 0, 0, 0, 1, 0, 0, 1]),
    Dict("N" => 10, "y" => [0, 0, 0, 0, 0, 0, 1, 0, 1, 1]),
    Dict("N" => 10, "y" => [0, 0, 0, 1, 0, 0, 0, 1, 0, 1])
  ]

  inittheta = [
    Dict("theta" => 0.31),
    Dict("theta" => 0.32),
    Dict("theta" => 0.33),
    Dict("theta" => 0.34),
  ]

  global stanmodel
  stanmodel = Stanmodel(name="bernoulli", model=bernoullimodel,
    output_format=:array, num_warmup=1);

  global rc, sim
  rc, sim, cnames = stan(stanmodel, bernoullidata, ProjDir, 
    init=inittheta, CmdStanDir=CMDSTAN_HOME, summary=false)
  
  if rc == 0
    println()
    println("Test 0.2 <= mean(theta[1]) <= 0.5)")
    @test 0.2 <= round.(mean(sim[:,8,:]), digits=1) <= 0.5
  end

end # cd
