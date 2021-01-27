module TestModule
    using GeometricAlgebra

    @basis "++-" prefix=g export_pseudoscalar=false modname=GA
end

@testset "Basis macro" begin
    @test v123 == Blade(1, 8)

    @test isdefined(TestModule, :g)
    @test isdefined(TestModule, :g1)
    @test isdefined(TestModule, :g123)
    @test isdefined(TestModule, :g13)
    @test !isdefined(TestModule, :I)
    @test isdefined(TestModule.GA, :I)
    @test :I ∉ names(TestModule.GA)
    @test TestModule.g123 == v123
    @test @isdefined(I)

    @test_throws ArgumentError("Macro options must be `(name=value)` pairs") @basis "+++" unknown_option
    @test_throws ArgumentError("Unknown option 'unknown_option'. Available options are: prefix, export_symbols, export_metadata, export_pseudoscalar, modname") @basis "+++" unknown_option=nothing
end
