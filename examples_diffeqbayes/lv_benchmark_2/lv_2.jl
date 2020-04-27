using DiffEqBayes, CmdStan, DynamicHMC, DataFrames
using Distributions, BenchmarkTools
using OrdinaryDiffEq, RecursiveArrayTools, ParameterizedFunctions

using StatsPlots, CSV
gr(size=(600,900))

ProjDir = @__DIR__
cd(ProjDir)

df = CSV.read("$(ProjDir)/lynx_hare.csv", delim=",")

f = @ode_def LotkaVolterraTest begin
    dx = a*x - b*x*y
    dy = -c*y + d*x*y
end a b c d

u0 = [30.0, 4.0]
tspan = (0.0, 21.0)
p = [0.55, 0.028, 0.84, 0.026]

prob = ODEProblem(f,u0,tspan,p)
sol = solve(prob,Tsit5())

t = collect(range(1,stop=20,length=20))
data = transpose(hcat(df[2:end, :Hare], df[2:end, :Lynx]))

scatter(t, data[1,:], lab="#prey (data)")
scatter!(t, data[2,:], lab="#predator (data)")
plot!(sol)
savefig("$(ProjDir)/fig_01.png")

priors = [truncated(Normal(1,0.5),0.1,3),truncated(Normal(0.05,0.1),0,2),
  truncated(Normal(1,0.5),0.1,4),truncated(Normal(0.05,0.1),0,2)]

nchains = 4
num_samples = 800
@time bayesian_result_stan = stan_inference(prob,t,data,priors,
  num_samples=num_samples, printsummary=false, nchains=nchains);
sdf1  = CmdStan.read_summary(bayesian_result_stan.model)
println()

@time bayesian_result_stan = stan_inference(prob,t,data,priors,
  num_samples=num_samples, printsummary=false, nchains=nchains,
  stanmodel=bayesian_result_stan.model);
sdf2  = CmdStan.read_summary(bayesian_result_stan.model)
println()

cnames = ["theta1", "theta2", "theta3", "theta4", "sigma1", "sigma2", ]

df = CmdStan.convert_a3d(bayesian_result_stan.chains, bayesian_result_stan.cnames,
  Val(:dataframes));
df_stan = append!(append!(df[1], df[2]), append!(df[3], df[4]));
df_stan = df_stan[:, [10, 11, 12, 13, 8, 9]]
rename!(df_stan, Symbol.(cnames))

function plot_theta_results(
    dfs::DataFrame,
    varn::AbstractString,
    idx::Int,
    priors=priors
  )
  prior_theta = Symbol("prior_"*varn*string(idx))
  theta = Symbol(varn*string(idx))
  prior_theta_array = rand(priors[idx], size(dfs, 1))
  p1 = plot(prior_theta_array, xlab="prior_theta_$idx", leg=false)
  p2 = density(prior_theta_array, xlab="prior_theta_$idx",
    leg=false)
  p3 = plot(dfs[:, theta], xlab="theta_$idx", lab="stan")
  p4 = density(dfs[:, theta], xlab="theta_$idx",
    lab="stan")

  plot(p1, p2, p3, p4, layout=(2,2))
  savefig("$(ProjDir)/$(varn)_$idx")

end

for i in 1:4
  plot_theta_results(df_stan, "theta", i, priors)
end


sdf2 |> display
