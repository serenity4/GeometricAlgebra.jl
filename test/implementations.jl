using GeometricAlgebra
using StaticArrays

const ga = GeometricAlgebra

@basis "++-"

blade = Blade(1, 4)

include("blades.jl")

spacetime = Signature(3, 1)
ℝ⁴ = Signature(4, 0)
sig_111 = Signature(1, 1, 1)

include("signatures.jl")

include("basis.jl")

mv_1 = convert(Multivector, 1v1 + 1v2)

mv_2 = 1v1 + 1v12 + 1v123

A = 1.3v1 + 2.7v12
B = 0.7v3 + 1.1v123 + 3.05v

include("multivectors.jl")
