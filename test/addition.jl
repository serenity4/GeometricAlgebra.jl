mv12 = Multivector{d}([1], [1, 1, 0])

@testset "Addition" begin
    1v1 + 1v2 == mv12
    1v1 + mv12 == Multivector{d}([1], [2, 1, 0])
    v1 + v2 == mv12
end
