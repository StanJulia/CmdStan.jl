using CmdStan, DiffEqBayes, OrdinaryDiffEq, ParameterizedFunctions,
      RecursiveArrayTools, Distributions, Test

ProjDir = @__DIR__
cd(ProjDir)

isdir("tmp") && rm("tmp", recursive=true)

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
randomized = VectorOfArray([(sol(t[i]) + .01randn(2)) for i in 1:length(t)])
data = convert(Array,randomized)

priors = [Normal(1.,0.01),Normal(1.,0.01),Normal(1.5,0.01)]
bayesian_result = stan_inference(prob1,t,data,priors;num_samples=300,
  num_warmup=500,likelihood=Normal,sample_u0=true)

sdf  = CmdStan.read_summary(bayesian_result.model)
@test sdf[sdf.parameters .== :theta1, :mean][1] ≈ 1. atol=3e-1
@test sdf[sdf.parameters .== :theta2, :mean][1] ≈ 1. atol=3e-1
@test sdf[sdf.parameters .== :theta3, :mean][1] ≈ 1.5 atol=3e-1
