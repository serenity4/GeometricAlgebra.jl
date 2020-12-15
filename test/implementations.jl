using GeometricAlgebra
using StaticArrays

const ga = GeometricAlgebra

@basis "++-"

spacetime = Signature(3, 1)
ℝ⁴ = Signature(4, 0)
sig_111 = Signature(1, 1, 1)

mv_1 = 1v1 + 1v2
mv_2 = 1v1 + 1v12 + 1v123

A = 1.3v1 + 2.7v12
B = 0.7v3 + 1.1v123 + 3.05v

include("signatures.jl")
include("basis.jl")
include("blades.jl")
include("grades.jl")
include("multivectors.jl")
