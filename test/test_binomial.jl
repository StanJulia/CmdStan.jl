ProjDir = joinpath(dirname(@__FILE__), "..", "examples", "Binomial")
cd(ProjDir) do

  isdir("tmp") &&
    rm("tmp", recursive=true);

  include(joinpath(ProjDir, "binomial.jl"))

  isdir("tmp") &&
    rm("tmp", recursive=true);

end # cd
