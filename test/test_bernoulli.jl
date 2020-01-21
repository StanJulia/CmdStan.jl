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

  #tmpdir = ProjDir*"/tmp"

  stanmodel = Stanmodel(Sample(save_warmup=false, num_warmup=1000, 
    num_samples=2000, thin=1), name="bernoulli", model=bernoullimodel,
    printsummary=false, 
    #tmpdir=tmpdir
  );

  rc, a3d, cnames = stan(stanmodel, observeddata, ProjDir, diagnostics=false,
    CmdStanDir=CMDSTAN_HOME);

  if rc == 0
    sdf  = read_summary(stanmodel)
    @test sdf[sdf.parameters .== :theta, :mean][1] ≈ 0.34 rtol=0.1
  end

  isdir("tmp") &&
    rm("tmp", recursive=true);

end # testset
