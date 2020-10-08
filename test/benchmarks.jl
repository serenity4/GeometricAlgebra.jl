using ConformalGeometry
using BenchmarkTools
@benchmark coef_outer_product($a, $b, (false, true, false))