(+)(x::Blade{S,<:UnitBlade{S,G,I}}, y::Blade{S,<:UnitBlade{S,G,I}}) where {S,G,I} =
    Blade(x.coef + y.coef, x.unit_blade)
@associative (+)(x::Blade, y::Zero) = x

function (+)(x::Blade, y::Blade)
    Multivector(@SVector([x, y]))
end

@associative function (+)(x::Multivector{S,T,V}, y::Blade{S,<:UnitBlade{S,G,I},T}) where {S,G,I,T,V}
    inds = indices(x)
    blades = if I ∈ inds
        map((x, i) -> (i == I ? x + y : x), x.blades, inds)
    else
        vcat(x.blades, y)
    end

    Multivector(SVector{length(blades)}(blades))
end

(+)(x::Multivector, y::Multivector) = foldl(+, Ref(x), blades(y))
(+)(x::UnitBlade, y::UnitBlade) = Multivector(SVector{2}(1x, 1y))

(-)(x::Blade) = Blade(-x.coef, x.unit_blade)
(-)(x::Blade, y::Blade) = x + (-y)
@associative (-)(x::Blade, y::Multivector) = x + (-y)
(-)(x::Multivector) = Multivector(map(-, x.blades))

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

apply_operation(op, x, y) = grade_els(apply_operation(*, x, y), result_grade(op, grade(x), grade(y)))

@associative (*)(x, y::BladeLike) = apply_operation(*, promote(x, y)...)
@associative (*)(x::Number, y::B) where {B<:Blade} = B(x * y.coef, y.unit_blade)
@associative (*)(x::Number, y::UnitBlade) = Blade(x, y)
(*)(x::BladeLike, y::BladeLike) = apply_operation(*, x, y)

for op ∈ [:∧, :⋅, :*]
    @eval begin

        if $op ∈ [∧, ⋅] # define methods to behave like other operators
            ($op)(x, y...) = foldl(∧, vcat(x, y...))
            ($op)(x::Blade, y::Blade) = apply_operation($op, x, y)
            ($op)(x::UnitBlade, y::UnitBlade) = apply_operation($op, x, y)
            ($op)(x, y) = apply_operation($op, promote(x, y)...)
        end
        
        @associative 2 3 apply_operation(::typeof($op), x::Blade{S,<:UnitBlade{S,0,()}}, y::Blade{S}) where {S} =
            Blade(x.coef * y.coef, y.unit_blade)
        apply_operation(::typeof($op), x::Multivector, y::Multivector) = sum($op(bx, by) for bx ∈ x.blades, by ∈ y.blades)
        
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

"""
Return the grade(s) that can be present in the result of an operation.
"""
result_grade(::typeof(⋅), grade_a, grade_b) = abs(grade_a - grade_b)
result_grade(::typeof(∧), grade_a, grade_b) = grade_a + grade_b
result_grade(::typeof(lcontract), grade_a, grade_b) = grade_b - grade_a
result_grade(::typeof(rcontract), grade_a, grade_b) = grade_a - grade_b
result_grade(::typeof(*), grade_a, grade_b) = result_grade(|, grade_a, grade_b):result_grade(∧, grade_a, grade_b)
