using Revise
using ConformalGeometry
using StaticArrays
using BenchmarkTools
using Profile
import Grassmann: Grassmann, @basis

@basis "+++" G g

include(joinpath(@__DIR__, "..", "test", "definitions.jl"))

@info "Blades"
display(@benchmark Ref(5*$v1)[] ∧ Ref(5*$v1)[])
display(@benchmark Ref(5*$v1)[] ∧ Ref(5*$v2)[])
@info "=== Grassmann"
display(@benchmark Grassmann.:∧(Ref(5*$g1)[], Ref(5*$g1)[]))
display(@benchmark Grassmann.:∧(Ref(5*$g1)[], Ref(5*$g2)[]))

@info "Multivectors"
display(@benchmark Ref(5*$v1)[] + Ref(5*$v2)[])
@info "=== Grassmann"
display(@benchmark Ref(5*$g1)[] + Ref(5*$g2)[])

function _g(x, y)
    collect(f(x, y) for _ in 1:100000)
end

f(x, y) = Grassmann.:∧(x, y)

display(@benchmark f(Ref(5 * $g1 + 3 * $g3 + 1 * $g12)[], Ref(5 * $g2)[]))
display(@benchmark ∧(Ref(5 * $v1 + 3 * $v3)[], Ref(1 * $v12 + 5 * $v2)[]))

# f(x, y) = 5x ∧ 5y
# Profile.init(n=100000000, delay=0.00001)
# @profiler _g(v1, v2)
