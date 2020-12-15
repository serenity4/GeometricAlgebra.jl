@testset "Blades" begin
    @test 1v1 == Blade(1, v1)
    @test 1v2 == Blade(1, v2)
    @test all(unit_blades_from_grade(3, 1, _S) .== [v1, v2, v3])
end

