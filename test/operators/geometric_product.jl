@testset "Geometric product" begin
    @test v1   * v1         == 1v
    @test v1   * v2         == 1v12
    @test v2   * v2         == 1v
    @test v3   * v3         == 1v
    @test v1   * v12        == 1v2
    @test 1v1  * 1v1        == 1v
    @test 5v1  * 2v2        == 10v12
    @test 1v2  * 1v1        == -1v12
    @test 1v13 * 1v2        == -1v123
    @test 1v1  * 1v2 * 1v12 == -1v
    @test (5v1 + 3v3 + 1v12) * 5v2 == 25v12 - 15v23 + 5v1
    @test 1v1 * 3v2         == -(3v2 * 1v1)
    @test 1v1 * 3v23        == 3v23 * 1v1
    @test A * (B + C) ≈ A * B + A * C
    @test (B + C) * A ≈ B * A + C * A
    @test A + 𝟎 == A
    @test A * 1 == A
    @test A + (-A) ≈ zeros(MV)
end
