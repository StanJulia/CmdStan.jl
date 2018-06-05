## Notes on Pkg(3)

### Quick review of workflow for a new package

1. Move to a working directory where you would like the project subdirectory to be generated,  e.g. ~/.julia/dev (the default location for the `develop` command in Pkg REPL, see later).

1. Press ']'.

1. You're now in Pkg REPL and it will show the current project, `(0.7) pkg>` most likely (unless you moved to a package directory).

1. Type `generate PkgName`, e.g. `generate HelloWorld` as in the Pkg documentation.

1. Exit the Pkg REPL (press <del> on an empty Pkg REPL line) and moveove to the package directory, e.g. `cd("HelloWorld")`
  
1. Type ']' again. The Pkg REPL prompt should lokk like `(HelloWorld) pkg>`.

1. Add this point I typically add all packages I am planning to use, e.g. `add Compat`.

### Quick review of workflow for a previously registered package

1. 

### Quick review of workflow for an existing, not-registered package

1. 

### Some details

1. Pkg(3) expects Julia to run in the 'correct' directory. E.g. after `generate HelloWorld` ( as in the Pkg docs ) the project in the current working directory. The Pkg REPL relies on that as well.

1. I like this idea of having several Julia processes running, each bound to a project. Is that the idea? Pretty quickly I found myself constantly working in the Pkg REPL for a particular project.

1. Not sure if this is indeed correct, but in Pkg REPL simply typing `test` runs all tests. I did not restart Julia! If this is correct, that is super!!!!

1. (After saving the v0.6 subdirectory in .julia,) I tried if I could delete all of .julia.. That did work ok, dev, packages, registries, etc are recreated when needed.

1. All previously registered packages are in .julia/packages. These are not (never?) git repositories?

1. The version of a package that Julia selects with e.g. `using PtFEM` is solely determined by what is in Project.toml and Manifest.toml?

1. When in the Pkg REPL (or using Pkg.add(...)), will `add package_name` always select the most suitable registered version available? To override that, use an URL or local directory?

1. After working ( `develop ...` ) on a package in e.g. .julia/dev, the package is now ready for a new release. The Pkg documentation states: "When the PR has been merged we can go over to track the master branch and when a new release ...", does that mean `free package_name` by default will switch to master and on a future `up package_name` to the new release? 

1. In my case `review free PtFEM` returned an error (see below). I've also seen error messages related to package and project name being the same. This is clearly the area I struggle with most.  I guess the Pkg docs refer to existing packages added to a project. In my case both CmdStan.jl and PtFEM.jl are the targets of the development work. I kind of expected this to work for PtFEM (as it is already registered), but CmdStan.jl needs to be first registered I guess.

1. Still need to study switching between branches. In fact I'm hoping that after Julia 1.0 is released I can go back to just having a released version and a master branch. In my case, using Github Desktop to select the right branches, e.g. in .julia/v0.6 and .julia/v0.7, was error prone.

1. Also I'm not sure what the extra directory layer in .julia/packages/`packagename`/`xxxx`/ is for, I guess it is for version management using Manifest.toml?

1. Over the last couple of years I have learned the hard way that it is better to layer package dependencies as much as possible. I haven't studied that part of Pkg(3) yet. For now I plan to create base packages, e.g. CmdStan.jl and then layer creating DataFrames in a separate package (StanDataFrames). Similarly for StanMamba, StanPlotsRecipes, StanFeather etc., all part of the StanJulia organization. But I’ll certainly keep an eye on the discussion about [classes of packages in Github organizations]( https://discourse.julialang.org/t/the-4-kinds-of-metapackages-api-higher-level-packages/10947/3 )

1. The updates Scott suggested for .travis.yml (and appveyor.yml) seem to do the trick. This seems to simplify .travis.yml, e.g.: "  - julia -e 'using Pkg; Pkg.add("..."); Pkg.test("CmdStan"; coverage=true)'  ". Although I'm not sure why e.g. the Pkg.add("Compat") is required in .travis.yml and appveyor.yml.

1. Will there be a Curated registry in the future? 

1. Is the REQUIRE file still needed?

### Outstanding questions

1. 