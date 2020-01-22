######### CmdStan batch program example  ###########

# Note that this example needs StanMCMCChains.

using CmdStan, Test

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

  global stanmodel, rc, chn, chns, cnames, tmpdir
  tmpdir = mktempdir()
  
  stanmodel = Stanmodel(name="schools8", model=eightschools,
    tmpdir=tmpdir);
  
  rc, chn, cnames = stan(stanmodel, schools8data, ProjDir, CmdStanDir=CMDSTAN_HOME)

  if rc == 0
    
    if rc == 0
      sdf  = read_summary(stanmodel)
      @test sdf[sdf.parameters .== Symbol("theta[1]"), :mean][1] ≈ 11.6 rtol=0.1

      # using StatsPlots
      if isdefined(Main, :StatsPlots)
        p1 = plot(chns)
        savefig(p1, joinpath(tmpdir, "traceplot.pdf"))
        df = DataFrame(chns, [:thetas])
        p2 = plot(df[!, Symbol("theta[1]")])
        savefig(p2, joinpath(tmpdir, "theta_1.pdf"))
      end
    end
  end
end # cd
