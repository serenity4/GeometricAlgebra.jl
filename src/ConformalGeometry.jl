module ConformalGeometry

using StaticArrays
using IterTools
using Combinatorics

struct ZeroElement end

const 𝟎 = ZeroElement()

Base.show(io::IO, ::ZeroElement) = print(io, '𝟎')

include("basis_elements.jl")
include("multivectors.jl")
include("operators.jl")

export
    # GA element types
    ZeroElement,
    BasisElement,
    ZeroElement,
    Element,
    Multivector,
    basis_index,
    grade,
    grade_index,
    𝟎,

    # GA operators
    ∧,
    grade_els

end

