ProjDir = joinpath(dirname(@__FILE__), "..", "examples", "Dyes")
cd(ProjDir) do

  isdir("tmp") &&
    rm("tmp", recursive=true);

  include(joinpath(ProjDir, "dyes.jl"))

  isdir("tmp") &&
    rm("tmp", recursive=true);

end # cd
