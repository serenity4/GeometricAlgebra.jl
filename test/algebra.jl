@testset "Algebra" begin
    @test sig == Signature(2, 1)
    @test !is_degenerate(G.sig)
    @test is_degenerate(G2.sig)

    @test G.metric(v1, v2) == 0
    @test G.metric(v1, v1) == 1
    @test G.metric(v3, v3) == -1
    @test G2.metric(v3, v3) == 0
    
    @test_logs (:error,"Can only apply metric to grade 1 blades") G.metric(v12, v123)
end
