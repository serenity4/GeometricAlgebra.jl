@testset "Signature" begin
    @test Signature("+++") == Signature(3, 0)
    @test Signature("++-") == Signature(2, 1)
    @test Signature("+-𝟎") == Signature(1, 1, 1)

    @test !is_degenerate(ℝ⁴)
    @test !is_degenerate(spacetime)
    @test is_degenerate(sig_111)

    @test metric(SIGNATURE, Val(1), Val(1)) == 1
    @test metric(SIGNATURE, Val(1), Val(2)) == 0
    @test metric(SIGNATURE, Val(3), Val(3)) == -1
end
