module TestModule
    using GeometricAlgebra

    @basis g "++-"
end

@testset "Basis macro" begin
    @test isdefined(TestModule, :g)
    @test isdefined(TestModule, :g1)
    @test isdefined(TestModule, :g123)
    @test isdefined(TestModule, :g13)
    @test TestModule.g123 == v123
end
