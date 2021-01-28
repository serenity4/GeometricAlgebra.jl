@testset "Regressive product" begin
    @test dual(dual(A) ∧ dual(B)) == A ∨ B
end
