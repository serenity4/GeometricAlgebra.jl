@testset "Grades" begin
    @test ga.grade_index(3, [1]) == 1
    @test ga.grade_index(3, [2]) == 2
    @test ga.grade_index(3, [3]) == 3
    @test ga.grade_index(3, [1,2]) == 1
    @test ga.grade_index(3, [1,2,3]) == 1

    @test ga.grade_index(5, [1]) == 1
    @test ga.grade_index(5, [1,2]) == 1
    @test ga.grade_index(5, [1,2,3]) == 1
    @test ga.grade_index(5, [1,2,3,4]) == 1
    @test ga.grade_index(5, [2,3]) == 5
    @test ga.grade_index(5, [3,5]) == 9
    @test ga.grade_index(5, [4,5]) == 10
    @test ga.grade_index(5, [1,4]) == 3
    @test ga.grade_index(5, [1,5]) == 4
end
