abstract type BladeLike{S} end

Base.broadcastable(x::BladeLike) = Ref(x)

"""
    UnitBlade{S,G,I}

Unit blade with grade `G`, indices `I`, and [`Signature`](@ref) `S`.
"""
struct UnitBlade{S,G,I} <: BladeLike{S} end
UnitBlade(inds::SVector{N,T}, sig::Signature = Ø) where {N,T} = UnitBlade{sig, N, inds}()
UnitBlade(inds::AbstractVector, sig::Signature = Ø) = UnitBlade(SVector{length(inds)}(inds), sig)

signature(::UnitBlade{S}) where {S} = S
unit_scalar(sig) = UnitBlade(SVector{0,Int}(), sig)

"""
    Blade{S,B,T}

Blade living in the subspace spanned by `B` with signature `S` and a coefficient of type `T`.
Can be interpreted as a scaled version of a [`UnitBlade`](@ref).
"""
struct Blade{S,B<:UnitBlade{S},T} <: BladeLike{S}
    coef::T
    unit_blade::B
end

Blade(inds, sig::Signature, coef) = Blade(coef, UnitBlade(inds, sig))

struct Zero end
const 𝟎 = Zero()

scalar(coef, sig) = Blade(coef, unit_scalar(sig))

grade(b::UnitBlade{S,G}) where {S,G} = G
grade(b::Blade) = grade(b.unit_blade)

Base.eltype(::Blade{S,B,T}) where {S,B,T} = T

signature(::Blade{S}) where {S} = S

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
metric(::Type{<:UnitBlade{S,1,I}}, ::Type{<:UnitBlade{S,1,J}}) where {S,I,J} = metric(S, Val.(first.((I, J)))...)

grade_els(b::Blade{S,<:UnitBlade{S,G}}, g) where {S,G} = g == G ? b : 𝟎

linear_index(::UnitBlade{S,G,I}) where {S,G,I} = linear_index(dimension(S), G, I)
linear_index(b::Blade) = linear_index(b.unit_blade)

function linear_index(dim, grade, indices)
    grade_index(dim, indices) + sum(binomial.(dim, 0:(grade-1)))
end

function grade_from_linear_index(index, dim)
    grade_end = 1
    for g ∈ 0:dim
        if grade_end >= index
            return (g, grade_end)
        else
            grade_end += binomial(dim, g+1)
        end
    end
    if grade_end >= index
        (dim, grade_end)
    else
        error("Could not fetch linear index from $index with dimension $dim")
    end
end

function indices_from_linear_index(index, dim)
    grade, grade_end = grade_from_linear_index(index, dim)
    grade_start = grade_end - binomial(dim, grade)
    grade == 0 && return ()
    cs = collect(combinations(1:dim, grade))
    SVector{grade}(cs[index - grade_start])
end

"""
    grade_index(dim, i)
Return the grade index of `i`.

## Example
```julia
julia> grade_index(3, [1])
1

julia> grade_index(3, [3, 1])
3
```
"""
function grade_index(dim, i)
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
    (UnitBlade(SVector{length(s)}(s), sig::Signature) for s ∈ combinations(1:dim, grade))

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
