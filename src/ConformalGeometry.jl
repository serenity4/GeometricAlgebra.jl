module ConformalGeometry

using StaticArrays
using IterTools
using Combinatorics

include("blades.jl")
include("multivectors.jl")
include("operators.jl")

export
    # blades
    UnitBlade,
    Blade,
    basis_index,
    grade,
    grade_index,
    blades,
    blades_from_grade,

    # multivectors
    Multivector,
    vectors,
    is_homogeneous,

    # operators
    ∧,
    grade_els
    Zero,
    𝟎,

end

