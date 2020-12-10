(+)(x::Blade{S,<:UnitBlade{S,G,I}}, y::Blade{S,<:UnitBlade{S,G,I}}) where {S,G,I} =
    Blade(convert(promote_type(eltype(x), eltype(y)), x.coef + y.coef), x.unit_blade)
@associative (+)(x::Blade, y::Zero) = x
(+)(::Zero, ::Zero) = 𝟎

@generated function materialize(::Type{<:Blade{S}}, ::Type{T}) where {S,T}
    n = 2^dimension(S)
    SVector{n, T}(zeros(T, n))
end

function (+)(x::Blade{S,<:UnitBlade{S,G1,I1}}, y::Blade{S,<:UnitBlade{S,G2,I2}}) where {S,G1,G2,I1,I2}
    coefs = materialize(typeof(x), promote_type(eltype(x), eltype(y)))
    coefs_x = setindex(coefs, x.coef, linear_index(x))
    Multivector{S}(setindex(coefs_x, y.coef, linear_index(y)))
end

@associative function (+)(x::Multivector{S}, y::Blade{S}) where {S}
    dim = dimension(S)
    index = linear_index(y)
    coefs = setindex(x.coefs, x.coefs[index] + y.coef, index)
    Multivector{S}(coefs)
end

(+)(x::Multivector{S}, y::Multivector{S}) where {S} = Multivector{S}(x.coefs .+ y.coefs)
(+)(x::UnitBlade, y::UnitBlade) = 1x + 1y

(-)(x::Blade) = Blade(-x.coef, x.unit_blade)
(-)(x::Blade, y::Blade) = x + (-y)
@associative (-)(x::Blade, y::Multivector) = x + (-y)
(-)(x::Multivector{S}) where {S} = Multivector{S}(map(-, x.coefs))

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
Right contraction of `x` with `y`.
"""
function rcontract end

apply_operation(::typeof(*), x::UnitBlade{S,G1,I1}, y::UnitBlade{S,G2,I2}) where {S,G1,G2,I1,I2} =
    prod(apply_operation(*, typeof(x), typeof(y)))

@generated function apply_operation(::typeof(*), x::Type{UnitBlade{S,G1,I1}}, y::Type{UnitBlade{S,G2,I2}}) where {S,G1,G2,I1,I2}
    concat_inds = vcat(I1, I2)
    inds = sort(filter(x -> count(i -> i == x, concat_inds) == 1, concat_inds))
    double_inds = filter(x -> count(i -> i == x, concat_inds) == 2, unique(concat_inds))
    metric_factor = prod(map(ei -> metric(S, Val(ei)), double_inds))
    metric_factor, UnitBlade(SVector{length(inds)}(inds), S)
end

@generated function precompute_blade(::typeof(*), x::Blade, y::Blade)
    s = permsign(*, x, y)
    metric_factor, vec = apply_operation(*, unit_blade(x), unit_blade(y))
    metric_factor * s, vec
end

function apply_operation(::typeof(*), x::Blade, y::Blade)
    s, vec = precompute_blade(*, x, y)
    ρ = x.coef * y.coef
    Blade(s * ρ, vec)
end

Base.sum(blades::AbstractVector{<:Blade{S,<:Any,T}}) where {S,T} = foldl(+, blades)

@associative (*)(x, y::BladeLike) = apply_operation(*, promote(x, y)...)
@associative (*)(x::Number, y::Blade) = typeof(y)(x * y.coef, y.unit_blade)
@associative (*)(x::Number, y::UnitBlade) = Blade(x, y)
@associative (*)(x::Multivector, y::Blade) = sum(blades(x) .* y)
@associative (*)(x::Multivector{S}, y::Blade{S,<:UnitBlade{S,0,()}}) where {S} = Multivector{S, promote_type(eltype(x), eltype(y)), length(x)}(x.coefs .* y.coef)
@associative (*)(x::Multivector, y::Number) where {S} = x * scalar(y, signature(x))
(*)(x::BladeLike, y::BladeLike) = apply_operation(*, x, y)

for op ∈ [:∧, :⋅, :*]
    @eval begin

        if $op ∈ [∧, ⋅] # define methods to behave like other operators
            apply_operation(::typeof($op), x, y) = grade_els(apply_operation(*, x, y), result_grade($op, grade(x), grade(y)))

            ($op)(x, y...) = foldl(∧, vcat(x, y...))
            ($op)(x::Blade, y::Blade) = apply_operation($op, x, y)
            ($op)(x::UnitBlade, y::UnitBlade) = apply_operation($op, x, y)
            ($op)(x, y) = apply_operation($op, promote(x, y)...)
        end
        
        @associative 2 3 apply_operation(::typeof($op), x::Blade{S,<:UnitBlade{S,0,()}}, y::Blade{S}) where {S} =
            Blade(x.coef * y.coef, y.unit_blade)
        apply_operation(::typeof($op), x::Multivector, y::Multivector) = sum($op(bx, by) for bx ∈ blades(x), by ∈ blades(y))

        ($op)(x::Multivector, y::Multivector) = apply_operation($op, x, y)

    end
end

for op ∈ [+, -]
    @eval begin
        @associative 2 3 apply_operation(::typeof($op), x::Zero, y) = y
        apply_operation(::typeof($op), x::Zero, y::Zero) = 𝟎
    end
end

"""
Sign of an operation, determined from the sorting permutation of `UnitBlade` indices.
"""
permsign(::typeof(*), x::Type{<:BladeLike}, y::Type{<:BladeLike}) = permsign(*, indices(x), indices(y))
permsign(::typeof(*), i, j) =
    1 - 2 * parity(sortperm(SVector{length(i) + length(j),Int}(vcat(i, j))))

Base.reverse(b::Blade) = (-1)^(1 + grade(b)) * b
Base.reverse(mv::Multivector) = sum(reverse.(blades(mv)))

Base.inv(b::Blade{S,<:UnitBlade{S,0,()}}) where {S} = Blade(inv(b.coef), b.unit_blade)
Base.inv(b::Blade) = Blade(b.coef / (b*b).coef, b.unit_blade)
Base.inv(mv::Multivector) = sum(inv.(blades(mv)))

"""
Return the grade(s) that can be present in the result of an operation.
"""
result_grade(::typeof(⋅), grade_a, grade_b) = abs(grade_a - grade_b)
result_grade(::typeof(∧), grade_a, grade_b) = grade_a + grade_b
result_grade(::typeof(lcontract), grade_a, grade_b) = grade_b - grade_a
result_grade(::typeof(rcontract), grade_a, grade_b) = grade_a - grade_b
result_grade(::typeof(*), grade_a, grade_b) = result_grade(|, grade_a, grade_b):result_grade(∧, grade_a, grade_b)
