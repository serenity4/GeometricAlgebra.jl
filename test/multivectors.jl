@testset "Multivectors" begin
    @test GeometricAlgebra.indices(mv_1) == @SVector([[1],[2]])
    @test GeometricAlgebra.indices(mv_2) == @SVector([[1],[1,2],[1,2,3]])
    @test is_homogeneous(mv_1)
    @test grade(mv_1) == 1
    @test grade(mv_2) == 3
    @test all(blades(mv_1) .== [1v1, 1v2])
    @test all(blades(mv_2) .== [1v1, 1v12, 1v123])
    @test mv_1[1] == 1
    @test mv_1[2] == 1
    @test mv_2[1,2] == 1
    @test mv_2[1,2,3] == 1
end
