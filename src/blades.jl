abstract type BladeLike{S} end

"""
    UnitBlade{G,I}

Unit blade with grade `G` and indices `I`, following a [`GeomAlgebra`](@ref) `S`.
"""
struct UnitBlade{S,G,I} <: BladeLike{S} end
UnitBlade(inds, sig::Signature = Ø) = UnitBlade{sig, length(inds), inds}()

signature(::UnitBlade{S}) where {S} = S
unit_scalar(sig) = UnitBlade(SVector{0,Int}(), sig)

"""
    Blade{B,T}

Blade living in the subspace spanned by `B`, with a coefficient of type `T`.
Can be interpreted as a scaled version of a [`UnitBlade`](@ref).
"""
struct Blade{S,B<:UnitBlade{S},T} <: BladeLike{S}
    coef::T
    unit_blade::B
end

const 𝟎 = Blade(0, UnitBlade{nothing, nothing, nothing}())
const Zero = typeof(𝟎)

scalar(coef, sig) = Blade(coef, unit_scalar(sig))
grade(b::UnitBlade{S,G}) where {S,G} = G
grade(b::Blade) = grade(b.unit_blade)

unit_blade(::Type{<:Blade{S,B}}) where {S,B} = B

indices(b::UnitBlade{S,G,I}) where {S,G,I} = I
indices(b::Blade) = indices(b.unit_blade)
indices(b::Type{<:Blade{S,<:UnitBlade{S,G,I}}}) where {S,G,I} = I
indices(b::Type{<:UnitBlade{S,G,I}}) where {S,G,I} = I

grade_index(i::Integer...; dim) = grade_index(dim, collect(i))
grade_index(dim, b::UnitBlade{S,G,I}) where {S,G,I} = grade_index(dim, I)
grade_index(dim, b::Blade) = grade_index(dim, b.unit_blade)

metric(::Signature{P,N,D}, ::Val{I}) where {P,N,D,I} = I <= P ? 1 : I <= P + N ? -1 : 0
metric(sig::Signature{P,N,D}, i::Val{I}, j::Val{I}) where {P,N,D,I} = metric(sig, i)
metric(::Signature, ::Val{I}, ::Val{J}) where {I,J} = 0
metric(::Type{<:UnitBlade{S,1,I}}, ::Type{UnitBlade{S,1,J}}) where {S,I,J} = metric(S, Val(I[1]), Val(J[1]))

grade_els(b::Blade{S,<:UnitBlade{S,G}}, g) where {S,G} = g == G ? b : 𝟎

"""
    `grade_index(dim, i)`
Return the grade index of `i`.

## Example
```julia
julia> grade_index(3, [1])
1

julia> grade_index(3, [1, 2])
1

julia> grade_index(3, [3, 1])
3
```
"""
function grade_index(dim, i::AbstractVector)
    grade = length(i)
    if grade == 0
        1
    elseif grade == 1
        first(i)
    elseif first(i) == 1
        grade_index(dim - 1, i[2:end] .- 1)
    else
        grade_index(dim - 1, i .- 1) + (dim - 1)
    end
end

unit_blades_from_grade(dim, grade, sig::Signature) =
    (UnitBlade(SVector{length(s)}(s), sig::Signature) for s ∈ subsets(1:dim, grade))

unit_blades(dim::Integer, sig::Signature) = unit_blades_from_grade.(dim, 0:dim, sig::Signature)

"""
Return `val` as a subscript, used for printing `UnitBlade` and `Blade` instances.
"""
function subscript(val)
    r = div(val, 10)
    subscript_char(x) = Char(8320 + x)
    r > 0 ? string(subscript_char(r), subscript_char(mod(val, 10))) : string(subscript_char(val))
end

Base.show(io::IO, b::UnitBlade{S,G,I}) where {S,G,I} = print(io, "v$(join(map(subscript, I)))")
Base.show(io::IO, b::Blade{S,<:UnitBlade{S,G,I}}) where {S,G,I} = print(io, "$(b.coef)", string(b.unit_blade))
Base.show(io::IO, ::Zero) = print(io, '𝟎')
