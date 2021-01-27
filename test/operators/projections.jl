@testset "Grade projections" begin
    @testset "Projection to grade $r" for r ∈ 0:4 begin
            Pᵣ = x -> grade_projection(x, Val(r))
            Aᵣ, Bᵣ = As[r+1], Bs[r+1]
            @test Pᵣ(SA) ≈ As[r+1]
            @test Pᵣ(SB) ≈ Bs[r+1]
            @test Pᵣ(SC) ≈ Cs[r+1]
            @test Pᵣ(A * B) ≈ (-1) ^ (r * (r - 1) ÷ 2) * Pᵣ(reverse(A * B))
            @test Pᵣ(A * Bᵣ * C) ≈ Pᵣ(reverse(C) * Bᵣ * reverse(A))
            for s ∈ 0:4
                Bₛ = Bs[s+1]
                @test Pᵣ(Aᵣ * Bₛ) ≈ Pᵣ(reverse(Bₛ) * Aᵣ) ≈ (-1) ^ (s * (s - 1) ÷ 2) * Pᵣ(Bₛ * Aᵣ)
            end
        end
    end
end
