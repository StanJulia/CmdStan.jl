######### CmdStan batch program example  ###########

using CmdStan, StatsPlots

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
    output_format=:mcmcchains, tmpdir=tmpdir);
  
  rc, chn, cnames = stan(stanmodel, schools8data, ProjDir, CmdStanDir=CMDSTAN_HOME)

  if rc == 0
    
    chn1 = Chains(chn.value,
      [ "accept_stat__", "divergent__", "energy__",
        "eta[1]", "eta[2]", "eta[3]", "eta[4]",      
        "eta[5]", "eta[6]", "eta[7]", "eta[8]",       
        "lp__",        
        "mu",           
        "n_leapfrog__", "stepsize__",  
        "tau",         
        "theta[1]", "theta[2]", "theta[3]", "theta[4]",      
        "theta[5]", "theta[6]", "theta[7]", "theta[8]",      
        "treedepth__"  
      ]  
    )
    
    chns = set_section(chn1, Dict(
      :parameters => ["mu", "tau"],
      :thetas => ["theta[$i]" for i in 1:8],
      :etas => ["eta[$i]" for i in 1:8],
      :internals => ["lp__", "accept_stat__", "stepsize__", "treedepth__", "n_leapfrog__",
        "divergent__", "energy__"]
      )
    )
    
    show(chns)
    println("\n")
    summarize(chns, sections=[:thetas])
    
    #=
    if isdefined(Main, :StatsPlots)
      p1 = plot(chns)
      savefig(p1, joinpath(tmpdir, "traceplot.pdf"))
      df = DataFrame(chns, [:thetas])
      p2 = plot(df[!, Symbol("theta[1]")])
      savefig(p2, joinpath(tmpdir, "theta_1.pdf"))
    end
    =#
  end
end # cd
