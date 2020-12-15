@testset "Geometric product" begin
    @test A * (B + C) ≈ A * B + A * C
    @test (B + C) * A ≈ B * A + C * A
    @test A + 𝟎 == A
    @test A * 1 == A
    @test A + (-A) ≈ zeros(MV)

    for r ∈ 0:4
        Aᵣ = As[r+1]
        for s ∈ 0:4
            Bₛ = Bs[s+1]
            @test Aᵣ * Bₛ ≈ sum(map(k -> grade_projection(Aᵣ * Bₛ, abs(r - s) + 2k), 0:(r + s - abs(r - s)) ÷ 2))
        end
        @test a ⋅ Aᵣ ≈ 0.5 * (a * Aᵣ + (-1) ^ (r + 1) * Aᵣ * a)
    end
end
