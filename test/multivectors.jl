@testset "Multivectors" begin
    @test is_homogeneous(mv_1)
    @test grades(mv_1) == [1]
    @test grades(mv_2) == [1,2,3]
    @test all(nonzero_blades(mv_1) .== Any[1v1, 1v2])
    @test all(nonzero_blades(mv_2) .== Any[1v1, 1v12, 1v123])
    @test mv_1[2] == 1
    @test mv_1[3] == 1
    @test mv_2[CartesianIndex(1,2)] == 1
    @test mv_2[CartesianIndex(1,2,3)] == 1
    @test sum(nonzero_blades(mv_1)) == sum(blades(mv_1)) == mv_1
    @test sum(nonzero_blades(mv_2)) == sum(blades(mv_2)) == mv_2

    @test 1v2 + 1v12 == Multivector([0, 0, 1, 0, 1, 0, 0, 0])
    @test 1v1 + mv_1 == Multivector([0, 2, 1, 0, 0, 0, 0, 0])
    @test v1 + v2 == mv_1
end
