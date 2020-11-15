module GeometricAlgebra

using StaticArrays
using IterTools
using Combinatorics

include("signatures.jl")
include("multivectors.jl")
include("operators.jl")

export
    # blades
    UnitBlade, Blade,
    basis_index,
    grade, grade_index,
    unit_blades, unit_blades_from_grade,
    @basis,
    signature,

    # multivectors
    Multivector,
    blades,
    is_homogeneous,

    # operators
    ∧, ⋅,
    lcontract, rcontract,
    grade_els,
    Zero,
    𝟎,

    # signatures
    Ø,
    Signature,
    dimension,
    is_degenerate,
    metric

end

