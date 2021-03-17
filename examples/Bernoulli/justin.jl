#pkg"add CmdStan"

using CmdStan, Statistics
bm = "
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
data = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])
sm = Stanmodel(name="bernoulli", model=bm, printsummary=false)
sm |> display

rc, samples, cnames = stan(sm, data; CmdStanDir=CMDSTAN_HOME)
if rc == 0
  nt = CmdStan.convert_a3d(samples, cnames, Val(:namedtuple))
  mean(nt.theta, dims=1) |> display
  sdf = read_summary(sm)
  sdf |> display
end
