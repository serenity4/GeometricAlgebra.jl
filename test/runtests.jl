using GeometricAlgebra
using StaticArrays
using Test
using SafeTestsets

const ga = GeometricAlgebra

@safetestset "Implementation" begin include("implementations.jl") end

@safetestset "Identities in 𝓖₄" begin include("algebras/r4.jl") end

@safetestset "Identities in 𝓖₃,₁" begin include("algebras/spacetime.jl") end

include("aqua.jl")
