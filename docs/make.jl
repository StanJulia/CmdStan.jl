using Documenter, CmdStan

makedocs(
    modules = [CmdStan],
    format = :html,
    sitename = "StanJulia/CmdStan.jl",
    pages = Any[
        "Introduction" => "INTRO.md",
        "Installation" => "INSTALLATION.md",
        "Walkthrough" => "WALKTHROUGH.md",
        "Versions" => "VERSIONS.md",
        "Home" => "index.md",
    ]
)

deploydocs(
    repo = "github.com/StanJulia/CmdStan.jl.git",
    target = "build",
    julia = "nightly",
    osname = "linux",
    deps = nothing,
    make = nothing
 )