using CmdStan, Test

ProjDir = dirname(@__FILE__)
cd(ProjDir)

@testset "Bernoulli" begin

  isdir("tmp") &&
    rm("tmp", recursive=true);

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

  tmpdir = ProjDir*"/tmp"

  stanmodel = Stanmodel(Sample(save_warmup=true, num_warmup=1000, 
    num_samples=2000, thin=1), name="bernoulli", model=bernoullimodel,
    printsummary=false, tmpdir=tmpdir);

  rc, chn, cnames = stan(stanmodel, observeddata, ProjDir, diagnostics=false,
    CmdStanDir=CMDSTAN_HOME);

  chns = chn[1001:end, :, :]

  if rc == 0
    s = summarize(chns)
    @test s[:theta, :mean][1] ≈ 0.34 atol=0.1
  end

  isdir("tmp") &&
    rm("tmp", recursive=true);

end # testset
