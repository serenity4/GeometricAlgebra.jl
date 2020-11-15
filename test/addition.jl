@testset "Addition" begin
    @test 1v1 + 1v2 == mv_1
    @test 1v2 + 1v12 == Multivector(SVector{2}(1v2, 1v12))
    1v1 + mv_1 == Multivector(SVector{2}(2v1, 1v2))
    v1 + v2 == mv_1
end
