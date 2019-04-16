using MCMCChains, Test

ProjDir = joinpath(dirname(@__FILE__), "..", "examples", "EightSchools")
cd(ProjDir) do

  isdir("tmp") &&
    rm("tmp", recursive=true);

  include(joinpath(ProjDir, "schools8.jl"))
  
  if rc == 0
    s = summarize(chns)
    @test s[:mu, :mean][1] ≈ 7.7 atol=1.0
  end
  
  isdir("tmp") &&
    rm("tmp", recursive=true);

end # cd
