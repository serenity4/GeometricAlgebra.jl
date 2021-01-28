@testset "Duality" begin
    @test dual(A) == A ⋅ inv(I)
    @test dual(A) ⋅ I == A
    for X ∈ (Zs..., NHZs...)
        @test dual(dual(X)) == I^2 * X
    end
end
