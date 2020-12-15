using GeometricAlgebra
using StaticArrays
using Test
using SafeTestsets

const ga = GeometricAlgebra

@safetestset "Implementation" begin include("implementations.jl") end

testsets = [("𝓖₄", "++++"), ("𝒢₃,₁", "+++-")]

@testset "Identities in $name" for (name, sig) ∈ testsets
    begin
        @eval @basis $sig
        include("operators.jl")
    end
end

include("aqua.jl")
