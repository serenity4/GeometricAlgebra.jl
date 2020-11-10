using ConformalGeometry
using Test
using BenchmarkTools
import Grassmann: Grassmann, @basis

@basis "+++" G g

include(joinpath(@__DIR__, "..", "test", "definitions.jl"))

@info "Creation of Elements"
display(@benchmark Ref(5*$v1)[] ∧ Ref(5*$v1)[])
display(@benchmark Ref(5*$v1)[] ∧ Ref(5*$v2)[])
@info "=== Grassmann"
display(@benchmark Grassmann.:∧(Ref(5*$g1)[], Ref(5*$g1)[]))
display(@benchmark Grassmann.:∧(Ref(5*$g1)[], Ref(5*$g2)[]))

@info "Creation of Multivectors"
display(@benchmark Ref(5*$v1)[] + Ref(5*$v2)[])
@info "=== Grassmann"
display(@benchmark Ref(5*$g1)[] + Ref(5*$g2)[])


