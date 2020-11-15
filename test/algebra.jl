@testset "Signature" begin
    @test sig == Signature(2, 1)
    @test !is_degenerate(sig)

    @test metric(v1, v2) == 0
    @test metric(v1, v1) == 1
    @test metric(v3, v3) == -1

    @test_logs (:error,"Can only apply metric to grade 1 blades") metric(v12, v123)
end
