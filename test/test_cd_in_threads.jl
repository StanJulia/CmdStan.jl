#=
println("hither : ",Threads.threadid()," : ",pwd()) # hither : 1 : /tmp
Threads.@spawn cd( () -> ( println("tither : ",Threads.threadid(), " : ", pwd()); sleep(3)), "..") # tither : 2 : /
sleep(1);println("hither : ",Threads.threadid(), " : ", pwd());sleep(3) # hither : 1 : /
println("hither : ",Threads.threadid()," : ",pwd()) # hither : 1 : /tmp
=#


cd(@__DIR__)

println("hither : ",Threads.threadid()," : ",pwd()) # hither : 1 : ./CmdStan/test

Threads.@spawn cd( () -> ( println("tither : ",Threads.threadid(), " : ",
  pwd()); sleep(3)), "..") # tither : 2 : ./CmdStan

sleep(1)

println("hither : ",Threads.threadid()," : ", pwd())  # hither : 1 : ./CmdStan

sleep(3)

println("hither : ",Threads.threadid()," : ", pwd()) # hither : 1 : ./CmdStan/test
