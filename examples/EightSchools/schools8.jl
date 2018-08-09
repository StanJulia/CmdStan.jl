######### CmdStan batch program example  ###########

using Compat, CmdStan, Test, Statistics

ProjDir = dirname(@__FILE__)
cd(ProjDir) do

  eightschools ="
  data {
    int<lower=0> J; // number of schools
    real y[J]; // estimated treatment effects
    real<lower=0> sigma[J]; // s.e. of effect estimates
  }
  parameters {
    real mu;
    real<lower=0> tau;
    real eta[J];
  }
  transformed parameters {
    real theta[J];
    for (j in 1:J)
      theta[j] <- mu + tau * eta[j];
  }
  model {
    eta ~ normal(0, 1);
    y ~ normal(theta, sigma);
  }
  "

  schools8data = [
    Dict("J" => 8,
      "y" => [28,  8, -3,  7, -1,  1, 18, 12],
      "sigma" => [15, 10, 16, 11,  9, 11, 10, 18],
      "tau" => 25
    )
  ]

  global stanmodel, rc, sim
  stanmodel = Stanmodel(name="schools8", model=eightschools);
  rc, sim, cnames = stan(stanmodel, schools8data, ProjDir, CmdStanDir=CMDSTAN_HOME)

  if rc == 0
    println()
    println("Test 10.0 < round.(mean(theta[1]), digits=0) < 13.0")
    @test 10.0 < round.(mean(sim[:,18,:]), digits=0) < 13.0
  end
end # cd
