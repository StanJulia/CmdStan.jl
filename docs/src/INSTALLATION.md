# cmdstan installation

## Minimal requirement

Note: CmdStan.jl and CmdStan refer this Julia package. The executable C++ program is 'cmdstan'.

To run this version of the CmdStan.jl package on your local machine, it assumes that the  [cmdstan] (http://mc-stan.org/interfaces/cmdstan) executable is properly installed.

In order for CmdStan.jl to find the cmdstan you need to set the environment variable CMDSTAN_HOME to point to the cmdstan directory, e.g. add

```
export CMDSTAN_HOME=/Users/rob/Projects/Stan/cmdstan
launchctl setenv CMDSTAN_HOME /Users/rob/Projects/Stan/cmdstan
```

to .bash_profile. I typically prefer cmdstan not to include the cmdstan version number so no update is needed when cmdstan is updated.

Currently tested with cmdstan 2.17.1

## Additional OSX options

Thanks to Robert Feldt and the brew folks, in addition to the user following the steps in Stan's cmdstan User's Guide, cmdstan can also be installed using brew or Julia's Homebrew.

	 Executing in a terminal:
	 ```
	 brew tap homebrew/science
	 brew install cmdstan
	 ```
	 should install the latest available (on Homebrew) cmdstan in /usr/local/Cellar/cmdstan/x.x.x
	 
	 Or, from within the Julia REPL:
	 ```cmdstan  Homebrew
	 Homebrew.add("homebrew/science/cmdstan")
	 ```
	 will install CmdStan in ~/.julia/v0.x/Homebrew/deps/usr/Cellar/cmdstan/x.x.x.
