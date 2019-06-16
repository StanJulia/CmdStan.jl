# This script shows stansummary ESS vakues vs. MCMCChains ESS values

using CmdStan, StatsPlots

ProjDir = @__DIR__
cd(ProjDir)

berstanmodel = "
data { 
  int<lower=0> N; 
  int<lower=0,upper=1> y[N];
} 
parameters {
  real<lower=0,upper=1> theta;
} 
model {
  theta ~ beta(1,1);
  for (n in 1:N) 
    y[n] ~ bernoulli(theta);
}
"

data = Dict("y" => [0,1,0,0,0,0,0,0,0,1],
  "N" => 10)

stanmodel = Stanmodel(
   name = "berstanmodel", model = berstanmodel, nchains = 4,
   printsummary=false, tmpdir=mktempdir());

ess_array_mcmcchains = []
ess_array_cmdstan = []

for i in 1:100
  rc, chns, cnames = stan(stanmodel,
     data, summary=true, ProjDir);
  dfc = describe(chns)[1]
  append!(ess_array_mcmcchains, dfc[:theta, :ess])
  rs = read_summary(stanmodel)
  append!(ess_array_cmdstan, rs[:theta, :ess])
end

p = Array{Plots.Plot{Plots.GRBackend}}(undef, 1);
p[1] = plot(ess_array_cmdstan, lab="CmdStan", xlim=(0, 170))
p[1] = plot!(ess_array_mcmcchains, lab="MCMCChains")
plot(p..., layout=(1,1))
savefig("ess_comparison_plot.pdf")