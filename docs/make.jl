using Documenter, CmdStan
makedocs(
    format = :html,
    sitename = "CmdStan",
    pages = Any[
        "Introduction" => "INTRO.md",
        "Installation" => "INSTALLATION.md",
        "Walkthrough" => "WALKTHROUGH.md",
        "Versions" => "VERSIONS.md",
        "CmdStan.jl documentation" => "index.md",
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