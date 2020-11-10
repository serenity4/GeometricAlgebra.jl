struct Multivector{D,T,G,V <: NTuple{G,<:AbstractVector{T}}} <: GAEntity{D}
    grades::SVector{G,Int}
    coefs::V
    Multivector{D}(grades::SVector{G,Int}, coefs::V) where {D,G,T,V <: NTuple{G,<:AbstractVector{T}}} = new{D,T,G,V}(grades, coefs)
end
Multivector{D}(grades::AbstractVector, coefs::AbstractVector{T}...) where {D,T} = Multivector{D}(SVector{length(grades),Int}(grades), tuple((SVector{length(_coefs),T}(_coefs) for _coefs ∈ coefs)...))

function Base.:+(a::Element{<:BasisElement{G,I1,D},T}, b::Element{<:BasisElement{G,I2,D},T}) where {G,I1,I2,D,T}
    grades = SVector{1,Int}(G)

    coefs = @MVector(zeros(T, binomial(D, G)))
    coefs[I1] = a.coef
    coefs[I2] = b.coef
    return Multivector{D}(grades, tuple(SVector(coefs)))
end
function Base.:+(a::Element{<:BasisElement{G1,I1,D},T}, b::Element{<:BasisElement{G2,I2,D},T}) where {G1,G2,I1,I2,D,T}
    grades = SVector{2,Int}(G1, G2)
    coefs_1, coefs_2 = (@MVector(zeros(T, binomial(D, G1))), @MVector(zeros(T, binomial(D, G2))))
    coefs_1[I1] = a.coef
    coefs_2[I2] = b.coef
    return Multivector{D}(grades, (SVector(coefs_1), SVector(coefs_2)))
end

"""
Return the elements of grade `grade` of a `Multivector`.
"""
grade_els(mv::Multivector, grade) = mv.coefs[grade + 1]

function vectors(a::Multivector{D}) where {D}
    Element.(a.coefs, bases(D))
end

function ∧(a::Multivector{D}, b::Multivector{D}) where {D}
    sum(map(∧, vectors(a), vectors(b)))
end

