######### CmdStan program example  ###########

using CmdStan

ProjDir = @__DIR__
cd(ProjDir) do

  bernoullimodel = "
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

  observeddata = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])

  # Preserve these variables outside cd/do block.
  global stanmodel, rc, samples, cnames, df
    
  stanmodel = Stanmodel(name="bernoulli", model=bernoullimodel,
    printsummary=false);

  rc, samples, cnames = stan(stanmodel, observeddata, ProjDir, CmdStanDir=CMDSTAN_HOME);
  
  if rc == 0
    # Fetch cmdstan summary as a DataFrame
    df = read_summary(stanmodel)

    df |> display
    println()

    df[df.parameters .== :theta, [:mean, :ess, :r_hat]] |> display
  end

end # cd block
