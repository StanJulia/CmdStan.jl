######### CmndStan program example  ###########

using CmdStan, Test, Statistics

ProjDir = dirname(@__FILE__)
cd(ProjDir) do

  bernoulli = "
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

  bernoullidata = [
    Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1]),
    Dict("N" => 10, "y" => [0, 1, 0, 0, 0, 0, 1, 0, 0, 1]),
    Dict("N" => 10, "y" => [0, 0, 0, 0, 0, 0, 1, 0, 1, 1]),
    Dict("N" => 10, "y" => [0, 0, 0, 1, 0, 0, 0, 1, 0, 1])
  ]

  global stanmodel, rc, sim, cnames
  stanmodel = Stanmodel(CmdStan.Variational(), name="bernoulli", 
    output_format=:array, model=bernoulli)

  rc, sim, cnames = stan(stanmodel, bernoullidata, ProjDir, CmdStanDir=CMDSTAN_HOME)

  if rc == 0
    println()
    println("Test 0.0 <= round.(mean(theta), 1) <= 2.0")
    @test 0.0 <= round.(mean(sim[:,2,:]), digits=1) <= 2.0
  end
end # cd
