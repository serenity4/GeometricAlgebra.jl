@testset "Scalar product" begin
    @test 1v1 ⦿ 2v3 == 0
    @test 1v1 ⦿ 2v1 == 2
    @test ((1v1 + 2v2) ⦿ (1v1 + 2v2)) == (triplet(SIGNATURE) == (1, 3, 0) ? -3 : 5)
end
