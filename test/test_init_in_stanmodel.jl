using CmdStan, DataFrames, Test, Statistics

tempdir = pwd()

nwarmup, nsamples, nchains = 1000, 1000, 4

stan_code = "
data {
    int<lower = 1> J; // number of cases
    real<lower = 0> onset_day_reported[J]; //day of illness onset
}

parameters {
    real<lower = 0> incubation[J];

    real mu;
    real<lower = 0> sigma;
}

model {
    mu ~ normal(0, 5);
    sigma ~ cauchy(0, 5);

    incubation ~ lognormal(mu,sigma);

    for (j in 1:J) {
        target += normal_lpdf(incubation[j] | onset_day_reported[j]+0.5, 0.5);
    }


}

generated quantities {
    real incubation_mean = exp(mu+sigma^2/2.0);
    real incubation_sd = sqrt((exp(sigma^2)-1.0)*exp(2.0*mu+sigma^2));
}
"

df_inc = DataFrame(Dict("n" => [1, 5, 7, 9, 17, 18, 16, 6, 8, 10, 7, 1, 2, 4, 4, 1],
    "day" => [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 25]))
days_inc = vcat(fill.(df_inc[!,:day],df_inc[!,:n])...)

stan_data = Dict("J" => length(days_inc), "onset_day_reported" => days_inc)

# stan_init = Dict("mu" => 2.5, "sigma" => 0.2, "incubation" => days_inc .+ 0.5)
stan_init = Dict("incubation[$i]"=>v+.5 for (i,v) in enumerate(days_inc))
temp_init = Dict("mu" => 2.5, "sigma" => 1.0)
merge!(stan_init, temp_init)

stanmodel = Stanmodel(
    name = "init_array",
    model = stan_code,
    nchains = nchains,
    #init = [stan_init],
    num_warmup = nwarmup,
    num_samples = nsamples);

rc, a3d, cnames = stan(stanmodel, stan_data,
        init = stan_init, summary = true);

if rc == 0
    sdf  = read_summary(stanmodel)
    @test sdf[sdf.parameters .== :mu, :mean][1] ≈ 2.5 rtol=0.1
end

