using CmdStan

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

observeddata = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])

stanmodel = Stanmodel(Sample(save_warmup=true, num_warmup=1000, 
  num_samples=2000, thin=1), name="bernoulli", model=bernoulli_model,
  printsummary=false, tmpdir=mktempdir());

rc, chn, cnames = stan(stanmodel, observeddata, ProjDir);

chns = chn[1001:end, :, :]

if rc == 0
  # Describe the results
  show(chns)
  println()
  
  # Ceate a ChainDataFrame
  summary_df = read_summary(stanmodel)
  summary_df[:theta, [:mean, :ess]]
end
