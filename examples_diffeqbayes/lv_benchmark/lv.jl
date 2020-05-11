using DiffEqBayes, CmdStan, DynamicHMC, DataFrames
using Distributions, BenchmarkTools, Random
using OrdinaryDiffEq, RecursiveArrayTools, ParameterizedFunctions
using StatsPlots
gr(size=(600,900))

ProjDir = @__DIR__
cd(ProjDir)
isdir("tmp") && rm("tmp", recursive=true)

include("../stan_inference.jl")

f = @ode_def LotkaVolterraTest begin
    dx = a*x - b*x*y
    dy = -c*y + d*x*y
end a b c d

u0 = [1.0,1.0]
tspan = (0.0,10.0)
p = [1.5,1.0,3.0,1,0]

prob = ODEProblem(f,u0,tspan,p)
sol = solve(prob,Tsit5())

t = collect(range(1,stop=10,length=30))
sig = 0.49
data = convert(Array, VectorOfArray([(sol(t[i]) + sig*randn(2)) for i in 1:length(t)]))

scatter(t, data[1,:], lab="#prey (data)")
scatter!(t, data[2,:], lab="#predator (data)")
plot!(sol)
savefig("$(ProjDir)/fig_01.png")

priors = [truncated(Normal(1.5,0.5),0.1,3.0),truncated(Normal(1.2,0.5),0.1,2),
  truncated(Normal(3.0,0.5),1,4),truncated(Normal(1.0,0.5),0.1,2)]

# Stan.jl backend

#The solution converges for tolerance values lower than 1e-3, lower tolerance 
#leads to better accuracy in result but is accompanied by longer warmup and 
#sampling time, truncated normal priors are used for preventing Stan from stepping into negative values.

nchains = 4
num_samples = 800
@time bayesian_result_stan = stan_inference(prob,t,data,priors,
  num_samples=num_samples, printsummary=false, nchains=4);
sdf1  = CmdStan.read_summary(bayesian_result_stan.model)
println()

@time bayesian_result_stan = stan_inference(prob,t,data,
  priors,bayesian_result_stan.model,
  num_samples=num_samples, printsummary=false, nchains=4)
sdf2  = CmdStan.read_summary(bayesian_result_stan.model)
println()

cnames = ["theta1", "theta2", "theta3", "theta4", "sigma1", "sigma2", ]

df = CmdStan.convert_a3d(bayesian_result_stan.chains, bayesian_result_stan.cnames,
  Val(:dataframes));
df_stan = append!(append!(df[1], df[2]), append!(df[3], df[4]));
df_stan = df_stan[:, [10, 11, 12, 13, 8, 9]]
rename!(df_stan, Symbol.(cnames))

# DynamicHMC.jl backend

@time bayesian_result_dynamichmc = dynamichmc_inference(prob,Tsit5(),t,data,priors,
  num_samples=Int(4*num_samples));

N = length(bayesian_result_dynamichmc.posterior)

res_array = zeros(N, 6);
for i in 1:length(bayesian_result_dynamichmc.posterior)
  res_array[i,:] = vcat(
      bayesian_result_dynamichmc.posterior[i].parameters,
      bayesian_result_dynamichmc.posterior[i].σ
    )
end

df_dhmc = DataFrame(
  :theta1 => res_array[:, 1],
  :theta2 => res_array[:, 2],
  :theta3 => res_array[:, 3],
  :theta4 => res_array[:, 4],
  :sigma1 => res_array[:, 5],
  :sigma2 => res_array[:, 6]
)

sdf1 |> display
sdf2 |> display

println("\nDhmc results\n")
mean(res_array, dims=1) |> display
std(res_array, dims=1) |> display
println()

function plot_theta_results(
    dfs::DataFrame,
    dfd::DataFrame,
    varn::AbstractString,
    idx::Int,
    priors=priors
  )
  prior_theta = Symbol("prior_"*varn*string(idx))
  theta = Symbol(varn*string(idx))
  prior_theta_array = rand(priors[idx], size(dfs, 1))
  p1 = plot(prior_theta_array, xlab="prior_theta_$idx", leg=false)
  p2 = density(prior_theta_array, xlab="prior_theta_$idx", leg=false)
  p3 = plot(dfs[:, theta], xlab="theta_$idx", lab="stan")
  plot!(dfs[:, theta], lab="dhmc")
  p4 = density(dfs[:, theta], xlab="theta_$idx", lab="stan")
  density!(dfd[:, theta], lab="dhmc")
  p5 = density(dfs[:, :sigma1], xlab="sigma1", lab="stan")
  density!(dfd[:, :sigma1], lab="dhmc")
  p6 = density(dfs[:, :sigma2], xlab="sigma2", lab="stan")
  density!(dfd[:, :sigma2], lab="dhmc")

  plot(p1, p2, p3, p4, p5, p6, layout=(3,2))
  savefig("$(ProjDir)/$(varn)_$idx")

end

for i in 1:4
  plot_theta_results(df_stan, df_dhmc, "theta", i, priors)
end

original_stan_results ="
            mean se_mean    sd    10%    50%    90% n_eff Rhat
theta[1]   0.549   0.002 0.065  0.469  0.545  0.636  1163    1
theta[2]   0.028   0.000 0.004  0.023  0.028  0.034  1281    1
theta[3]   0.797   0.003 0.091  0.684  0.791  0.918  1125    1
theta[4]   0.024   0.000 0.004  0.020  0.024  0.029  1170    1
sigma[1]   0.248   0.001 0.045  0.198  0.241  0.306  2625    1
sigma[2]   0.252   0.001 0.044  0.201  0.246  0.310  2808    1
z_init[1] 33.960   0.056 2.909 30.363 33.871 37.649  2684    1
z_init[2]  5.949   0.011 0.533  5.294  5.926  6.644  2235    1
";

