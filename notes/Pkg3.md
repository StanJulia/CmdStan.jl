Encouraged by this thread ( [Switching to Pkg3](https://discourse.julialang.org/t/problems-after-switch-to-pkg3/11144) )
I also ventured there for a redo of Stan.jl for Julia 0.7/1.0 ( [StanJulia](https://github.com/StanJulia) ).
And as Scott mentioned, it is very different, I like it though.

CmdStan.jl is maybe 80% there. I'm left with several questions, maybe mainly workflow related:

1. Does Pkg(3) expects Julia to run in the 'correct' directory? E.g. after `generate HelloWorld` I found the project
 in the current working directory. I like the idea of having several Julia processes running each bound to a project.
 
1. Can I still remove .julia? (I guess after saving v0.6?)

1. When I started adding packages to Julia 0.7- (using the Pkg REPL more and more!) they all seem to end 
up in ~/julia/dev. That happened for not (yet) published packages but also for previously registered packaged 
in METADATA. For previously registered packages I now have versions in the Uncurated registry and in ./dev. 

1. Will there be a Curated registry in the future?

1. I'm confused which one Julia selects when entering e.g. `using PtFEM`. 

1. For one package I did use `develop PtFEM` 


