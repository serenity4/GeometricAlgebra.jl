"""
Linear combination of blades, forming a general multivector.
Coefficients are stored per-grade in contiguous arrays to allow fast access.
"""
struct Multivector{D,T,G,V <: NTuple{G,<:AbstractVector{T}}}
    grades::SVector{G,Int}
    coefs::V
    Multivector{D}(grades::SVector{G,Int}, coefs::V) where {D,G,T,V <: NTuple{G,<:AbstractVector{T}}} =
        new{D,T,G,V}(grades, coefs)
end
Multivector{D}(grades::AbstractVector, coefs::AbstractVector{T}...) where {D,T} = Multivector{D}(SVector{length(grades),Int}(grades), tuple((SVector{length(_coefs),T}(_coefs) for _coefs ∈ coefs)...))

"""
Return the blades of grade `grade` of a `Multivector`.
"""
grade_els(mv::Multivector, grade) = mv.coefs[grade + 1]
grade(mv::Multivector) = maximum(mv.grades)
is_homogeneous(mv::Multivector{D,T,G}) where {D,T,G} = G == 1

function blades(a::Multivector{D}) where {D}
    vcat(blades_from_grade.(D, a.grades)...)
end

function vectors(a::Multivector)
    vcat(map((c, b) -> Blade.(c, b), a.coefs, collect.(blades(a)))...)
end
