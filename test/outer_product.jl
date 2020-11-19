@testset "Outer product" begin
    @test v1   ∧ v1         == 𝟎
    @test v1   ∧ v2         == 1v12
    @test v1   ∧ v12        == 𝟎
    @test 1v1  ∧ 1v1        == 𝟎
    @test 5v1  ∧ 2v2        == 10v12
    @test 1v2  ∧ 1v1        == -1v12
    @test 1v13 ∧ 1v2        == -1v123
    @test 1v1  ∧ 1v2 ∧ 1v12 == 𝟎
    @test ∧(v1, v3, v2)     == -1(v1 ∧ v2 ∧ v3)
end

