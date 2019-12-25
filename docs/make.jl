using CmdStan, Documenter

DOC_ROOT = rel_path_cmdstan("..", "docs")
DocDir =  rel_path("..", "docs", "src")

page_list = Array{Pair{String, Any}, 1}();
append!(page_list, [Pair("Home", "INTRO.md")]);
append!(page_list, [Pair("Installation", "INSTALLATION.md")]);
append!(page_list, [Pair("Walkthrough", "WALKTHROUGH.md")]);
append!(page_list, [Pair("Versions", "VERSIONS.md")]);
append!(page_list, [Pair("Functions", "index.md")]);

makedocs( 
  format = Documenter.HTML(prettyurls = haskey(ENV, "GITHUB_ACTIONS")),
  root = DOC_ROOT,
  modules = Module[],
  sitename = "CmdStan.jl",
  authors = "Rob J Goedman",
  pages = page_list,
)

deploydocs(
    root = DOC_ROOT,
    repo = "github.com/StanJulia/CmdStan.jl.git",
    versions = "v#",
    devbranch = "master",
    push_preview = true,
 )
