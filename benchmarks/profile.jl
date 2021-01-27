using GeometricAlgebra
using BenchmarkTools
using Profile
Profile.init(500000000, 5e-8)

@basis "+++"

f(v1, v3, v12, v2) = (5v1 + 3v3 + 1v12) * 5v2
h(v1, v3, v12, v2) = 5v1 + 3v3 + 1v2
@benchmark f($v1, $v3, $v12, $v2)
# @profiler f(v1, v3, v12, v2)
