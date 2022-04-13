module GeometricAlgebra

using StaticArrays
using Combinatorics

import Base: sum, +, -, *, /, ^, inv, reverse, ==, ≈, eltype, promote_rule, length, zero, iszero, fill, getindex, setindex!, broadcastable, convert, show

abstract type GeometricAlgebraType end

broadcastable(x::GeometricAlgebraType) = Ref(x)

include("utils.jl")
include("indices.jl")
include("signatures.jl")
include("blades.jl")
include("basis.jl")
include("multivectors.jl")
include("operators.jl")

export @basis,

    # algebra elements
    Blade,
    KVector,
    Bivector,
    Trivector,
    Quadvector,
    Multivector,
    blades,
    nonzero_blades,
    grade,
    grades,
    is_homogeneous,
    scalar,

    # index manipulation
    linear_index,
    indices_from_linear_index,

    # signatures
    Signature,
    dimension,
    triplet,
    is_degenerate,
    metric,

    # operators
    geom, geom!,
    ∧, ⋅, ⦿, ∨, ×,
    lcontract, rcontract,
    dual,
    grade_projection,
    reverse_sign,
    magnitude,
    magnitude2

end
