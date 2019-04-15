ProjDir = joinpath(dirname(@__FILE__), "..", "examples", "BernoulliDiagnostics")
cd(ProjDir) do

  isdir("tmp") &&
    rm("tmp", recursive=true);

  include(joinpath(ProjDir, "bernoulli_diagnostics.jl"))

  isdir("tmp") &&
    rm("tmp", recursive=true);

end # cd
