@testset "Magnitude" begin
    @test magnitude(A₀) == 0.9
    @test magnitude2(A₀) == 0.81

    if triplet(SIGNATURE) == (1, 3, 0)
        @test magnitude(NHB₁) == sqrt(0.8^2 - 0.3^2)
        @test magnitude2(NHB₁) == 0.3^2 - 0.8^2
    else
        @test magnitude(NHB₁) == sqrt(0.3^2 + 0.8^2)
        @test magnitude2(NHB₁) == 0.3^2 + 0.8^2
    end
end
