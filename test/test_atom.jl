######### CmdStan program example  ###########

using CmdStan

ProjDir = dirname(@__FILE__)
cd(ProjDir)

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

tmpdir = ProjDir*"/tmp"

stanmodel = Stanmodel(Sample(save_warmup=true, num_warmup=1000,
  num_samples=2000, thin=1), name="bernoulli", model=bernoullimodel,
  printsummary=false, tmpdir=tmpdir);

println("\mTest for Atom completed, stanmodel should not have been displayed\n")