@testset "Addition" begin
    @test 1v1 + 1v2 == mv_1
    @test 1v2 + 1v12 == Multivector{sig}(@SVector([0, 0, 1, 0, 1, 0, 0, 0]))
    @test 1v1 + mv_1 == Multivector{sig}(@SVector([0, 2, 1, 0, 0, 0, 0, 0]))
    @test v1 + v2 == mv_1
    @test v1 + 1 == 1v1 + 1v
end
