# Experimental threads example. WIP!

using CmdStan
using Statistics
using Distributions

ProjDir = @__DIR__
cd(ProjDir) #do

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

#isdir(ProjDir * "/tmp") && rm(ProjDir * "/tmp", recursive=true)
tmpdir = ProjDir * "/tmp"

p1 = 24 # p1 is the number of models to fit

n = 100;
p = range(0, stop=1, length=p1)
observeddata = [Dict("N" => n, "y" => Int.(rand(Bernoulli(p[i]), n))) for i in 1:p1]

sm = [Stanmodel(name="bernoulli_m$i", model=bernoullimodel;
  output_format=:namedtuple, tmpdir=tmpdir) for i in 1:p1]

println("\nThreads loop\n")

estimates = Vector(undef, p1)
Threads.@threads for i in 1:p1
    rc, samples, cnames = stan(sm[i], observeddata[i]; summary=false);
    if rc == 0
      estimates[i] = [mean(reshape(samples.theta, 4000)), std(reshape(samples.theta, 4000))]
    end
end

estimates |> display

#end
