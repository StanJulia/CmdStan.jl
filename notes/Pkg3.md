Encouraged by this thread ( [Switching to Pkg3](https://discourse.julialang.org/t/problems-after-switch-to-pkg3/11144) )
I also ventured into Pkg(3) land for a redo of Stan.jl for Julia 0.7/1.0 ( [StanJulia](https://github.com/StanJulia) ) and similarly for a previously registered project PtFEM.jl ( [PtFEM](https://github.com/PtFEM) ). Both Github organizations currently hold several related work-in-progress packages.

And as Scott mentioned, Pkg(3) is very different, I like it though. Both StanJulia/CmdStan.jl and PtFEM/PtFEM.jl are maybe 80% there. 

I'm left with several questions/observations, mainly workflow related:

1. It seems Pkg(3) expects Julia to run in the 'correct' directory? E.g. after `generate HelloWorld` ( as in the Pkg docs ) I found the project in the current working directory. The Pkg REPL also relies on that I think.

1. I like this idea of having several Julia processes running, each bound to a project. Is that the idea? Pretty quickly I found myself constantly working in the Pkg REPL for a particular project.
 
1. (After saving the v0.6 subdirectory in .julia,) I tried if I could delete all of .julia.. That did work ok, dev, packages, registries, etc are recreated when needed.

1. All previously registered packages are in .julia/packages. These are not (never?) git repositories?

1. The version of a package that Julia selects with e.g. `using PtFEM` is solely determined by what is in Project.toml and Manifest.toml?

1. When in the Pkg REPL (or using Pkg.add(...)), will `add package_name` always select the most suitable registered version available? To override that, use an URL?

1. After working ( `develop ...` ) on a package in e.g. .julia/dev, the package is now ready for a new release. The Pkg documentation states: "When the PR has been merged we can go over to track the master branch and when a new release ...", does that means `free package_name` by default will switch to master and on a future `up package_name` to the new release?

1. The updates Scott suggested for .travis.yml (and appveyor.yml?) seem to do the trick. This seems to simplify .travis.yml, e.g.: "  - julia -e 'using Pkg; Pkg.test("CmdStan"; coverage=true)'  "

1. Will there be a Curated registry in the future? 

1. Is REQUIRE still needed?


