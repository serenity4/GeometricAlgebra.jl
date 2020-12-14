(+)(x::Blade{S,B}, y::Blade{S,B}) where {S,B} = Blade(x.coef + y.coef, B())
@type_commutative (+)(x::GeometricAlgebraType, ::Zero) = x
(+)(::Zero, ::Zero) = 𝟎

@generated function StaticArrays.SVector(::Type{<:Blade{S}}, ::Type{T}) where {S,T}
    n = 2^dimension(S)
    SVector{n, T}(zeros(T, n))
end

function (+)(x::Blade{S,B1}, y::Blade{S,B2}) where {S,B1,B2}
    coefs = SVector(typeof(x), promote_type(eltype(x), eltype(y)))
    coefs_x = setindex(coefs, x.coef, linear_index(x))
    Multivector{S}(setindex(coefs_x, y.coef, linear_index(y)))
end

@type_commutative function (+)(x::Multivector{S}, y::Blade{S}) where {S}
    dim = dimension(S)
    index = linear_index(y)
    coefs = setindex(x.coefs, x.coefs[index] + y.coef, index)
    Multivector{S}(coefs)
end

(+)(x::T, y::T) where {T<:Multivector{S} where {S}} = T(x.coefs .+ y.coefs)
(+)(x::UnitBlade{S}, y::UnitBlade{S}) where {S} = 1x + 1y
(+)(x::GeometricAlgebraType, y::GeometricAlgebraType) = +(promote(x, y)...)
@type_commutative (+)(x::GeometricAlgebraType, y::Number) = +(promote(x, y)...)
@type_commutative (+)(x::Zero, y::Number) = +(promote(x, y)...)

Base.sum(x::AbstractVector{<:GeometricAlgebraType}) = reduce(+, x)

(-)(::Zero) = 𝟎
(-)(x::UnitBlade) = Blade(-1.0, x)
(-)(x::Blade) = Blade(-x.coef, x.unit_blade)
(-)(x::Multivector{S}) where {S} = Multivector{S}(map(-, x.coefs))
(-)(x::GeometricAlgebraType, y::GeometricAlgebraType) = x + (-y)
@type_commutative (-)(x::GeometricAlgebraType, y::Number) = (-)(promote(x, y)...)

"""
    x ∧ y
Outer product of `x` with `y`.
"""
function ∧ end

"""
    x ⋅ y
Inner product of `x` with `y`.
"""
function ⋅ end

"""
    lcontract(x, y)
Left contraction of `x` with `y`.
"""
function lcontract end

"""
    rcontract(x, y)
Right contraction of `x` with `y`. If `x` and `y` are 
"""
function rcontract end

@generated function precompute_unit_blade(x::Type{B1}, y::Type{B2}) where {B1<:UnitBlade{S},B2<:UnitBlade{S}} where {S}
    concat_inds = vcat(indices(B1), indices(B2))
    inds = sort(filter(x -> count(i -> i == x, concat_inds) == 1, concat_inds))
    double_inds = filter(x -> count(i -> i == x, concat_inds) == 2, unique(concat_inds))
    metric_factor = prod(map(ei -> metric(S, Val(ei)), double_inds))
    metric_factor, UnitBlade(inds, S)
end

@generated function precompute_blade(x::Blade, y::Blade)
    s = permsign(x, y)
    metric_factor, vec = precompute_unit_blade(unit_blade(x), unit_blade(y))
    metric_factor * s, vec
end

function (*)(x::Blade, y::Blade)
    λ, vec = precompute_blade(x, y)
    ρ = x.coef * y.coef
    Blade(λ * ρ, vec)
end

(*)(x::UnitBlade{S}, y::UnitBlade{S}) where {S} = prod(precompute_unit_blade(typeof(x), typeof(y)))
@type_commutative (*)(x::ScalarBlade{S}, y::Blade{S}) where {S} = Blade(x.coef * y.coef, unit_blade(y))
(*)(x::ScalarBlade{S}, y::ScalarBlade{S}) where {S} = scalar(x.coef * y.coef, S)
@type_commutative (*)(x::Multivector{S}, y::Blade{S}) where {S} = sum(blades(x) .* y)
@type_commutative (*)(x::Multivector{S}, y::ScalarBlade{S}) where {S} = Multivector{S}(x.coefs .* y.coef)
(*)(x::GeometricAlgebraType, y::GeometricAlgebraType) = *(mul_promote(x, y)...)
@type_commutative (*)(x::Number, y::GeometricAlgebraType) = *(mul_promote(x, y)...)
(*)(x::Multivector{S}, y::Multivector{S}) where {S} = sum(bx * by for bx ∈ blades(x), by ∈ blades(y))

@type_commutative (⋅)(x::ScalarBlade, y) = 𝟎
@type_commutative (⋅)(x::ScalarUnitBlade, y) = 𝟎

for op ∈ [:∧, :⋅]
    @eval begin
        ($op)(x, y) = grade_projection(x * y, result_grade($op, grade(x), grade(y)))
        ($op)(x, y, z...) = reduce($op, vcat(x, y, z...))
    end
end

"""
Sign of an operation, determined from the sorting permutation of `UnitBlade` indices.
"""
permsign(x::Type{<:BladeLike}, y::Type{<:BladeLike}) = permsign(indices(x), indices(y))
permsign(i, j) =
    1 - 2 * parity(sortperm(SVector{length(i) + length(j),Int}(vcat(i, j))))

function Base.reverse(b::Blade)
    g = grade(b)
    (-1)^(g * (g-1) ÷ 2) * b
end

Base.reverse(mv::Multivector) = sum(reverse.(blades(mv)))

Base.inv(b::ScalarBlade) = inv(b.coef) * b.unit_blade
Base.inv(b::Blade) = (b.coef / (reverse(b) * b).coef) * b.unit_blade
Base.inv(mv::Multivector) = sum(inv.(blades(mv)))

"""
Return the grade(s) that can be present in the result of an operation.
"""
result_grade(::typeof(⋅), grade_a, grade_b) = abs(grade_a - grade_b)
result_grade(::typeof(∧), grade_a, grade_b) = grade_a + grade_b
result_grade(::typeof(lcontract), grade_a, grade_b) = grade_b - grade_a
result_grade(::typeof(rcontract), grade_a, grade_b) = grade_a - grade_b
result_grade(::typeof(*), grade_a, grade_b) = result_grade(⋅, grade_a, grade_b):2:result_grade(∧, grade_a, grade_b)
