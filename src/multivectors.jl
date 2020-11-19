"""
Linear combination of blades, forming a general multivector.
Coefficients are stored per-grade in contiguous arrays to allow fast access.
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

Base.show(io::IO, mv::Multivector) = print(io, join(string.(mv.blades), " + "))
