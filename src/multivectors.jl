struct Multivector{V<:MVector}<:GeometricAlgebraType
    coefs::V
end

Multivector(coefs::AbstractVector) = Multivector(MVector{length(coefs)}(coefs))

vectype(::Type{<:Multivector{V}}) where {V} = V

eltype(T::Type{<:Multivector}) = eltype(vectype(T))
eltype(::Type{Multivector}) = Any
eltype(mv::Multivector) = eltype(typeof(mv))

length(T::Type{<:Multivector}) = length(vectype(T))
length(mv::Multivector) = length(typeof(mv))

zero(::Type{<:Multivector{V}}) where {V} = Multivector(zeros(V))

grades(mv::Multivector) = unique(grade.(nonzero_blades(mv)))

setindex!(mv::Multivector, args...) = setindex!(mv.coefs, args...)

store!(mv::Multivector, b::Blade) = setindex!(mv, b.coef, b.index)

add!(mv::Multivector, b::Blade) = setindex!(mv, mv[b.index] + b.coef, b.index)

getindex(mv::Multivector, args...) = getindex(mv.coefs, args...)

index(::Multivector, i) = i
index(::Multivector, b::Blade) = b.index

broadcastable(mv::Multivector) = mv.coefs

(==)(x::Multivector, y::Multivector) = all(x.coefs .== y.coefs)
@commutative (==)(x::Blade, y::GeometricAlgebraType) = x.coef == value(y, x)

(≈)(x::Multivector, y::Multivector; kwargs...) = all(.≈(x.coefs, y.coefs; kwargs...))
(≈)(x::Blade, y::GeometricAlgebraType; kwargs...) = ≈(x.coef, value(y, x); kwargs...)
(≈)(y::GeometricAlgebraType, x::Blade; kwargs...) = ≈(x.coef, value(y, x); kwargs...)

function (==)(x::GeometricAlgebraType, y::GeometricAlgebraType)
    bx, by = collect(nonzero_blades(x)), collect(nonzero_blades(y))
    length(bx) == length(by) && all(bx .== by)
end

function (≈)(x::GeometricAlgebraType, y::GeometricAlgebraType; kwargs...)
    bx, by = collect(nonzero_blades(x)), collect(nonzero_blades(y))
    length(bx) == length(by) && all(.≈(bx, by; kwargs...))
end

indices(mv::Multivector) = 1:length(mv)

is_homogeneous(mv::Multivector) = length(grades(mv)) ≤ 1

function convert(T::Type{<:Multivector}, kvec::KVector)
    mv = zero(Multivector, eltype(T) == Any ? eltype(kvec) : promote_type(eltype(T), eltype(kvec)))
    mv.coefs[indices(kvec)] .= kvec.coefs
    mv
end

function kvectors end

function kvector end

function show(io::IO, @nospecialize mv::Multivector)
    bs = nonzero_blades(mv)
    if isempty(bs)
        print(io, string(scalar(zero(eltype(mv)))))
    else
        print(io, join(string.(collect(bs)), " + "))
    end
end
