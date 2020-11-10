using ConformalGeometry
using Test

include("definitions.jl")

@test grade_index([1, 0, 0]) == 1
@test grade_index([0, 1, 0]) == 2
@test grade_index([0, 0, 1]) == 3
@test grade_index([1, 1, 0]) == 1
@test grade_index([1, 1, 1]) == 1

@test grade_index([1, 0, 0, 0, 0]) == 1
@test grade_index([1, 1, 0, 0, 0]) == 1
@test grade_index([1, 1, 1, 0, 0]) == 1
@test grade_index([1, 1, 1, 1, 0]) == 1
@test grade_index([0, 1, 1, 0, 0]) == 5
@test grade_index([0, 0, 1, 0, 1]) == 9
@test grade_index([0, 0, 0, 1, 1]) == 10
@test grade_index([1, 0, 0, 1, 0]) == 3
@test grade_index([1, 0, 0, 0, 1]) == 4

@test grade_index(v1) == 1
@test grade_index(v2) == 2
@test grade_index(v12) == 1
@test 5v1 ∧ 2v2 == 10v12
@test 1v1 ∧ 1v1 == ZeroElement()

z = ZeroElement()

@test 1v1 + 1v2 == Multivector{d}([1], [1, 1, 0])
@test 1v2 + 1v12 == Multivector{d}([1, 2], [0, 1, 0], [1, 0, 0])
