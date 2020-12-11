module GeometricAlgebra

using StaticArrays
using IterTools
using Combinatorics
using Base: Bottom

import Base: *, +, -, /, ==

abstract type GeometricAlgebraType end

include("utils.jl")
include("signatures.jl")
include("blades.jl")
include("basis.jl")
include("multivectors.jl")
include("conversions.jl")
include("operators.jl")

export
    # blades
    UnitBlade, Blade,
    basis_index,
    grade, grade_index,
    unit_blades, unit_blades_from_grade,
    @basis,
    signature,
    𝟎,

    # multivectors
    Multivector,
    blades,
    is_homogeneous,

    # operators
    ∧, ⋅,
    lcontract, rcontract,
    grade_projection,

    # signatures
    Ø,
    Signature,
    dimension,
    is_degenerate,
    metric

end

