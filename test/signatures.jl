@testset "Signature" begin
    @test sig == Signature(2, 1)
    @test !is_degenerate(sig)

    @test metric(typeof(v1), typeof(v2)) == 0
    @test metric(typeof(v1), typeof(v1)) == 1
    @test metric(typeof(v3), typeof(v3)) == -1
end
