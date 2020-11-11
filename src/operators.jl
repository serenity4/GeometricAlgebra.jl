"""
Contains `IsZero` and `IsNonZero` types, used to implement Holy traits
to dispatch between outer products that output 0 and those who don't.
"""
abstract type OperationResult end
abstract type IsZero <: OperationResult end
abstract type IsNonZero <: OperationResult end

"""
Trait function for determining an `OperationResult` type.
"""
is_zero(x, y) = any(i ∈ y for i ∈ x) || any(j ∈ x for j ∈ y) ? IsZero : IsNonZero
is_zero(x::BasisElement{G1,I1}, y::BasisElement{G2,I2}) where {G1,G2,I1,I2} = is_zero(I1, I2)
is_zero(x::Element{<:BasisElement{G1,I1}}, y::Element{<:BasisElement{G2,I2}}) where {G1,G2,I1,I2} = is_zero(I1, I2)
is_zero(x, y::ZeroElement) = IsZero
is_zero(x::ZeroElement, y) = IsZero

Base.:*(a::Number, b::BasisElement) = Element(a, b)
Base.:*(a::BasisElement, b::Number) = b * a
Base.:*(a::Number, b::Element) = Element(a * b.coef, b.basis)
Base.:*(a::Element, b::Number) = b * a

Base.:+(a::Element{<:BasisElement{G,I,D}}, b::Element{<:BasisElement{G,I,D}}) where {G,I,D} =
    Element(a.coef + b.coef, a.basis)
Base.:+(a::Element, b::ZeroElement) = a
Base.:+(a::ZeroElement, b::Element) = b

function Base.:+(a::Element{<:BasisElement{G,I1,D},T}, b::Element{<:BasisElement{G,I2,D},T}) where {G,I1,I2,D,T}
    grades = SVector{1,Int}(G)
    coefs = @MVector(zeros(T, binomial(D, G)))
    coefs[grade_index(a)] = a.coef
    coefs[grade_index(b)] = b.coef
    return Multivector{D}(grades, tuple(SVector(coefs)))
end

function Base.:+(a::Element{<:BasisElement{G1,I1,D},T}, b::Element{<:BasisElement{G2,I2,D},T}) where {G1,G2,I1,I2,D,T}
    grades = SVector{2,Int}(G1, G2)
    coefs_1, coefs_2 = (@MVector(zeros(T, binomial(D, G1))), @MVector(zeros(T, binomial(D, G2))))
    coefs_1[grade_index(a)] = a.coef
    coefs_2[grade_index(b)] = b.coef
    return Multivector{D}(grades, (SVector(coefs_1), SVector(coefs_2)))
end

"""
    `a ∧ b`
Outer product between `a` and `b`.
"""
function ∧ end

"""
Outer product backend. Returns 𝟎 if `is_zero(x, y)`.
"""
outer_product(x, y, result::Type{IsZero}) = 𝟎
outer_product(x, y, result::Type{IsNonZero}) = outer_product(x, y)

outer_product(a::BasisElement{G1,I1,D}, b::BasisElement{G2,I2,D}) where {G1,G2,I1,I2,D} = BasisElement{G1+G2,SVector{G1+G2,Int}(sort(vcat(I1,I2))),D}()

function outer_product(a::Element{<:BasisElement{G1,I1},D}, b::Element{<:BasisElement{G2,I2},D}) where {G1,G2,I1,I2,D}
    vec = outer_product(a.basis, b.basis)
    ρ = a.coef * b.coef
    s = sign(∧, a.basis, b.basis)
    Element(s * ρ, vec)
end

∧(x, y) = outer_product(x, y, is_zero(x, y))
∧(x, y...) = foldl(∧, vcat(x, y...))

function ∧(a::Multivector{D}, b::Multivector{D}) where {D}
    sum(map(∧, vectors(a), vectors(b)))
end

function Base.sign(::typeof(∧), a::BasisElement{G1}, b::BasisElement{G2}) where {G1,G2}
    1 - 2 * parity(sortperm(SVector{G1 + G2, Int}(indices(a)..., indices(b)...)))
end
