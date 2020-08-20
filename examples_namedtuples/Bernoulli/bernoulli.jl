######### CmdStan program example  ###########

using CmdStan

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

  global stanmodel, rc, chn, nt, cnames, sdf
  
  tmpdir = ProjDir*"/tmp"
  
  stanmodel = Stanmodel(Sample(save_warmup=false, num_warmup=1000, 
    num_samples=2000, thin=1), name="bernoulli", model=bernoullimodel,
    printsummary=false, tmpdir=tmpdir, output_format=:namedtuple);

  rc, nt, cnames = stan(stanmodel, observeddata, ProjDir, diagnostics=false,
    CmdStanDir=CMDSTAN_HOME);

  if rc == 0
    
    display(nt)

    # Ceate a ChainDataFrame
    sdf = read_summary(stanmodel)
    sdf[sdf.parameters .== :theta, [:mean, :ess]]
  end

end # cd
