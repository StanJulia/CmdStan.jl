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

  bernoullidata = Dict("N" => 1, "y" => [0])

  global stanmodel, rc, sim
  
  stanmodel = Stanmodel(num_samples=1200, thin=2, name="bernoulli",
    output_format=:array, model=bernoullimodel);

  rc, sim, cnames = stan(stanmodel, bernoullidata, ProjDir,
    diagnostics=false, CmdStanDir=CMDSTAN_HOME);

  if rc == 0
    println()
    println("Test round.(mean(theta), 1) ≈ 0.3")
    @test round.(mean(sim[:,8,:]), digits=1) ≈ 0.3
  end
end # cd
