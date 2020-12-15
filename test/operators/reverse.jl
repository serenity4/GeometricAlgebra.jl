@testset "Reverse" begin
    @test reverse(A₀) == A₀
    @test reverse(A₁) == A₁
    @test reverse(A₂) == -A₂
    @test reverse(A₃) == -A₃
    @test reverse(A₄) == A₄
    @test reverse(A * B) == reverse(B) * reverse(A)
end
