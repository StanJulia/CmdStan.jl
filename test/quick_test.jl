datatype = Union{
  Dict{String, T} where {T <: Any},
  Vector{Dict{String, T}} where {T <: Any}
}

mutable struct Mymodel
  data::datatype
  init::datatype
end

function Mymodel(;data=Dict{String, Any}(), init=Dict{String,Any}())
  Mymodel(mydata, myinit)
end

dd = Dict("theta" => 1, "alpha" => 3.0)
id = Dict("sigma" => 1.0)

m1 = Mymodel(data=dd, init=id)

@show m1
println()

dd2 = [Dict("theta" => 1, "alpha" => 3.0),
  Dict("theta" => 1, "alpha" => 3.0)]

id2 = [Dict("sigma" => 1.0)]

m2 = Mymodel(data=dd2, init=id2)

@show m2
println()

m3 = Mymodel(data=dd2)

@show m3
