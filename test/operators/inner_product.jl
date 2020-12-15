@testset "Inner product" begin
    @test v1 ⋅ v1 == 1v
    @test v1 ⋅ v2 == 𝟎
    @test v12 ⋅ v == 𝟎
end
