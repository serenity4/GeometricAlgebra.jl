struct Zero end

const 𝟎 = Zero()

Base.show(io::IO, ::Zero) = print(io, '𝟎')

"""
Contains `IsZero` and `IsNonZero` types, used to implement Holy traits
to dispatch between outer products whose result are 𝟎 and those who don't.
"""
abstract type OperationResult end

abstract type IsZero <: OperationResult end
abstract type IsNonZero <: OperationResult end

"""
Trait function for determining an `OperationResult` type.
"""
is_zero(x, y) = any(i ∈ y for i ∈ x) || any(j ∈ x for j ∈ y) ? IsZero : IsNonZero
is_zero(x::UnitBlade{G1,I1}, y::UnitBlade{G2,I2}) where {G1,G2,I1,I2} = is_zero(I1, I2)
is_zero(x::Blade{<:UnitBlade{G1,I1}}, y::Blade{<:UnitBlade{G2,I2}}) where {G1,G2,I1,I2} = is_zero(I1, I2)
is_zero(x, y::Zero) = IsZero
is_zero(x::Zero, y) = IsZero

Base.:*(x::Number, y::UnitBlade) = Blade(x, y)
Base.:*(x::UnitBlade, y::Number) = y * x
Base.:*(x::Number, y::Blade) = Blade(x * y.coef, y.unit_blade)
Base.:*(x::Blade, y::Number) = y * x

Base.:+(x::Blade{<:UnitBlade{G,I}}, y::Blade{<:UnitBlade{G,I}}) where {G,I} =
    Blade(x.coef + y.coef, x.unit_blade)
Base.:+(x::Blade, y::Zero) = x
Base.:+(x::Zero, y::Blade) = y

function Base.:+(x::Blade, y::Blade)
    Multivector(@SVector([x, y]))
end

Base.:+(x::Multivector{T}, y::Blade{<:UnitBlade,T}) where {T} = Multivector(x, y)
Base.:+(x::Blade{<:UnitBlade,T}, y::Multivector{T}) where {T} = y + x
Base.:+(x::UnitBlade, y::UnitBlade) = Multivector(SVector{2}(1x, 1y))

"""
    `x ∧ y`
Outer product of `x` with `y`.
"""
function ∧ end

"""
    `x ⋅ y`
Inner product of `x` with `y`.
"""
function ⋅ end

"""
    `lcontract(x, y)`
Left contraction of `x` with `y`.
"""
function lcontract end

"""
    `rcontract(x, y)`
Left contraction of `x` with `y`.
"""
function rcontract end

"""
Outer product backend. Returns 𝟎 if `is_zero(x, y)`.
"""
outer_product(x, y, result::Type{IsZero}) = 𝟎
outer_product(x, y, result::Type{IsNonZero}) = outer_product(x, y)
outer_product(::UnitBlade{G1,I1}, ::UnitBlade{G2,I2}) where {G1,G2,I1,I2} =
    UnitBlade{G1+G2,SVector{G1+G2,Int}(sort(vcat(I1,I2)))}()

function outer_product(x::Blade, y::Blade)
    vec = outer_product(x.unit_blade, y.unit_blade)
    ρ = x.coef * y.coef
    s = sign(∧, x.unit_blade, y.unit_blade)
    Blade(s * ρ, vec)
end

∧(x, y) = outer_product(x, y, is_zero(x, y))
∧(x, y...) = foldl(∧, vcat(x, y...))
∧(x::Multivector, y::Multivector) = sum(map(∧, blades(x), blades(y)))

"""
Sign of an outer product, determined from the permutation of `UnitBlade` indices.
"""
Base.sign(op, x::UnitBlade, y::UnitBlade) = sign(op, indices(x), indices(y))

Base.sign(::typeof(∧), i::AbstractVector{<:Integer}, j::AbstractVector{<:Integer}) =
    1 - 2 * parity(sortperm(SVector{length(i) + length(j),Int}(vcat(i, j))))
Base.sign(::typeof(⋅), i::AbstractVector{<:Integer}, j::AbstractVector{<:Integer}) = sign(∧, i, j)
Base.sign(::typeof(*), i::AbstractVector{<:Integer}, j::AbstractVector{<:Integer}) = sign(∧, i, j)


"""
Return the grade(s) that can be present in the result of an operation.
"""
result_grade(::typeof(|), grade_a, grade_b) = abs(grade_a - grade_b)
result_grade(::typeof(∧), grade_a, grade_b) = grade_a + grade_b
result_grade(::typeof(lcontract), grade_a, grade_b) = grade_b - grade_a
result_grade(::typeof(rcontract), grade_a, grade_b) = grade_a - grade_b
result_grade(::typeof(*), grade_a, grade_b) = result_grade(|, grade_a, grade_b):result_grade(∧, grade_a, grade_b)
result_grade(::typeof(⋅), grade_a, grade_b) = result_grade(|, grade_a, grade_b):result_grade(∧, grade_a, grade_b)
