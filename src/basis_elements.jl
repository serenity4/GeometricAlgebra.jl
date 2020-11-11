struct BasisElement{G,I,D} end

indices(b::BasisElement{G,I}) where {G,I} = I

struct Element{B <: BasisElement,T}
    coef::T
    basis::B
end
Element(_, b::ZeroElement) = b

grade(b::BasisElement{G}) where {G} = G
grade(b::Element) = grade(b.basis)

bases_from_grade(dim, g) =
    (BasisElement{length(s), SVector{length(s)}(s), dim}() for s ∈ subsets(1:dim, g))
bases(dim::Integer) = bases_from_grade.(dim, 0:dim)

"""
Return `val` as a subscript, used for printing basis vectors.
"""
function subscript(val)
    r = div(val, 10)
    subscript_char(x) = Char(8320 + x)
    r > 0 ? string(subscript_char(r), subscript_char(mod(val, 10))) : string(subscript_char(val))
end

Base.show(io::IO, el::Element{<: BasisElement{G,I}}) where {G,I} = print(io, "$(el.coef)v$(join(map(subscript, I)))")
