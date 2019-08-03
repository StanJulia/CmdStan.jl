using StanSample

ProjDir = @__DIR__
cd(ProjDir)

bernoulli_model = "
  functions{
    #include model_specific_funcs.stan
    #include shared_funcs.stan // a comment  
    //#include shared_funcs.stan // a comment  
  }
  data { 
    int<lower=1> N; 
    int<lower=0,upper=1> y[N];
  } 
  parameters {
    real<lower=0,upper=1> theta;
  } 
  model {
    model_specific_function();
    theta ~ beta(my_function(),1);
    y ~ bernoulli(theta);
  }
";

try
  stanmodel = SampleModel("bernoulli", bernoulli_model, tmpdir=tmpdir)
catch e
  println(e)
  model = open(f -> read(f, String), tmpdir*"/bernoulli.stan")
  println(model)
  println()
end  
observeddata = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])

(sample_file, log_file) = stan_sample(stanmodel, data=observeddata)

if sample_file !== Nothing
  # Convert to an MCMCChains.Chains object
  chns = read_samples(stanmodel)

  # Describe the MCMCChains using MCMCChains statistics
  cdf = describe(chns)
  display(cdf)

  # Show cmdstan summary in DataFrame format
  sdf = read_summary(stanmodel)
  display(sdf)
  println()

  # Retrieve mean value of theta from the summary
  sdf[:theta, :mean]
end
