@testset "Signature" begin
    @test Signature("+++") == Signature(3, 0)
    @test Signature("++-") == Signature(2, 1)
    @test Signature("+-𝟎") == Signature(1, 1, 1)

    @test !is_degenerate(ℝ⁴)
    @test !is_degenerate(spacetime)
    @test is_degenerate(sig_111)

    @test metric(typeof(v1), typeof(v2)) == 0
    @test metric(typeof(v1), typeof(v1)) == 1
    @test metric(typeof(v3), typeof(v3)) == -1
end
