using GeometricAlgebra
using BenchmarkTools

@basis "+++"

const mvec = Multivector(randn(2^N))
const b = 1.0v12
const kvec = fill(1.1, Bivector)
const store = zero(typeof(mvec))

@benchmark Ref($mvec * $b)[]
@benchmark Ref($mvec * $kvec)[]
@benchmark Ref($mvec * $mvec)[]

@benchmark Ref(geom!($store, $mvec, $b))[]
@benchmark Ref(geom!($store, $kvec, $kvec))[]
@benchmark Ref(geom!($store, $mvec, $kvec))[]
@benchmark Ref(geom!($store, $mvec, $mvec))[]

@code_warntype mvec * b
@code_warntype mvec * kvec

@benchmark reverse($mvec)
