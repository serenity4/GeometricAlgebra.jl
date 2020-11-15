"""
Linear combination of blades, forming a general multivector.
Coefficients are stored per-grade in contiguous arrays to allow fast access.
"""
struct Multivector{T,V<:AbstractVector{<:Blade{<:UnitBlade,T}}}
    blades::V
end
Multivector(blades::Vector{<:Blade}) = Multivector(SVector{length(blades)}(blades))
Multivector(blades::Blade...) = Multivector(collect(blades))

function Multivector(mv::Multivector{T,V}, b::Blade{<:UnitBlade{G,I},T}) where {G,I,T,V}
    inds = indices(mv)
    if I ∈ inds
        v = V(map((x, i) -> (i == I ? x + b : x), mv.blades, inds))
    else
        v = V(vcat(mv.blades, b))
    end
    Multivector(v)
end

"""
Return the blades of grade `g` from a `Multivector`.
"""
grade_els(mv::Multivector, g) = filter(x -> grade(x) == g, mv.blades)
grade(mv::Multivector) = maximum(grade.(mv.blades))
indices(mv::Multivector) = indices.(mv.blades)

"""
Get `Blade` element with index `(i, j)`.
"""
function getindex!(mv::Multivector{T}, i...) where {T}
    for blade ∈ mv.blades
        indices(blade) == i && return blade
    end
    Blade(zero(T), UnitBlade{i}())
end

"""
Return true if all the `Multivector` instance only contains element of a single grade.
"""
is_homogeneous(mv::Multivector) = length(unique(grade.(mv.blades))) == 1
