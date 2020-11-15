"""
    UnitBlade{G,I}

Unit blade with grade `G` and indices `I`, following a [`GeomAlgebra`](@ref) `S`.
"""
struct UnitBlade{S,G,I} end
UnitBlade(inds::AbstractVector{<:Integer}, sig::Signature = Ø) = UnitBlade{sig, length(inds), inds}()

signature(::UnitBlade{S}) where {S} = S

"""
    Blade{B,T}

Blade living in the subspace spanned by `B`, with a coefficient of type `T`.
Can be interpreted as a scaled version of a [`UnitBlade`](@ref).
"""
struct Blade{B<:UnitBlade,T}
    coef::T
    unit_blade::B
end

grade(b::UnitBlade{S,G}) where {S,G} = G
grade(b::Blade) = grade(b.unit_blade)

indices(b::UnitBlade{S,G,I}) where {S,G,I} = I
indices(b::Blade) = indices(b.unit_blade)

grade_index(i::Integer...; dim) = grade_index(dim, collect(i))
grade_index(dim, b::UnitBlade{S,G,I}) where {S,G,I} = grade_index(dim, I)
grade_index(dim, b::Blade) = grade_index(dim, b.unit_blade)

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
Base.show(io::IO, b::Blade{<:UnitBlade{S,G,I}}) where {S,G,I} = print(io, "$(b.coef)", string(b.unit_blade))

"""
    @basis [mod=Main, prefix=:v, signature="Ø"] <dim>
Pull in all unit blade symbols from a `dim`-dimensional geometric algebra with a given `signature`.
The symbols are evaluated inside the module `mod`, prefixed with `prefix`.
"""
macro basis(mod, prefix, sig, dim)
    @assert dim isa Integer "Only numbers are supported for the dimension argument (received $dim)"
    prefix isa QuoteNode ? prefix = prefix.value : nothing
    @assert prefix isa Symbol "Only symbols are supported for the second argument (received $prefix)"
    if sig ∈ ["Ø", ""]
        sig = Ø
    else
        sig = Signature(count.(["+", "-", "𝟎"], Ref(sig))...)
        @assert dimension(sig) > 0 "Invalid zero-dimensional signature $sig"
    end
    ub = vcat(collect.(unit_blades(dim, sig))...)
    names = map(x -> Symbol(prefix, join(string.(indices(x)))), ub)
    exprs = map((x, y) -> :($x = $y), names, ub)
    quote
        for (b, name, expr) ∈ zip($ub, $names, $exprs)
            Base.eval($(esc(mod)), expr)
        end
        $ub
    end
end

macro basis(prefix, sig, dim) :(@basis($(esc(Main)), $prefix, $sig, $dim)) end
macro basis(sig, dim) :(@basis(:v, $sig, $dim)) end
macro basis(dim) :(@basis("Ø", $dim)) end
