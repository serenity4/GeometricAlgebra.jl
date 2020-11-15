@testset "Inner product" begin
    @test v1 ⋅ v1 == v
    @test v1 ⋅ v2 == 𝟎
end
