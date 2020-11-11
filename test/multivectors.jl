@testset "Multivectors" begin
    @test 1v1 + 1v2 == Multivector{d}([1], [1, 1, 0])
    @test 1v2 + 1v12 == Multivector{d}([1, 2], [0, 1, 0], [1, 0, 0])
end
