@testset "Inner product" begin
    @test v1 ⋅ v1 == 1v
    @test v1 ⋅ v2 == 𝟎
    @test v12 ⋅ v == 𝟎
    @test A ⋅ (B + C) ≈ A ⋅ B + A ⋅ C
    @test (B + C) ⋅ A ≈ B ⋅ A + C ⋅ A
    @test A₁ ⋅ B₃ ≈ (-1) ^ ( 1 * (3 - 1)) * B₃ ⋅ A₁
    @test A₂ ⋅ B₃ ≈ (-1) ^ ( 2 * (3 - 1)) * B₃ ⋅ A₂
    @test A₁ ⋅ B₂ ≈ 0.5 * (A₁ * B₂ - B₂ * A₁)
    @test A₁ ⋅ B₃ ≈ 0.5 * (A₁ * B₃ + B₃ * A₁)
    @test A ⋅ 𝟎 == 𝟎
    @test 𝟎 ⋅ B == 𝟎
end
