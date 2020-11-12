"""
    UnitBlade{G,I,D}

Unit blade with grade `G` and indices `I`, embedded in a `D`-dimensional geometric algebra.
"""
struct UnitBlade{G,I,D} end

indices(b::UnitBlade{G,I}) where {G,I} = I

"""
    Blade{B,T}

[`UnitBlade`](@ref) associated with a value of type `T`.

Can be interpreted as a scaled version of a unit blade, in the case where `T` is a scalar. Instances are multivectors living in the subspace spanned by `B`.
"""
struct Blade{B <: UnitBlade,T}
    coef::T
    unit_blade::B
end

Blade(_, zero::Zero) = zero

grade(b::UnitBlade{G}) where {G} = G
grade(b::Blade) = grade(b.unit_blade)

grade_index(d, i::Integer...) = grade_index(d, collect(i))
grade_index(b::UnitBlade{G,I,D}) where {G,I,D} = grade_index(D, I)
grade_index(b::Blade) = grade_index(b.unit_blade)

function grade_index(d, i)
    g = length(i)
    if g == 0
        1
    elseif g == 1
        first(i)
    elseif first(i) == 1
        grade_index(d-1, i[2:end] .- 1)
    else
        # grade_index(d-1, i[1:end-1] .- i[1]) + (i[2] - i[1]) * (d - i[1])
        grade_index(d-1, i .- 1) + (d - 1)
    end
end

blades_from_grade(dim, g) =
    (UnitBlade{length(s), SVector{length(s)}(s), dim}() for s ∈ subsets(1:dim, g))

blades(dim::Integer) = blades_from_grade.(dim, 0:dim)

"""
Return `val` as a subscript, used for printing `UnitBlade` and `Blade` vectors.
"""
function subscript(val)
    r = div(val, 10)
    subscript_char(x) = Char(8320 + x)
    r > 0 ? string(subscript_char(r), subscript_char(mod(val, 10))) : string(subscript_char(val))
end

Base.show(io::IO, b::UnitBlade{G,I}) where {G,I} = print(io, "v$(join(map(subscript, I)))")
Base.show(io::IO, b::Blade{<:UnitBlade{G,I}}) where {G,I} = print(io, "$(b.coef)", string(b.unit_blade))

