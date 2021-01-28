const MultivectorArray = MVector{2^N}
const COMBINATIONS = [[], ga.combinations(1:N)...]

KVector{K}(coefs::MVector) where {K} = KVector{K,typeof(coefs)}(coefs, linear_index(K))
KVector{K,V}(coefs::V) where {K,V<:AbstractVector} = KVector{K,V}(coefs, linear_index(K))

zero(::Type{<:KVector{K}}, T) where {K} = KVector{K}(zeros(MVector{binomial(N, K),T}))
zero(::Type{<:Multivector}, T) = Multivector(zeros(MultivectorArray))

fill(v, T::Type{<:KVector{K}}) where {K} = T(fill(v, MVector{binomial(N, K)}))
fill(v, ::Type{<:Multivector}) = Multivector(fill(v, MultivectorArray))

linear_index(grade::Integer) = linear_index(COMBINATIONS, grade)
linear_index(indices) = linear_index(COMBINATIONS, indices)

indices_from_linear_index(index::Integer) = indices_from_linear_index(COMBINATIONS, index)

grade_projection(x::Blade, ::Val{K}) where {K} = grade(x) == K ? x : K > N ? scalar(zero(eltype(x))) : scalar(zero(eltype(x)))

grade(b::Blade) = length(indices_from_linear_index(b.index))

function grade(mv::Multivector)
    higher_nonzero_index = findlast(≉(0), mv.coefs)
    isnothing(higher_nonzero_index) && return N
    findfirst(≤(higher_nonzero_index), linear_index.(0:N) .+ 1) - 1
end

dual(x) = x / I

(∨)(xs...) = ∧(dual.(xs)...) ⋅ I

reverse(x::Multivector) = Multivector(map(x -> reverse_sign(length(indices_from_linear_index(x[1]))) * x[2], enumerate(x.coefs)))

"""
Get `Blade` element with index `(i, j)`.
"""
getindex(mv::Multivector, i::CartesianIndex) = getindex(mv.coefs, linear_index(SVector(i.I)))

show(io::IO, @nospecialize b::Blade) = print(io, b.coef, "v$(join(map(subscript, indices_from_linear_index(b.index))))")

@generated op_result_type(::typeof(*), T1, T2) = Multivector{MultivectorArray{promote_type(eltype(T1), eltype(T2))}}

kvector(mv::Multivector, ::Val{0}) = scalar(first(mv.coefs))

function kvector(mv::Multivector, ::Val{K}) where {K}
    start = linear_index(K)
    KVector{K}(mv.coefs[start:start + binomial(N, K) - 1])
end

kvectors(mv::Multivector) = (kvector(mv, Val(k)) for k ∈ 0:N)
