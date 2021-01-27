@testset "Geometric product" begin
    @test A * (B + C) ≈ A * B + A * C
    @test (B + C) * A ≈ B * A + C * A
    @test A * 1 == A
    @test A + (-A) ≈ zero(typeof(A))

    @test 1v1 * 1v3 == 1v13
    @test 1v3 * 1v1 == -1v13
    @test 1v3 * 1v2 * 1v1 == -1v123
    @test (1v1 + 2v2 + 1v12) * (1v1 + 1v3) == 1v + 1v13 - 2v12 + 2v23 - 1v2 + 1v123

    for r ∈ 0:4
        Aᵣ = As[r+1]
        for s ∈ 0:4
            Bₛ = Bs[s+1]
            res = Aᵣ * Bₛ
            contribs = map(k -> grade_projection(res, Val(abs(r - s) + 2k)), 0:(r + s - abs(r - s)) ÷ 2)
            @test res ≈ sum(contribs)
        end
    end
end
