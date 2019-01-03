using Documenter, CmdStan

makedocs(
    modules = [CmdStan],
    format = :html,
    sitename = "StanJulia/CmdStan.jl",
    pages = Any[
        "Home" => "INTRO.md",
        "Installation" => "INSTALLATION.md",
        "Walkthrough" => "WALKTHROUGH.md",
        "Versions" => "VERSIONS.md",
        "Index" => "index.md"
    ]
)

deploydocs(
    repo = "github.com/StanJulia/CmdStan.jl.git",
 )