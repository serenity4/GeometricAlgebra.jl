using BenchmarkTools
using GeometricAlgebra

@basis "++"

function Base.exp(x::T) where {T<:Blade}
    ylast = one(T)
    y = ylast + x
    p = 1
    while abs(y - ylast) > 10 * eps(T)
        p += 1
        ylast = y
        y += x^p / factorial(p)
    end
    y
end

@benchmark Ref(exp(1.))[]
@benchmark Ref(compute_exp(1.))[]
@benchmark Ref(compute_exp(FloatMinusOne{Float64}))[]

compute_exp(FloatMinusOne{Float64}(1.))
