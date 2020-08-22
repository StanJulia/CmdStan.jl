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

tmpdir = ProjDir * "/tmp"
sm = Stanmodel(name="bernoulli", model=bernoullimodel;
  #tmpdir=tmpdir
);

#=
rc, samples, cnames = stan(stanmodel, observeddata, ProjDir, CmdStanDir=CMDSTAN_HOME);

if rc == 0
  # Fetch cmdstan summary as a DataFrame
  df = read_summary(stanmodel)

  df |> display
  println()

  df[df.parameters .== :theta, [:mean, :ess, :r_hat]] |> display
end
=#
println("\n\nThreads loop\n\n")
p1 = 1
old_model = sm
# p1 is the number of models to fit
# old_model is an old Stanmodel
estimates = Vector(undef, p1)
Threads.@threads for i in 1:p1
    new_model= deepcopy(old_model)
    #new_model = Stanmodel(name="bernoulli", model=bernoullimodel)
    println(new_model)

    pdir = pwd()
    while ispath(pdir)
        pdir = tempname()
    end

    new_model.pdir = pdir
    new_model.tmpdir = joinpath(splitpath(pdir)...,"tmp")

    mkpath(new_model.tmpdir)

    estimates[i] = stan(new_model)

    rm(pdir; force=true, recursive=true)
end
