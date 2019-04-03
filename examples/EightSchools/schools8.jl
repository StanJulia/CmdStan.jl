######### CmdStan batch program example  ###########

using CmdStan, Test, Statistics

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

  schools8data = Dict("J" => 8,
      "y" => [28,  8, -3,  7, -1,  1, 18, 12],
      "sigma" => [15, 10, 16, 11,  9, 11, 10, 18],
      "tau" => 25
    )

  global stanmodel, rc, sim
  stanmodel = Stanmodel(name="schools8", model=eightschools,
    output_format=:mcmcchains);
  rc, chn, cnames = stan(stanmodel, schools8data, ProjDir, CmdStanDir=CMDSTAN_HOME)

  if rc == 0
    
    chns = set_section(chn, Dict(
      :parameters => ["mu", "tau"],
      :pooled => vcat(["theta.$i" for i in 1:8], ["eta.$i" for i in 1:8]),
      :internals => ["lp__", "accept_stat__", "stepsize__", "treedepth__", "n_leapfrog__",
        "divergent__", "energy__"]
      )
    )
    
    @test 7.0 < round.(mean(Array(chns[:mu])), digits=0) < 9.0
    
    describe(chns)
    describe(chns, section=:pooled)
  end
end # cd
