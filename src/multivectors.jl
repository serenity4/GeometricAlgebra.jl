"""
Linear combination of blades, forming a general multivector.
"""
struct Multivector{S,T,N}
    coefs::SVector{N,T}
    Multivector{S}(coefs::SVector{N,T}) where {S,N,T} = new{S,T,N}(coefs)
end

Multivector{S}(coefs) where {S} = Multivector{S}(SVector{length(coefs),eltype(coefs)}(coefs))
Multivector{S}(coefs::T...) where {S,T<:Number} = Multivector{S}(collect(coefs))

grade(mv::Multivector) = maximum(grade.(blades(mv)))

"""
Return the blades of grade `g` from a `Multivector`.
"""
grade_els(mv::Multivector, g) = filter(x -> grade(x) == g, blades(mv))

signature(::Multivector{S}) where {S} = S

Base.eltype(::Multivector{S,T}) where {S,T} = T

Base.length(::Multivector{S,T,N}) where {S,T,N} = N

indices(mv::Multivector) = indices.(blades(mv))

function blades(mv::Multivector{S,T}) where {S,T}
    res = []
    d = dimension(S)
    for (i, c) ∈ enumerate(mv.coefs)
        if c ≠ 0
            inds = indices_from_linear_index(i, d)
            b = UnitBlade{S,length(inds), inds}()
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

Base.show(io::IO, mv::Multivector) = print(io, join(string.(blades(mv)), " + "))
