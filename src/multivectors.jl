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

function Multivector{D}(grades::AbstractVector, coefs::AbstractVector{T}...) where {D,T}
    n_grades = length(grades)
    grade_coefs = tuple((SVector{length(_coefs),T}(_coefs) for _coefs ∈ coefs)...)
    Multivector{D}(SVector{n_grades,Int}(grades), grade_coefs)
end

"""
Return the blades of grade `grade` of a `Multivector`.
"""
grade_els(mv::Multivector, grade) = mv.coefs[grade + 1]
grade(mv::Multivector) = maximum(mv.grades)

"""
Return true if all the `Multivector` instance only contains element of a single grade.
"""
is_homogeneous(mv::Multivector{D,T,G}) where {D,T,G} = G == 1

function unit_blades(a::Multivector{D}) where {D}
    vcat(unit_blades_from_grade.(D, a.grades)...)
end

"""
Materialize the blades of the multivector.
"""
function blades(a::Multivector)
    vcat(map((c, b) -> Blade.(c, b), a.coefs, collect.(blades(a)))...)
end
