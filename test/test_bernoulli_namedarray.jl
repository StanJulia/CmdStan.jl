ProjDir = joinpath(dirname(@__FILE__), "..", "examples", "BernoulliNamedArray")
cd(ProjDir) do

  isdir("tmp") &&
    rm("tmp", recursive=true);

  include(joinpath(ProjDir, "bernoulli_namedarray.jl"))

  isdir("tmp") &&
    rm("tmp", recursive=true);

end # cd
