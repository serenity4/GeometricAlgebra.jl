@testset "Outer product" begin
    @test A₃ ∧ 5 == 5 ∧ A₃ == 5A₃
    @test ∧(v1, v3, v2) == -1(v1 ∧ v2 ∧ v3) == -1v123

    for r ∈ 0:4
        Aᵣ = As[r+1]
        @test a ∧ Aᵣ ≈ 0.5 * (a * Aᵣ + (-1) ^ r * Aᵣ * a)
    end

    @test A ∧ (B + C) ≈ A ∧ B + A ∧ C
    @test (B + C) ∧ A ≈ B ∧ A + C ∧ A
end

