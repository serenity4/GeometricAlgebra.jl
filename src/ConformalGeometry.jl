module ConformalGeometry

using StaticArrays

abstract type GAEntity{D} end

struct ZeroElement end
Base.zero(::Type{<:GAEntity}) = ZeroElement()
Base.show(io::IO, ::ZeroElement) = print(io, '0')

include("basis_elements.jl")
include("multivectors.jl")
include("operators.jl")

export
    # GA entities
    GAEntity,
    
    # GA element types
    ZeroElement,
    BasisElement,
    ZeroElement,
    Element,
    Multivector,
    basis_index,
    grade,
    grade_index,

    # GA operators
    ∧,
    grade_els

end

