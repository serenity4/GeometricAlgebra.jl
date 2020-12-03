@testset "Grades" begin
    @test grade_index(1; dim) == 1
    @test grade_index(2; dim) == 2
    @test grade_index(3; dim) == 3
    @test grade_index(1, 2; dim) == 1
    @test grade_index(1, 2, 3; dim) == 1

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

    @test all(grade_els(mv_1, 1) .== [1v1, 1v2])
    @test all(grade_els(mv_2, 1) .== [1v1])
    @test all(grade_els(mv_2, 2) .== [1v12])
    @test all(grade_els(mv_2, 3) .== [1v123])
    @test isempty(grade_els(mv_1, 2))
end
