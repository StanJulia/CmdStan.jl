using CmdStan, Test, Statistics

ProjDir = dirname(@__FILE__)
cd(ProjDir) do

  isdir("tmp") &&
    rm("tmp", recursive=true);

  bernoullimodel = "
  data { 
    int<lower=1> N; 
    int<lower=0,upper=1> y[N];
    real empty[0];
  } 
  parameters {
    real<lower=0,upper=1> theta;
  } 
  model {
    theta ~ beta(1,1);
    y ~ bernoulli(theta);
  }
  "

  observeddata = [
    Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1],"empty"=>Float64[]),
  ]

  global stanmodel, rc, sim
  stanmodel = Stanmodel(num_samples=1200, thin=2, name="bernoulli", 
    output_format=:array, model=bernoullimodel);

  rc, sim = stan(stanmodel, observeddata, ProjDir, diagnostics=false,
    CmdStanDir=CMDSTAN_HOME);

  if rc == 0
    println()
    println("Test 0.2 < round(mean(theta), digits=1) < 0.4")
    @test 0.2 < round(mean(sim[:,8,:]), digits=1) < 0.4
  end

  isdir("tmp") &&
    rm("tmp", recursive=true);

end # cd
