@testset "Promotions" begin
    @test 1v1 + 1.0v1 == 2.0v1
    @test 1v1 + 1.0v2 == 1.0v1 + 1.0v2
    @test 1v1 - 1.0v2 == 1.0v1 - 1.0v2
    @test 1v1 - 1.0v1 == 0.0v1
    @test 1v1 ∧ 1.0v2 == 1v1 * 1.0v2 == 1.0v12
end
