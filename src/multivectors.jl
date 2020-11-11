struct Multivector{D,T,G,V <: NTuple{G,<:AbstractVector{T}}}
    grades::SVector{G,Int}
    coefs::V
    Multivector{D}(grades::SVector{G,Int}, coefs::V) where {D,G,T,V <: NTuple{G,<:AbstractVector{T}}} =
        new{D,T,G,V}(grades, coefs)
end
Multivector{D}(grades::AbstractVector, coefs::AbstractVector{T}...) where {D,T} = Multivector{D}(SVector{length(grades),Int}(grades), tuple((SVector{length(_coefs),T}(_coefs) for _coefs ∈ coefs)...))

"""
Return the elements of grade `grade` of a `Multivector`.
"""
grade_els(mv::Multivector, grade) = mv.coefs[grade + 1]
grade(mv::Multivector) = maximum(mv.grades)
is_blade(mv::Multivector{D,T,G}) where {D,T,G} = G == 1

function bases(a::Multivector{D}) where {D}
    vcat(bases_from_grade.(D, a.grades)...)
end

function vectors(a::Multivector)
    vcat(map((c, b) -> Element.(c, b), a.coefs, collect.(bases(a)))...)
end

grade_index(d, i::Integer...) = grade_index(d, collect(i))
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
grade_index(b::BasisElement{G,I,D}) where {G,I,D} = grade_index(D, I)
grade_index(b::Element) = grade_index(b.basis)
