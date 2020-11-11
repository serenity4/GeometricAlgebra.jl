@testset "Grade indices" begin
    @test grade_index(3, 1) == 1
    @test grade_index(3, 2) == 2
    @test grade_index(3, 3) == 3
    @test grade_index(3, 1, 2) == 1
    @test grade_index(3, 1, 2, 3) == 1

    @test grade_index(5, 1) == 1
    @test grade_index(5, 1, 2) == 1
    @test grade_index(5, 1, 2, 3) == 1
    @test grade_index(5, 1, 2, 3, 4) == 1
    @test grade_index(5, 2, 3) == 5
    @test grade_index(5, 3, 5) == 9
    @test grade_index(5, 4, 5) == 10
    @test grade_index(5, 1, 4) == 3
    @test grade_index(5, 1, 5) == 4

    @test grade_index(v1) == 1
    @test grade_index(v2) == 2
    @test grade_index(v12) == 1
end
