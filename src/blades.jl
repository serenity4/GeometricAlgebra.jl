struct Blade{T}<:GeometricAlgebraType
    coef::T
    index::Int
end

scalar(coef) = Blade(coef, 1)

is_scalar(b::Blade) = b.index == 1

eltype(::Type{<:Blade{T}}) where {T} = T
eltype(b::Blade) = eltype(typeof(b))

grade(::Number) = 0

is_homogeneous(::Blade) = true

(==)(x::Blade, y::Blade) = x.index == y.index && x.coef == y.coef
(≈)(x::Blade, y::Blade; kwargs...) = x.index == y.index && isapprox(x.coef, y.coef; kwargs...)

Base.iszero(b::Blade) = b.coef ≈ 0

struct KVector{K,V<:MVector}<:GeometricAlgebraType
    coefs::V
    start::Int
end

KVector{K}(coefs::AbstractVector) where {K} = KVector{K}(MVector{length(coefs)}(coefs))

const Bivector = KVector{2}
const Trivector = KVector{3}
const Quadvector = KVector{4}

vectype(::Type{<:KVector{<:Any,V}}) where {V} = V

eltype(T::Type{<:KVector}) = eltype(vectype(T))

length(T::Type{<:KVector}) = length(vectype(T))

grade(::Type{<:KVector{K}}) where {K} = K
grades(T::Type{<:KVector}) = [grade(T)]

# define methods for instances
for f ∈ [:eltype, :length, :grade, :grades]
    @eval begin
        $f(kvec::KVector) = $f(typeof(kvec))
    end
end

setindex!(kvec::KVector, args...) = setindex!(kvec.coefs, args...)

store!(kvec::KVector, b::Blade) = setindex!(kvec, b.coef, value(kvec, b))

function add!(kvec::KVector, b::Blade)
    i = index(kvec, b)
    setindex!(kvec, kvec[i] + b.coef, i)
end

getindex(kvec::KVector, args...) = getindex(kvec.coefs, args...)

index(kvec::KVector, i) = i - (kvec.start - 1)
index(kvec::KVector, b::Blade) = b.index - (kvec.start - 1)

value(x, i) = x[index(x, i)]

blades(x::GeometricAlgebraType) = (Blade(c, i) for (c, i) ∈ zip(x.coefs, indices(x)))

nonzero_blades(x::GeometricAlgebraType) = (b for b ∈ blades(x) if !iszero(b))

is_homogeneous(::KVector) = true

indices(kvec::KVector) = (kvec.start):(kvec.start + length(kvec) - 1)

function show(io::IO, @nospecialize kvec::KVector)
    if kvec == zero(typeof(kvec), eltype(kvec))
        print(io, string(scalar(zero(eltype(kvec)))))
    else
        print(io, join(string.(blades(kvec)), " + "))
    end
end
