@testset "Inverse" begin
    @test inv(1v1) == 1.0v1
    @test inv(2v2) == 0.5v2
    @test inv(2v1 + 3v2) == (0.5v1 + 1/3 * v2)
end
