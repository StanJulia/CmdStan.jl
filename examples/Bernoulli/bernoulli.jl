######### CmdStan program example  ###########

using CmdStan
using StatsPlots

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
  ";

  observeddata = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])

  global stanmodel, rc, chn, chns, cnames, summary_df
  
  stanmodel = Stanmodel(Sample(save_warmup=true, num_warmup=1000, 
    num_samples=2000, thin=1), name="bernoulli", model=bernoullimodel,
    printsummary=false, tmpdir=mktempdir());

  rc, chn, cnames = stan(stanmodel, observeddata, ProjDir, diagnostics=false,
    CmdStanDir=CMDSTAN_HOME);

  chns = chn[1001:end, :, :]
  
  if rc == 0
    # Check if StatsPlots is available
    if isdefined(Main, :StatsPlots)
      p1 = plot(chns)
      savefig(p1, "traceplot.pdf")
      p2 = pooleddensity(chns)
      savefig(p2, "pooleddensity.pdf")
    end
    
    # Describe the results
    show(chns)
    println()
    
    # Ceate a ChainDataFrame
    summary_df = read_summary(stanmodel)
    summary_df[:theta, [:mean, :ess]]
  end

end # cd
