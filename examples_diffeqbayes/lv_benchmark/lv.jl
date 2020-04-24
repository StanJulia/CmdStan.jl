using DiffEqBayes, CmdStan, DynamicHMC, DataFrames
using Distributions, BenchmarkTools
using OrdinaryDiffEq, RecursiveArrayTools, ParameterizedFunctions
using StatsPlots
gr(size=(600,900))

ProjDir = @__DIR__
cd(ProjDir)

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

priors = [Truncated(Normal(1.5,0.5),0.1,3.0),Truncated(Normal(1.2,0.5),0,2),
  Truncated(Normal(3.0,0.5),1,4),Truncated(Normal(1.0,0.5),0,2)]

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

@time bayesian_result_stan = stan_inference(prob,t,data,priors,
  num_samples=num_samples, printsummary=false, nchains=4, stanmodel=bayesian_result_stan.model);
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

