module ConformalGeometry

using StaticArrays
using IterTools
using Combinatorics

struct Zero end

const 𝟎 = Zero()

Base.show(io::IO, ::Zero) = print(io, '𝟎')

include("blades.jl")
include("multivectors.jl")
include("operators.jl")

export
    # zero
    Zero,
    𝟎,

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

end

