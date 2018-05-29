Encouraged by this thread ( [Switching to Pkg3](https://discourse.julialang.org/t/problems-after-switch-to-pkg3/11144) )
I also ventured into Pkg(3) land for a redo of Stan.jl for Julia 0.7/1.0 ( [StanJulia](https://github.com/StanJulia) ) and similarly for a previously registered project PtFEM.jl ( [PtFEM](https://github.com/PtFEM) ). Both Github organizations (StanJulia and PtFEM) currently hold several related work-in-progress packages.

And as Scott mentioned, working in/with Pkg(3) is very different, I like it though. Both StanJulia/CmdStan.jl and PtFEM/PtFEM.jl are maybe 80% there. 

I'm left with several questions/observations, mainly workflow related:

1. It seems Pkg(3) expects Julia to run in the 'correct' directory? E.g. after `generate HelloWorld` ( as in the Pkg docs ) I found the project in the current working directory. The Pkg REPL also relies on that I think.

1. I like this idea of having several Julia processes running, each bound to a project. Is that the idea? Pretty quickly I found myself constantly working in the Pkg REPL for a particular project.

1. Not sure if this is indeed correct, but in Pkg REPL simply typing `test` runs all tests. I did not restart Julia! If this is correct, that is super!!!!
 
1. (After saving the v0.6 subdirectory in .julia,) I tried if I could delete all of .julia.. That did work ok, dev, packages, registries, etc are recreated when needed.

1. All previously registered packages are in .julia/packages. These are not (never?) git repositories?

1. The version of a package that Julia selects with e.g. `using PtFEM` is solely determined by what is in Project.toml and Manifest.toml?

1. When in the Pkg REPL (or using Pkg.add(...)), will `add package_name` always select the most suitable registered version available? To override that, use an URL or local directory?

1. After working ( `develop ...` ) on a package in e.g. .julia/dev, the package is now ready for a new release. The Pkg documentation states: "When the PR has been merged we can go over to track the master branch and when a new release ...", does that mean `free package_name` by default will switch to master and on a future `up package_name` to the new release? 

1. In my case `review free PtFEM` returned an error (see below). I've also seen error messages related to package and project name being the same. This is clearly the area I struggle with most.  I guess the Pkg docs refer to existing packages added to a project. In my case both CmdStan.jl and PtFEM.jl are the targets of the development work.

1. Still need to study switching between branches. In fact I'm hoping that after Julia 1.0 is released I can go back to just having a released version and a master branch.

1. Also I'm not sure what the extra directory layer in .julia/packages/`packagename`/`xxxx`/ is for, I guess it is for version management using Manifest.toml?

1. Over the last couple of years I have learned the hard way that it is better to layer package dependencies as much as possible. I haven't studied that part of Pkg(3) yet. For now I plan to create base packages, e.g. CmdStan.jl and then layer creating DataFrames in a seoarate package (StanDataFrames). Similarly for StanMamba, StanPlotsRecipes, StanFeather etc., all part of the StanJulia organization. But I’ll certainly keep an eye on the discussion about [classes of packages in Github organizations]( https://discourse.julialang.org/t/the-4-kinds-of-metapackages-api-higher-level-packages/10947/3 )

1. The updates Scott suggested for .travis.yml (and appveyor.yml) seem to do the trick. This seems to simplify .travis.yml, e.g.: "  - julia -e 'using Pkg; Pkg.add("..."); Pkg.test("CmdStan"; coverage=true)'  ". Although I'm not sure why e.g. the Pkg.add("Compat") is required in .travis.yml and appveyor.yml.

1. Will there be a Curated registry in the future? 

1. Is the REQUIRE file still needed?

Just wanted to capture these [notes](https://github.com/StanJulia/CmdStan.jl/blob/master/notes/Pkg3.md) for my own use, but maybe they are helpful for others (as Scott's thread was to me). Feedback is of course always welcome.

Rob


------------------------


(PtFEM) pkg> preview free PtFEM
───── Preview mode ─────
ERROR: MethodError: no method matching get(::Nothing, ::String, ::Bool)
Closest candidates are:
  get(::Base.EnvDict, ::AbstractString, ::Any) at env.jl:77
  get(::REPL.Terminals.TTYTerminal, ::Any, ::Any) at /Users/rob/Projects/Julia/julia/usr/share/julia/stdlib/v0.7/REPL/src/Terminals.jl:174
  get(::IdDict{K,V}, ::Any, ::Any) where {K, V} at abstractdict.jl:624
  ...
Stacktrace:
 [1] #free#30(::Base.Iterators.Pairs{Union{},Union{},Tuple{},NamedTuple{(),Tuple{}}}, ::Function, ::Pkg.Types.Context, ::Array{Pkg.Types.PackageSpec,1}) at /Users/rob/Projects/Julia/julia/usr/share/julia/stdlib/v0.7/Pkg/src/API.jl:187
 [2] free at /Users/rob/Projects/Julia/julia/usr/share/julia/stdlib/v0.7/Pkg/src/API.jl:172 [inlined]
 [3] do_free!(::Pkg.Types.Context, ::Array{Union{Pkg.Types.VersionRange, String, Pkg.REPLMode.Command, Pkg.REPLMode.Option, Pkg.REPLMode.Rev},1}) at /Users/rob/Projects/Julia/julia/usr/share/julia/stdlib/v0.7/Pkg/src/REPLMode.jl:664
 [4] #invokelatest#1 at ./essentials.jl:667 [inlined]
 [5] invokelatest at ./essentials.jl:666 [inlined]
 [6] do_cmd!(::Array{Union{Pkg.Types.VersionRange, String, Pkg.REPLMode.Command, Pkg.REPLMode.Option, Pkg.REPLMode.Rev},1}, ::REPL.LineEditREPL) at /Users/rob/Projects/Julia/julia/usr/share/julia/stdlib/v0.7/Pkg/src/REPLMode.jl:273
 [7] #do_cmd#8(::Bool, ::Function, ::REPL.LineEditREPL, ::String) at /Users/rob/Projects/Julia/julia/usr/share/julia/stdlib/v0.7/Pkg/src/REPLMode.jl:233
 [8] do_cmd at /Users/rob/Projects/Julia/julia/usr/share/julia/stdlib/v0.7/Pkg/src/REPLMode.jl:230 [inlined]
 [9] (::getfield(Pkg.REPLMode, Symbol("##27#30")){REPL.LineEditREPL,REPL.LineEdit.Prompt})(::REPL.LineEdit.MIState, ::Base.GenericIOBuffer{Array{UInt8,1}}, ::Bool) at /Users/rob/Projects/Julia/julia/usr/share/julia/stdlib/v0.7/Pkg/src/REPLMode.jl:948
 [10] top-level scope
