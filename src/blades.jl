abstract type BladeLike{S} <: GeometricAlgebraType end

Base.broadcastable(x::BladeLike) = Ref(x)

"""
    UnitBlade{S,G,I}

Unit blade with grade `G`, indices `I`, and [`Signature`](@ref) `S`.
"""
struct UnitBlade{S,G,I} <: BladeLike{S} end

UnitBlade(inds::SVector{N}, sig::Signature = Ø) where {N} = UnitBlade{sig, N, inds}()
UnitBlade(inds::AbstractVector, sig::Signature = Ø) = UnitBlade(SVector{length(inds)}(inds), sig)

Base.show(io::IO, b::UnitBlade{S,G,I}) where {S,G,I} = print(io, "v$(join(map(subscript, I)))")

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

(≈)(x::Blade, y::Blade; kwargs...) = unit_blade(x) == unit_blade(y) && ≈(x.coef, y.coef; kwargs...)

Base.show(io::IO, b::Blade{S,<:UnitBlade{S,G,I}}) where {S,G,I} = print(io, string(b.coef), string(b.unit_blade))

unit_blade(b::Blade) = b.unit_blade
unit_blade(::Type{<:Blade{S,B}}) where {S,B} = B

const ScalarUnitBlade{S} = UnitBlade{S,0,SVector{0,Int}()}
const ScalarBlade{S,T} = Blade{S,ScalarUnitBlade{S},T}

unit_scalar(sig::Signature) = ScalarUnitBlade{sig}()

scalar(coef, sig::Signature) = Blade(coef, unit_scalar(sig))

grade(b::UnitBlade{S,G}) where {S,G} = G
grade(b::Blade) = grade(b.unit_blade)

Base.eltype(b::Blade) = eltype(typeof(b))
Base.eltype(::Type{<:Blade{S,B,T}}) where {S,B,T} = T

signature(::BladeLike{S}) where {S} = S
signature(::Type{<:BladeLike{S}}) where {S} = S

indices(b::UnitBlade) = indices(typeof(b))
indices(b::Blade) = indices(typeof(b))
indices(::Type{<:UnitBlade{S,G,I}}) where {S,G,I} = I
indices(::Type{<:Blade{S,B}}) where {S,B} = indices(B)

grade_index(i::Integer...; dim) = grade_index(dim, collect(i))
grade_index(dim, b::UnitBlade{S,G,I}) where {S,G,I} = grade_index(dim, I)
grade_index(dim, b::Blade) = grade_index(dim, b.unit_blade)

metric(::Signature{P,N,D}, ::Val{I}) where {P,N,D,I} = I <= P ? 1 : I <= P + N ? -1 : 0
metric(sig::Signature{P,N,D}, i::Val{I}, j::Val{I}) where {P,N,D,I} = metric(sig, i)
metric(::Signature, ::Val{I}, ::Val{J}) where {I,J} = 0
metric(::Type{<:UnitBlade{S,1,I}}, ::Type{<:UnitBlade{S,1,J}}) where {S,I,J} = metric(S, Val.(first.((I, J)))...)

grade_projection(b::Blade{S,<:UnitBlade{S,G}}, g) where {S,G} = g == G ? b : 𝟎

linear_index(::UnitBlade{S,G,I}) where {S,G,I} = linear_index(dimension(S), G, I)
linear_index(b::Blade) = linear_index(b.unit_blade)
linear_index(dim, grade) = sum(binomial.(dim, 0:(grade-1)))

function linear_index(dim, grade, indices)
    linear_index(dim, grade) + grade_index(dim, indices)
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
    grade == 0 && return SVector{0,Int}()
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

struct Zero <: GeometricAlgebraType end

grade(::Zero) = 0
grade_projection(::Zero, _) = 𝟎

(≈)(::Zero, ::Zero; kwargs...) = true
(≈)(::Zero, x; kwargs...) = ≈(x, zero(typeof(x)); kwargs...)
(≈)(x, ::Zero; kwargs...) = ≈(x, zero(typeof(x)); kwargs...)
(==)(::Zero, ::Zero) = true

const 𝟎 = Zero()

Base.show(io::IO, ::Zero) = print(io, '𝟎')
