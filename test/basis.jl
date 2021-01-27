module TestModule
    using GeometricAlgebra

    @basis "++-" prefix=g
end

@testset "Basis macro" begin
    @test v1 == Blade(1, 2)
    @test v123 == Blade(1, 8)
    @test v12 == Blade(1, 5)

    @test isdefined(TestModule, :g)
    @test isdefined(TestModule, :g1)
    @test isdefined(TestModule, :g123)
    @test isdefined(TestModule, :g13)
    @test TestModule.g123 == v123
end
