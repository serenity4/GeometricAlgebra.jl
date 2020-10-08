using ConformalGeometry

d = 3
k = BitVector(collect(rand(0:1) for _ ∈ 1:d))

a = collect(1:2^d)
b = collect(2^d .+ (1:2^d))

const a0, a1, a2, a3, a4, a5, a6, a7 = getindex.(Ref(reverse(a)), 1:2^d)
const b0, b1, b2, b3, b4, b5, b6, b7 = getindex.(Ref(reverse(b)), 1:2^d)

const coefs_outerproduct = [
    a7 * b0 + a6 * b1 - a5 * b2 + a4 * b3 + a3 * b4 - a2 * b5 + a1 * b6 + a0 * b7,
    a6 * b0 + a4 * b2 - a2 * b4 + a0 * b6,
    a5 * b0 + a4 * b1 - a1 * b4 + a0 * b5,
    a4 * b0 + a0 * b4,
    a3 * b0 + a2 * b1 - a1 * b2 + a0 * b3,
    a2 * b0 + a0 * b2,
    a1 * b0 + a0 * b1,
    a0 * b0
]

@assert binary_tree_index(BitVector(repeat([1], d))) == 1
@assert binary_tree_index(BitVector(repeat([0], d))) == 2^d
@assert coef_outer_product_labels(Bool[1, 0, 1]) == [
    Bool[1, 0, 1],
    Bool[1, 0, 0],
    Bool[0, 0, 1],
    Bool[0, 0, 0]
]
@assert (r = 1:-1:0; all(coef_outer_product.(Ref(a), Ref(b), (Bool[i, j, k] for i=r for j=r for k=r)) .== coefs_outerproduct))