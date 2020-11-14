"""
    UnitBlade{G,I,D,N}

Unit blade with grade `G` and indices `I`, embedded in a `D`-dimensional geometric algebra.
`N` represents the index of the blade in the 1:2^`D` range.
"""
struct UnitBlade{G,I,N,D} end
UnitBlade{G,I,D}() where {G,I,D} = UnitBlade{G,I,grade_index(D, I),D}()
indices(b::UnitBlade{G,I}) where {G,I} = I

"""
    Blade{B,T}

Blade living in the subspace spanned by `B`, with a coefficient of type `T`.
Can be interpreted as a scaled version of a [`UnitBlade`](@ref).
"""
struct Blade{B <: UnitBlade,T}
    coef::T
    unit_blade::B
end

grade(b::UnitBlade{G}) where {G} = G
grade(b::Blade) = grade(b.unit_blade)

grade_index(d, i::Integer...) = grade_index(d, collect(i))
grade_index(b::UnitBlade{G,I,N,D}) where {G,I,N,D} = grade_index(D, I)
grade_index(b::Blade) = grade_index(b.unit_blade)

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

unit_blades_from_grade(dim, grade) =
    (UnitBlade{length(s), SVector{length(s)}(s), dim}() for s ∈ subsets(1:dim, grade))

unit_blades(dim::Integer) = unit_blades_from_grade.(dim, 0:dim)

"""
Return `val` as a subscript, used for printing `UnitBlade` and `Blade` instances.
"""
function subscript(val)
    r = div(val, 10)
    subscript_char(x) = Char(8320 + x)
    r > 0 ? string(subscript_char(r), subscript_char(mod(val, 10))) : string(subscript_char(val))
end

Base.show(io::IO, b::UnitBlade{G,I}) where {G,I} = print(io, "v$(join(map(subscript, I)))")
Base.show(io::IO, b::Blade{<:UnitBlade{G,I}}) where {G,I} = print(io, "$(b.coef)", string(b.unit_blade))

"""
    @basis [mod=Main, prefix=:v] <dim>
Pull in all unit blade symbols from a `dim`-dimensional geometric algebra.
The symbols are evaluated inside the module `mod`, prefixed with `prefix`.
"""
macro basis(mod, prefix, dim)
    @assert dim isa Integer "Only numbers are supported for the dimension argument (received $dim)"
    prefix isa QuoteNode ? prefix = prefix.value : nothing
    @assert prefix isa Symbol "Only symbols are supported for the second argument (received $prefix)"
    ub = vcat(collect.(unit_blades(dim))...)
    names = map(x -> Symbol(prefix, join(string.(indices(x)))), ub)
    exprs = map((x, y) -> :($x = $y), names, ub)
    quote
        for (b, name, expr) ∈ zip($ub, $names, $exprs)
            Base.eval($(esc(mod)), expr)
        end
        $ub
    end
end

macro basis(prefix, dim) :(@basis($(esc(Main)), $prefix, $dim)) end
macro basis(dim) :(@basis(:v, $dim)) end
