@testset "Inverse" begin
    for z ∈ Zs
        @test z * inv(z) ≈ inv(z) * z ≈ 1v
    end
end
