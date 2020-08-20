using CmdStan, Test

cnames = ["x", "y.1", "y.2", "z.1.1", "z.2.1", "z.3.1", "z.1.2", "z.2.2", "z.3.2", "k.1.1.1.1.1"]
draws = 100
vars = length(cnames)
chains = 2
chns = randn(draws, vars, chains)
nt = extract(chns, cnames)

@testset "extract" begin
    # Write your tests here.
    
    @test size(nt.x) == (draws, chains)
    @test size(nt.y) == (2, draws, chains)
    @test size(nt.z) == (3, 2, draws, chains)
    @test size(nt.k) == (1, 1, 1, 1, 1, draws, chains)

    key_to_idx = Dict(name => idx for (idx, name) in enumerate(cnames))

    @test nt.x[2,1] == chns[2, key_to_idx["x"], 1]
    @test nt.y[2,3,2] == chns[3, key_to_idx["y.2"], 2]
    @test nt.z[3, 1, 10, 1] == chns[10, key_to_idx["z.3.1"], 1]
    @test nt.k[1,1,1,1,1,draws,2] == chns[draws, key_to_idx["k.1.1.1.1.1"], 2]

    @test keys(nt) == (:y, :k, :z, :x)
    @test size(values(nt.z)) == (3, 2, 100, 2)
    @test size(nt.z) == (3, 2, 100, 2)

end
