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
function is_zero end

is_zero(op, x, y) = IsNonZero

(+)(x::Blade{S,<:UnitBlade{S,G,I}}, y::Blade{S,<:UnitBlade{S,G,I}}) where {S,G,I} =
    Blade(x.coef + y.coef, x.unit_blade)
@associative (+)(x::Blade, y::Zero) = x

function (+)(x::Blade, y::Blade)
    Multivector(@SVector([x, y]))
end

@associative (+)(x::Multivector{S,T}, y::Blade{S,B,T}) where {S,B,T} = Multivector(x, y)
(+)(x::UnitBlade, y::UnitBlade) = Multivector(SVector{2}(1x, 1y))

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
Right contraction of `x` with `y`.
"""
function rcontract end

apply_operation(::typeof(∧), ::UnitBlade{S,G1,I1}, ::UnitBlade{S,G2,I2}) where {S,G1,G2,I1,I2} =
    UnitBlade{S,G1+G2,SVector{G1+G2,Int}(sort(vcat(I1,I2)))}()

function apply_operation(::typeof(∧), x::Blade, y::Blade)
    vec = apply_operation(∧, x.unit_blade, y.unit_blade)
    ρ = x.coef * y.coef
    s = sign(∧, x.unit_blade, y.unit_blade)
    Blade(s * ρ, vec)
end

apply_operation(op, x, y, ::Type{IsZero}) = 𝟎
apply_operation(op, x, y, ::Type{IsNonZero}) = apply_operation(op, x, y)

Base.convert(::Type{<:Blade{S,B,T}}, b::B) where {S,B,T} = Blade(one(T), b)
Base.convert(::Type{Multivector}, b::Blade) = Multivector(b)
Base.convert(::Type{<:Blade{S}}, n::Number) where {S} = scalar(n, S)
Base.convert(::Type{<:Blade{S}}, n::UnitBlade) where {S} = Blade(1, n)

Base.promote_rule(::Type{B}, T::Type{Blade{S,B}}) where {S,B} = T
Base.promote_rule(::Blade{S}, ::Blade{S}) where {S} = Multivector
Base.promote_rule(::Blade{S,B,T}, type::Blade{S,B,T}) where {S,B,T} = type
Base.promote_rule(::Type{<:Number}, ::Type{<:BladeLike{S}}) where {S} = Blade{S}

(*)(x::BladeLike, y::BladeLike) = apply_operation(*, x, y, is_zero(*, x, y))
@associative (*)(x::Number, y::BladeLike) = apply_operation(∧, x, y)

for op ∈ [:∧, :⋅, :*]
    @eval begin

        if $op ∈ [∧, ⋅] # define methods to behave like other operators
            ($op)(x, y...) = foldl(∧, vcat(x, y...))
            ($op)(x, y) = apply_operation($op, x, y, is_zero($op, x, y))
        end
        
        @associative 2 3 apply_operation(::typeof($op), x::Blade{S,<:UnitBlade{S,0,()}}, y::Blade{S}) where {S} =
            Blade(x.coef * y.coef, y.unit_blade)
        apply_operation(::typeof($op), x, y) = apply_operation($op, promote(x, y)...)
        apply_operation(::typeof($op), x::Multivector, y::Multivector) = sum(map($op, x.blades, y.blades))
        
        @associative 2 3 is_zero(::typeof($op), x, y::Zero) = IsZero
        is_zero(::typeof($op), x::Zero, y::Zero) = IsZero
        is_zero(::typeof($op), x::UnitBlade{S,G1,I1}, y::UnitBlade{S,G2,I2}) where {S,G1,G2,I1,I2} =
            is_zero($op, I1, I2)
        is_zero(::typeof($op), x::Blade{S,<:UnitBlade{S,G1,I1}}, y::Blade{S,<:UnitBlade{S,G2,I2}}) where {S,G1,G2,I1,I2} =
            is_zero($op, I1, I2)

        # skip call to is_zero since it will be handled
        # individually for each blade of the multivector
        ($op)(x::Multivector, y::Multivector) = apply_operation($op, x, y)

    end
end

for op ∈ [+, -]
    @eval begin
        @associative 2 3 is_zero(::typeof($op), x, y::Zero) = IsNonZero
        @associative 2 3 apply_operation(::typeof($op), x::Zero, y) = y
        apply_operation(::typeof($op), x::Zero, y::Zero) = 𝟎
    end
end

is_zero(::typeof(∧), x, y) = any(i ∈ y for i ∈ x) || any(j ∈ x for j ∈ y) ? IsZero : IsNonZero
is_zero(::typeof(⋅), x, y) = all(i ∉ y for i ∈ x) && all(j ∉ x for j ∈ y) ? IsZero : IsNonZero

"""
Sign of an operation, determined from the sorting permutation of `UnitBlade` indices.
"""
Base.sign(::typeof(∧), x::BladeLike, y::BladeLike) = sign(∧, indices(x), indices(y))
Base.sign(::typeof(∧), i, j) =
    1 - 2 * parity(sortperm(SVector{length(i) + length(j),Int}(vcat(i, j))))

"""
Return the grade(s) that can be present in the result of an operation.
"""
result_grade(::typeof(⋅), grade_a, grade_b) = abs(grade_a - grade_b)
result_grade(::typeof(∧), grade_a, grade_b) = grade_a + grade_b
result_grade(::typeof(lcontract), grade_a, grade_b) = grade_b - grade_a
result_grade(::typeof(rcontract), grade_a, grade_b) = grade_a - grade_b
result_grade(::typeof(*), grade_a, grade_b) = result_grade(|, grade_a, grade_b):result_grade(∧, grade_a, grade_b)
