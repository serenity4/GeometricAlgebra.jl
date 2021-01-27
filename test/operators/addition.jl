@testset "Addition" begin
    @test A₀ + B₀ == B₀ + A₀ == (A₀.coef + B₀.coef) * v
    @test A₂ + B₃ == B₃ + A₂
    @test (A₁ + B₂) + B₃ == A₁ + (B₂ + B₃) == A₁ + B₂ + B₃
    @test A₂ - B₃ == -(B₃ - A₂)
end
