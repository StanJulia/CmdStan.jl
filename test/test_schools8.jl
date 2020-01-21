using CmdStan, Test

ProjDir = joinpath(dirname(@__FILE__), "..", "examples", "EightSchools")
cd(ProjDir) do

  isdir("tmp") &&
    rm("tmp", recursive=true);

  include(joinpath(ProjDir, "schools8.jl"))
  
  isdir("tmp") &&
    rm("tmp", recursive=true);

end # cd
