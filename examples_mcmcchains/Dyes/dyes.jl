######### CmdStan batch program example  ###########

using CmdStan, MCMCChains

ProjDir = dirname(@__FILE__)
cd(ProjDir) do

  dyes ="
  data {
    int BATCHES; 
    int SAMPLES; 
    real y[BATCHES, SAMPLES]; 
    // vector[SAMPLES] y[BATCHES]; 
  } 
  parameters {
    real<lower=0> tau_between;
    real<lower=0> tau_within; 
    real theta;
    real mu[BATCHES]; 
  } 
  transformed parameters {
    real sigma_between; 
    real sigma_within;
    sigma_between <- 1/sqrt(tau_between); 
    sigma_within <- 1/sqrt(tau_within); 
  } 
  model {
    theta ~ normal(0.0, 1E5); 
    tau_between ~ gamma(.001, .001); 
    tau_within ~ gamma(.001, .001); 
    mu ~ normal(theta, sigma_between);
    for (n in 1:BATCHES)  
      y[n] ~ normal(mu[n], sigma_within);
  }
  generated quantities {
    real sigmasq_between;
    real sigmasq_within;
  
    sigmasq_between <- 1 / tau_between;
    sigmasq_within <- 1 / tau_within;
  }
  "

  dyesdata = Dict("BATCHES" => 6,
      "SAMPLES" => 5,
      "y" => reshape([
        [1545, 1540, 1595, 1445, 1595]; 
        [1520, 1440, 1555, 1550, 1440]; 
        [1630, 1455, 1440, 1490, 1605]; 
        [1595, 1515, 1450, 1520, 1560]; 
        [1510, 1465, 1635, 1480, 1580]; 
        [1495, 1560, 1545, 1625, 1445]
      ], 6, 5)
    )

  global stanmodel, rc, sim, cnames, chns
  
  stanmodel = Stanmodel(name="dyes", model=dyes, output_format=:mcmcchains);
  
  @time rc, sim, cnames = stan(stanmodel, dyesdata, ProjDir,
    CmdStanDir=CMDSTAN_HOME)

  if rc == 0
    pi = filter(p -> length(p) > 2 && p[end-1:end] == "__", cnames)
    p = filter(p -> !(p in  pi), cnames)
    
    chns = set_section(sim, 
      Dict(
        :parameters => ["theta", 
          "tau_between", "tau_within", 
          "sigma_between", "sigma_within",
          "sigmasq_between", "sigmasq_within"],
        :mu => ["mu.$i" for i in 1:6],
        :internals => pi
      )
    )
    show(chns)
    describe(chns, sections=[:mu])

  end
end # cd