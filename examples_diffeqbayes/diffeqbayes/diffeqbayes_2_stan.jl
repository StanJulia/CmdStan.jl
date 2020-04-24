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
t = collect(range(1,stop=10,length=10))

sol = solve(prob1,Tsit5(),save_idxs=[1])
randomized = VectorOfArray([(sol(t[i]) + .01 * randn(1)) for i in 1:length(t)])
data = convert(Array,randomized)
priors = [Truncated(Normal(1.5,0.1),0,2)]
bayesian_result = stan_inference(prob1,t,data,priors;num_samples=300,
  num_warmup=500,likelihood=Normal,save_idxs=[1])

sdf  = CmdStan.read_summary(bayesian_result.model)
@test sdf[sdf.parameters .== :theta1, :mean][1] ≈ 1.5 atol=3e-1
