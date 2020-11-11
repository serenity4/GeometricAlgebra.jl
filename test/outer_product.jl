@testset "Outer product" begin
    @test 5v1 ∧ 2v2 == 10v12
    @test 1v1 ∧ 1v1 == 𝟎
    @test 1v1 ∧ 1v2 ∧ 1v12 == 𝟎
    @test ∧(v1, v2, v12) == 𝟎
    @test v1 ∧ v2 == v12
    @test v1 ∧ v12 == 𝟎
end

