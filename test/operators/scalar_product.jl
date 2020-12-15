@testset "Scalar product" begin
    # @test v1 ⋅ v1 == 1v
    # @test v1 ⋅ v2 == 𝟎
    # @test v12 ⋅ v == 𝟎
    # @test A ⋅ (B + C) ≈ A ⋅ B + A ⋅ C
    # @test (B + C) ⋅ A ≈ B ⋅ A + C ⋅ A

    # @test A ⋅ 𝟎 == 𝟎
    # @test 𝟎 ⋅ B == 𝟎

    # for r ∈ 0:4
    #     Aᵣ = As[r+1]
    #     for s ∈ 0:4
    #         Bₛ = Bs[s+1]
    #         for t ∈ 0:4
    #             Cₜ = Cs[t+1]
    #             if r + s ≤ t && r > 0 && s > 0
    #                 @test Aᵣ ⋅ (Bₛ ⋅ Cₜ) ≈ (Aᵣ ∧ Bₛ) ⋅ Cₜ
    #             elseif r + t ≤ s
    #                 @test Aᵣ ⋅ (Bₛ ⋅ Cₜ) ≈ (Aᵣ ⋅ Bₛ) ⋅ Cₜ
    #             end
    #         end
    #     end
    #     @test a ⋅ Aᵣ ≈ 0.5 * (a * Aᵣ + (-1) ^ (r + 1) * Aᵣ * a)
    # end
end
