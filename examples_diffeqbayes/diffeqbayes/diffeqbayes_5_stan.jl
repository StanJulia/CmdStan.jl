using CmdStan, DiffEqBayes, OrdinaryDiffEq, ParameterizedFunctions,
      RecursiveArrayTools, Distributions, Test

ProjDir = @__DIR__
cd(ProjDir)

isdir("tmp") && rm("tmp", recursive=true)

f1 = @ode_def begin
  dx = a*x - b*x*y
  dy = -c*y + d*x*y
end a b c d
u0 = [1.0,1.0]
tspan = (0.0,10.0)
p = [1.5,1.0,3.0,1.0]
prob1 = ODEProblem(f1,u0,tspan,p)
sol = solve(prob1,Tsit5())
t = collect(range(1,stop=10,length=10))
randomized = VectorOfArray([(sol(t[i]) + .01randn(2)) for i in 1:length(t)])
data = convert(Array,randomized)
priors = [Truncated(Normal(1.5,0.3),0,2),Truncated(Normal(2.0,0.3),0,1.5),
          Truncated(Normal(2.0,0.3),0,4),Truncated(Normal(0.0,0.3),0,2)]

bayesian_result = stan_inference(prob1,t,data,priors;num_samples=4000,
  num_warmup=1000,vars =(DiffEqBayes.StanODEData(),InverseGamma(4,1)))
sdf  = CmdStan.read_summary(bayesian_result.model)
@test sdf[sdf.parameters .== :theta1, :mean][1] ≈ 1.5 atol=1e-1
@test sdf[sdf.parameters .== :theta2, :mean][1] ≈ 1.0 atol=1e-1
@test sdf[sdf.parameters .== :theta3, :mean][1] ≈ 3.0 atol=1e-1
@test sdf[sdf.parameters .== :theta4, :mean][1] ≈ 1.0 atol=1e-1