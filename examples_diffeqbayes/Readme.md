# LotkaVolterra example in Stan and DiffEqBayes formulations.

This subdirectory contains 7 versions of the LV lynx-hare example.

1. lv_benchmark is basically the benchmark as in DiffEqBayes
2. lv_benchmark_1 identified the lynx-hare coefficients using the lynx-hare data
3. lv_benchmark_2 uses the DiffEqBayes generated data
4. lv_benchmark_3 also runs a DynamicHMC example
5. lv_benchmark_stan is the original Stan formulation in StanSample and cmdstan
6. lv_benchmark_stan_1 uses the lynx-hare data and the DiffEqBayes formulation
7. lv_benchmark_stan_2 uses the DiffEqBayes generated data and model formulation.

All simulations usually produce results close to the expected solution.
All formulations, including 5, occasionally have chains that do not converge.
