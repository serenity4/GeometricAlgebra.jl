@testset "Grades" begin
    @test grade_index(1; dim=3) == 1
    @test grade_index(2; dim=3) == 2
    @test grade_index(3; dim=3) == 3
    @test grade_index(1, 2; dim=3) == 1
    @test grade_index(1, 2, 3; dim=3) == 1

    @test grade_index(1; dim=5) == 1
    @test grade_index(1, 2; dim=5) == 1
    @test grade_index(1, 2, 3; dim=5) == 1
    @test grade_index(1, 2, 3, 4; dim=5) == 1
    @test grade_index(2, 3; dim=5) == 5
    @test grade_index(3, 5; dim=5) == 9
    @test grade_index(4, 5; dim=5) == 10
    @test grade_index(1, 4; dim=5) == 3
    @test grade_index(1, 5; dim=5) == 4

    @test grade_index(3, v1) == 1
    @test grade_index(3, v2) == 2
    @test grade_index(3, v12) == 1

    @test grade_projection(mv_1, 1) == 1v1 + 1v2
    @test grade_projection(mv_2, 1) == convert(MV, 1v1)
    @test grade_projection(mv_2, 2) == convert(MV, 1v12)
    @test grade_projection(mv_2, 3) == convert(MV, 1v123)
    @test grade_projection(mv_1, 2) == zeros(MV)
end
