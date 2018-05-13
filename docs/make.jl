using Documenter, CmdStan
makedocs(
    format = :html,
    sitename = "StanJulia/CmdStan",
    pages = Any[
        "Introduction" => "INTRO.md",
        "Installation" => "INSTALLATION.md",
        "Walkthrough" => "WALKTHROUGH.md",
        "Versions" => "VERSIONS.md",
        "CmdStan.jl documentation" => "index.md",
    ]
)

deploydocs(
    repo = "https://github.com/StanJulia/CmdStan.jl",
    target = "build",
    julia = "nightly",
    osname = "linux",
    deps = nothing,
    make = nothing
 )