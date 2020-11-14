module TestModule end

@basis TestModule g 3

@testset "Basis macro" begin
    @test isdefined(TestModule, :g)
    @test isdefined(TestModule, :g1)
    @test isdefined(TestModule, :g123)
    @test isdefined(TestModule, :g13)
    @test TestModule.g123 == v123
end
