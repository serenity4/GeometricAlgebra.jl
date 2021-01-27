const MultivectorArray = MVector{2^N}

KVector{K}(coefs::MVector) where {K} = KVector{K,typeof(coefs)}(coefs, linear_index(K) + 1)

zero(::Type{<:KVector{K}}, T) where {K} = KVector{K}(zeros(MVector{binomial(N, K),T}))
zero(::Type{<:Multivector}, T) = Multivector(zeros(MultivectorArray))

fill(v, T::Type{<:KVector{K}}) where {K} = T(fill(v, MVector{binomial(N, K)}))
fill(v, ::Type{<:Multivector}) = Multivector(fill(v, MultivectorArray))

linear_index(grade) = ga.linear_index(N, grade)
linear_index(grade, indices) = ga.linear_index(N, grade, indices)

grade_from_linear_index(index) = ga.grade_from_linear_index(N, index)

indices_from_linear_index(index) = ga.indices_from_linear_index(N, index)

"""
    grade_index(dim, i)

Return the grade index of `i`.

## Example
```julia
julia> grade_index(3, [1])
1

julia> grade_index(3, [3, 1])
3
```
"""
grade_index(i) = ga.grade_index(N, i)

grade_projection(x::Blade, ::Val{K}) where {K} = grade(x) == K ? x : K > N ? scalar(zero(eltype(x))) : scalar(zero(eltype(x)))

grade(b::Blade) = grade_from_linear_index(b.index)[1]

function grade(mv::Multivector)
    higher_nonzero_index = findlast(≉(0), mv.coefs)
    isnothing(higher_nonzero_index) && return N
    findfirst(≤(higher_nonzero_index), linear_index.(0:N) .+ 1) - 1
end

dual(x) = x ⋅ reverse(I)

(∨)(xs...) = ∧(dual.(xs)...) ⋅ I

reverse(x::Multivector) = Multivector(map(x -> reverse_sign(grade_from_linear_index(x[1])[1]) * x[2], enumerate(x.coefs)))

"""
Get `Blade` element with index `(i, j)`.
"""
getindex(mv::Multivector, i::CartesianIndex) = getindex(mv.coefs, linear_index(length(i), i.I))

show(io::IO, @nospecialize b::Blade) = print(io, b.coef, "v$(join(map(subscript, indices_from_linear_index(b.index))))")

@generated op_result_type(::typeof(*), T1, T2) = Multivector{MultivectorArray{promote_type(eltype(T1), eltype(T2))}}

kvector(mv::Multivector, ::Val{0}) = scalar(first(mv.coefs))

function kvector(mv::Multivector, ::Val{K}) where {K}
    start = linear_index(K) + 1
    KVector{K}(mv.coefs[start:start + binomial(N, K) - 1])
end

kvectors(mv::Multivector) = (kvector(mv, Val(k)) for k ∈ 0:N)
