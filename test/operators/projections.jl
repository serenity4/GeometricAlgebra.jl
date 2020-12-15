@testset "Grade projections" begin
    @testset "Projection to grade $r" for r ∈ 0:4 begin
            Pᵣ = x -> grade_projection(x, r)
            Aᵣ, Bᵣ = As[r+1], Bs[r+1]
            @test Pᵣ(SA) ≈ As[r+1]
            @test Pᵣ(SB) ≈ Bs[r+1]
            @test Pᵣ(SC) ≈ Cs[r+1]
            @test Pᵣ(A * B) ≈ (-1) ^ (r * (r - 1) ÷ 2) * Pᵣ(reverse(A * B))
            @test Pᵣ(Aᵣ * B₁) ≈ Pᵣ(reverse(B₁) * Aᵣ) ≈ Pᵣ(B₁ * Aᵣ)
            @test Pᵣ(Aᵣ * B₂) ≈ Pᵣ(reverse(B₂) * Aᵣ) ≈ -Pᵣ(B₂ * Aᵣ)
            @test Pᵣ(A * Bᵣ * C) ≈ Pᵣ(reverse(C) * Bᵣ * reverse(A))
        end
    end
end
