@testset "Blades" begin
    @test blade.index == 4
    @test eltype(blade) == Int
    @test eltype(Blade(1.0, 4)) == Float64
    @test Blade(1.0, 4) == blade
    @test Blade(1.0, 5) ≉ blade
    @test Blade(1.0, 4) ≈ blade
    @test Blade(1.0, 5) ≉ blade
    @test is_homogeneous(blade)
    @test scalar(1.0) == Blade(1.0, 1)
end

