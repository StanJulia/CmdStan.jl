using CmdStan, DiffEqBayes, OrdinaryDiffEq, ParameterizedFunctions,
      ModelingToolkit, RecursiveArrayTools, Distributions, Random, Test

# Uncomment for local testing only, make sure MCMCChains and StatsPlots are available
using MCMCChains, StatsPlots

#Random.seed!(123)
cd(@__DIR__)
isdir("tmp") && rm("tmp", recursive=true)

include("../../stan_inference.jl")

println("\nOne parameter case 1\n")
f1 = @ode_def begin
  dx = a*x - x*y
  dy = -3y + x*y
end a
u0 = [1.0,1.0]
tspan = (0.0,10.0)
p = [1.5]
prob1 = ODEProblem(f1,u0,tspan,p)
sol = solve(prob1,Tsit5())
t = collect(range(1,stop=10,length=10))
randomized = VectorOfArray([(sol(t[i]) + .5randn(2)) for i in 1:length(t)])
data = convert(Array,randomized)
priors = [truncated(Normal(0.7,1),0.1,2)]

bayesian_result = stan_inference(prob1,t,data,priors;num_samples=2000, nchains=4,
  num_warmup=1000,likelihood=Normal)

sdf  = CmdStan.read_summary(bayesian_result.model)
@test sdf[sdf.parameters .== :theta1, :mean][1] ≈ 1.5 atol=3e-1

# Uncomment for local chain inspection
chn = CmdStan.convert_a3d(bayesian_result.chains, bayesian_result.cnames, Val(:mcmcchains))
plot(chn)
!isdir("tmp") && mkdir("tmp")
savefig("$(@__DIR__)/one_par_case_01.png")

v1 = [sdf[sdf.parameters .== Symbol("u_hat[$i,1]"), :mean][1] for i in 1:10]
v2 = [sdf[sdf.parameters .== Symbol("u_hat[$i,2]"), :mean][1] for i in 1:10]
qa_prey = zeros(10, 3);
qa_pred = zeros(10, 3);
achn = Array(chn);
for i in 1:10
  qa_prey[i, :] = quantile(achn[:, 4+i], [0.055, 0.5, 0.945])
  qa_pred[i, :] = quantile(achn[:, 14+i], [0.055, 0.5, 0.945])
end
p1 = plot(1:10, v1; ribbon=(qa_prey[:, 1], qa_prey[:, 3]), color=:lightgrey, leg=false)
title!("Prey u_hat 89% quantiles")
plot!(v1, lab="prey", xlab="time", ylab="prey", color=:darkred)

p2 = plot(1:10, v2; ribbon=(qa_pred[:, 1], qa_pred[:, 3]), color=:lightgrey, leg=false)
title!("Preditors u_hat 89% quantiles")
plot!(v2, lab="pred", xlab="time", ylab="preditors", color=:darkblue)

plot(p1, p2, layout=(2,1))
savefig("$(@__DIR__)/one_par_pred_prey_01.png")

println("\nOne parameter case 2\n")
priors = [
  truncated(Normal(1.,0.5), 0.1, 3),
  truncated(Normal(1.,0.5), 0.1, 3),
  truncated(Normal(1.5,0.5), 0.1, 4)
]
bayesian_result = stan_inference(prob1,t,data,priors;num_samples=2000, nchains=4,
  num_warmup=1000,likelihood=Normal,sample_u0=true)

sdf  = CmdStan.read_summary(bayesian_result.model)
@test sdf[sdf.parameters .== :theta1, :mean][1] ≈ 1. atol=3e-1
@test sdf[sdf.parameters .== :theta2, :mean][1] ≈ 1. atol=3e-1
@test sdf[sdf.parameters .== :theta3, :mean][1] ≈ 1.5 atol=3e-1

# Uncomment for local chain inspection
chn = CmdStan.convert_a3d(bayesian_result.chains, bayesian_result.cnames, Val(:mcmcchains))
plot(chn)
!isdir("tmp") && mkdir("tmp")
savefig("$(@__DIR__)/one_par_case_02.png")

v1 = [sdf[sdf.parameters .== Symbol("u_hat[$i,1]"), :mean][1] for i in 1:10]
v2 = [sdf[sdf.parameters .== Symbol("u_hat[$i,2]"), :mean][1] for i in 1:10]
qa_prey = zeros(10, 3);
qa_pred = zeros(10, 3);
achn = Array(chn);
for i in 1:10
  qa_prey[i, :] = quantile(achn[:, 8+i], [0.055, 0.5, 0.945])
  qa_pred[i, :] = quantile(achn[:, 18+i], [0.055, 0.5, 0.945])
end
p1 = plot(1:10, v1; ribbon=(qa_prey[:, 1], qa_prey[:, 3]), color=:lightgrey, leg=false)
title!("Prey u_hat 89% quantiles")
plot!(v1, lab="prey", xlab="time", ylab="prey", color=:darkred)

p2 = plot(1:10, v2; ribbon=(qa_pred[:, 1], qa_pred[:, 3]), color=:lightgrey, leg=false)
title!("Preditors u_hat 89% quantiles")
plot!(v2, lab="pred", xlab="time", ylab="preditors", color=:darkblue)

plot(p1, p2, layout=(2,1))
savefig("$(@__DIR__)/one_par_pred_prey_02.png")

println("\nOne parameter case 3\n")

sol = solve(prob1,Tsit5(),save_idxs=[1])
randomized = VectorOfArray([(sol(t[i]) + .01 * randn(1)) for i in 1:length(t)])
data = convert(Array,randomized)
priors = [truncated(Normal(1.5,0.5), 0.1,2)]
bayesian_result = stan_inference(prob1,t,data,priors;num_samples=2000, nchains=4,
  num_warmup=1000,likelihood=Normal,save_idxs=[1])

sdf  = CmdStan.read_summary(bayesian_result.model)
@test sdf[sdf.parameters .== :theta1, :mean][1] ≈ 1.5 atol=3e-1

# Uncomment for local chain inspection
chn = CmdStan.convert_a3d(bayesian_result.chains, bayesian_result.cnames, Val(:mcmcchains))
plot(chn)
savefig("$(@__DIR__)/one_par_case_03.png")

v1 = [sdf[sdf.parameters .== Symbol("u_hat[$i,1]"), :mean][1] for i in 1:10]
v2 = [sdf[sdf.parameters .== Symbol("u_hat[$i,2]"), :mean][1] for i in 1:10]
qa_prey = zeros(10, 3);
qa_pred = zeros(10, 3);
achn = Array(chn);
for i in 1:10
  qa_prey[i, :] = quantile(achn[:, 3+i], [0.055, 0.5, 0.945])
  qa_pred[i, :] = quantile(achn[:, 13+i], [0.055, 0.5, 0.945])
end
p1 = plot(1:10, v1; ribbon=(qa_prey[:, 1], qa_prey[:, 3]), color=:lightgrey, leg=false)
title!("Prey u_hat 89% quantiles")
plot!(v1, lab="prey", xlab="time", ylab="prey", color=:darkred)

p2 = plot(1:10, v2; ribbon=(qa_pred[:, 1], qa_pred[:, 3]), color=:lightgrey, leg=false)
title!("Preditors u_hat 89% quantiles")
plot!(v2, lab="pred", xlab="time", ylab="preditors", color=:darkblue)

plot(p1, p2, layout=(2,1))
savefig("$(@__DIR__)/one_par_pred_prey_03.png")

println("\nOne parameter case 4\n")

priors = [truncated(Normal(1.,0.5), 0.1, 3),
  truncated(Normal(1.5,0.5), 0.1, 4)]
bayesian_result = stan_inference(prob1,t,data,priors;num_samples=2000,
  nchains=4, num_warmup=1000,likelihood=Normal,save_idxs=[1],sample_u0=true)

sdf  = CmdStan.read_summary(bayesian_result.model)
@test sdf[sdf.parameters .== :theta1, :mean][1] ≈ 1. atol=3e-1
@test sdf[sdf.parameters .== :theta2, :mean][1] ≈ 1.5 atol=3e-1

# Uncomment for local chain inspection
chn = CmdStan.convert_a3d(bayesian_result.chains, bayesian_result.cnames, Val(:mcmcchains))
plot(chn)
savefig("$(@__DIR__)/one_par_case_04.png")

v1 = [sdf[sdf.parameters .== Symbol("u_hat[$i,1]"), :mean][1] for i in 1:10]
v2 = [sdf[sdf.parameters .== Symbol("u_hat[$i,2]"), :mean][1] for i in 1:10]
qa_prey = zeros(10, 3);
qa_pred = zeros(10, 3);
achn = Array(chn);
for i in 1:10
  qa_prey[i, :] = quantile(achn[:, 4+i], [0.055, 0.5, 0.945])
  qa_pred[i, :] = quantile(achn[:, 14+i], [0.055, 0.5, 0.945])
end
p1 = plot(1:10, v1; ribbon=(qa_prey[:, 1], qa_prey[:, 3]), color=:lightgrey, leg=false)
title!("Prey u_hat 89% quantiles")
plot!(v1, lab="prey", xlab="time", ylab="prey", color=:darkred)

p2 = plot(1:10, v2; ribbon=(qa_pred[:, 1], qa_pred[:, 3]), color=:lightgrey, leg=false)
title!("Preditors u_hat 89% quantiles")
plot!(v2, lab="pred", xlab="time", ylab="preditors", color=:darkblue)

plot(p1, p2, layout=(2,1))
savefig("$(@__DIR__)/one_par_pred_prey_04.png")

