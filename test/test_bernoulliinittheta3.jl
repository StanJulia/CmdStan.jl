ProjDir = joinpath(dirname(@__FILE__), "..", "examples", "BernoulliInitTheta")
cd(ProjDir) do

  isdir("tmp") &&
    rm("tmp", recursive=true);

  include(joinpath(ProjDir, "bernoulliinittheta3.jl"))

  isdir("tmp") &&
    rm("tmp", recursive=true);

end # cd
