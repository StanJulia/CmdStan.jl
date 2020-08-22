using CmdStan, Distributed

ProjDir = @__DIR__
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

observeddata = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])

sm = Stanmodel(name="bernoulli", model=bernoullimodel);

println("\nThreads loop\n")
p1 = 15
# p1 is the number of models to fit
estimates = Vector(undef, p1)
Threads.@threads for i in 1:p1
    new_model= deepcopy(sm)

    pdir = pwd()
    while ispath(pdir)
        pdir = tempname()
    end

    new_model.pdir = pdir
    new_model.tmpdir = joinpath(splitpath(pdir)...,"tmp")

    mkpath(new_model.tmpdir)

    #estimates[i] = stan(new_model)
    rc, samples, cnames = stan(sm, observeddata, new_model.pdir);
    if rc == 0
      estimates[i] = samples
    end

    rm(pdir; force=true, recursive=true)
end
