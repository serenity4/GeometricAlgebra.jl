@testset "Multivectors" begin
    @test GeometricAlgebra.indices(mv_1) == @SVector([[1],[2]])
    @test GeometricAlgebra.indices(mv_2) == @SVector([[1],[1,2],[1,2,3]])
    @test Multivector(1v1, 1v2) == Multivector([1v1, 1v2]) == Multivector(SVector{2}(1v1, 1v2)) == mv_1
end
