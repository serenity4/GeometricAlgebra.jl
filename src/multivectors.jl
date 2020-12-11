"""
Linear combination of blades, forming a general multivector.
"""
struct Multivector{S,T,N} <: GeometricAlgebraType
    coefs::SVector{N,T}
end

Multivector{S}(coefs::SVector{N,T}) where {S,N,T} = Multivector{S,T,N}(coefs)
Multivector{S}(coefs) where {S} = Multivector{S}(SVector{length(coefs),eltype(coefs)}(coefs))
Multivector{S}(coefs::T...) where {S,T<:Number} = Multivector{S}(collect(coefs))
Multivector(sig::Signature, coefs) = Multivector{sig}(SVector{length(coefs), eltype(coefs)}(coefs))
Multivector(sig::Signature, coefs::T...) where {T<:Number} = Multivector{sig}(collect(coefs))

(==)(x::Multivector{S}, y::Multivector{S}) where {S} = all(x.coefs .== y.coefs)

grade(mv::Multivector) = maximum(grade.(blades(mv)))

"""
Return the blades of grade `g` from a `Multivector`.
"""
function grade_projection(mv::Multivector, g)
    dim = dimension(mv)
    li = linear_index(dim, g)
    imin = li + 1
    imax = li + binomial(dim, g)
    coefs = SVector{length(mv)}([imin ≤ i ≤ imax ? c : 0 for (i, c) ∈ enumerate(mv.coefs)])
    Multivector(signature(mv), coefs)
end

signature(::Type{<:Multivector{S}}) where {S} = S
signature(mv::Multivector) = signature(typeof(mv))

Base.eltype(::Type{<:Multivector{S,T}}) where {S,T} = T
Base.eltype(mv::Multivector) = eltype(typeof(mv))

Base.length(::Multivector{S,T,N}) where {S,T,N} = N

Base.zeros(::Type{<:Multivector{S}}) where {S} = Multivector{S}(zeros(2^dimension(S)))

Base.convert(T::Type{Multivector{S}}, ::Zero) where {S} = zeros(T)

Base.broadcastable(mv::Multivector) = mv.coefs

indices(mv::Multivector) = indices.(blades(mv))

function blades(mv::Multivector{S,T}) where {S,T}
    res = []
    d = dimension(S)
    for (i, c) ∈ enumerate(mv.coefs)
        if c ≠ 0
            inds = indices_from_linear_index(i, d)
            b = UnitBlade(inds, S)
            push!(res, Blade(c, b))
        end
    end

    res
end

dimension(::Multivector{S}) where {S} = dimension(S)

"""
Get `Blade` element with index `(i, j)`.
"""
Base.getindex(mv::Multivector, i::Integer...) = getindex(mv.coefs, linear_index(dimension(mv), length(i), i))

"""
Whether the `mv` only contains elements of a single grade.
"""
is_homogeneous(mv::Multivector) = length(unique(grade.(blades(mv)))) == 1

function Base.show(io::IO, mv::Multivector)
    S = signature(mv)
    if mv == zeros(typeof(mv))
        print(io, string(scalar(zero(eltype(mv)), S)))
    else
        print(io, join(string.(blades(mv)), " + "))
    end
end
