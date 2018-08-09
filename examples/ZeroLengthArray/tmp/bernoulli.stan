data { 
    int<lower=1> N; 
    int<lower=0,upper=1> y[N];
    real empty[0];
  } 
  parameters {
    real<lower=0,upper=1> theta;
  } 
  model {
    theta ~ beta(1,1);
    y ~ bernoulli(theta);
  }