"""
Linear combination of blades, forming a general multivector.
"""
struct Multivector{S,T,V<:AbstractVector{<:Blade{S,<:UnitBlade,T}}}
    blades::V
end
Multivector(blades::Vector{<:Blade}) = Multivector(SVector{length(blades)}(blades))
Multivector(blades::Blade...) = Multivector(collect(blades))

"""
Return the blades of grade `g` from a `Multivector`.
"""
grade_els(mv::Multivector, g) = filter(x -> grade(x) == g, mv.blades)
grade(mv::Multivector) = maximum(grade.(mv.blades))
indices(mv::Multivector) = indices.(mv.blades)

"""
Get `Blade` element with index `(i, j)`.
"""
function Base.getindex(mv::Multivector{S,T}, i::Integer...) where {S,T}
    i = SVector{length(i)}(i)
    for blade ∈ mv.blades
        indices(blade) == i && return blade
    end
    Blade(zero(T), UnitBlade(i, S))
end

"""
Whether the `mv` only contains elements of a single grade.
"""
is_homogeneous(mv::Multivector) = length(unique(grade.(mv.blades))) == 1

Base.show(io::IO, mv::Multivector) = print(io, join(string.(mv.blades), " + "))
