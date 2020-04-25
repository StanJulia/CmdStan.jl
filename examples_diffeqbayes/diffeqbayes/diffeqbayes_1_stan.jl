using CmdStan, MCMCChains, StatsPlots, DiffEqBayes, OrdinaryDiffEq,
  ParameterizedFunctions, RecursiveArrayTools, Distributions, Test

ProjDir = @__DIR__
cd(ProjDir)

isdir("tmp") && rm("tmp", recursive=true)

println("\nOne parameter case\n")

f1 = @ode_def begin
  dx = a*x - x*y
  dy = -3y + x*y
end a
u0 = [1.0,1.0]
tspan = (0.0,10.0)
p = [1.5]
prob1 = ODEProblem(f1,u0,tspan,p)
sol = solve(prob1,Tsit5())
t = collect(range(1,stop=10,length=30))
randomized = VectorOfArray([(sol(t[i]) + .39randn(2)) for i in 1:length(t)])
data = convert(Array,randomized)

scatter(t, data[1,:], lab="#prey (data)")
scatter!(t, data[2,:], lab="#predator (data)")
plot!(sol)
savefig("$(ProjDir)/fig_01.png")

priors = [truncated(Normal(1.0, 0.3), 0, 3)]
nchains = 4
num_samples = 1000

bayesian_result = stan_inference(prob1, t, data,priors;
  num_samples=num_samples, num_warmup=500, 
  likelihood=Normal, nchains=nchains)

sdf  = CmdStan.read_summary(bayesian_result.model)
df = CmdStan.convert_a3d(bayesian_result.chains, bayesian_result.cnames,
  Val(:dataframes));

for i in 1:nchains
  global p1
  df[i][!, :prior_theta1] = rand(priors[1], num_samples)
  if i == 1
    p1 = plot(df[i][:, :prior_theta1], xlab="prior_theta1", leg=false)
  else
    plot!(df[i][:, :prior_theta1], xlab="prior_theta1", leg=false)
  end
end
for i in 1:nchains
  global p2
  if i == 1
    p2 = density(df[i][:, :prior_theta1], xlab="prior_theta1", leg=false)
  else
    density!(df[i][:, :prior_theta1], xlab="prior_theta1", leg=false)
  end
end
for i in 1:nchains
  global p3
  if i == 1
    p3 = plot(df[i][:, :theta1], xlab="theta1", leg=false)
  else
    plot!(df[i][:, :theta1], xlab="theta1", leg=false)
  end
end
for i in 1:nchains
  global p4
  if i == 1
    p4 = density(df[i][:, :theta1], xlab="theta1", leg=false)
  else
    density!(df[i][:, :theta1], xlab="theta1", leg=false)
  end
end

plot(p1, p2, p3, p4, layout=(2,2))
savefig("$(ProjDir)/diffeqbayes_1_stan.png")

@test sdf[sdf.parameters .== :theta1, :mean][1] ≈ 1.5 atol=3e-1
