using Documenter, CmdStan

DOC_ROOT = rel_path("..", "docs")

makedocs( root = DOC_ROOT,
  modules = [],
  sitename = "StanJulia/CmdStan.jl",
  authors = "Rob J Goedman",
  pages = Any[
      "Home" => "INTRO.md",
      "Installation" => "INSTALLATION.md",
      "Walkthrough" => "WALKTHROUGH.md",
      "Versions" => "VERSIONS.md",
      "Index" => "index.md"
  ]
)

deploydocs(
  root = DOC_ROOT,
  repo = "github.com/StanJulia/CmdStan.jl.git",
 )