using CmdStan

## testing accessors to CMDSTAN_HOME
let oldpath = CmdStan.CMDSTAN_HOME
    newpath = CmdStan.CMDSTAN_HOME * "##test##"
    set_cmdstan_home!(newpath)
    @test CmdStan.CMDSTAN_HOME == newpath
    set_cmdstan_home!(oldpath)
    @test CmdStan.CMDSTAN_HOME == oldpath
end
