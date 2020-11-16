@testset "Multivectors" begin
    @test GeometricAlgebra.indices(mv_1) == @SVector([[1],[2]])
    @test GeometricAlgebra.indices(mv_2) == @SVector([[1],[1,2],[1,2,3]])
    @test Multivector(1v1, 1v2) == Multivector([1v1, 1v2]) == Multivector(SVector{2}(1v1, 1v2)) == mv_1
    @test is_homogeneous(mv_1)
    @test grade(mv_1) == 1
    @test grade(mv_2) == 3
end
