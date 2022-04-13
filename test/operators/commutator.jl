@testset "Jacobi identity" begin
  @test A × (B × C) ≈ -(B × (C × A) + C × (A × B))
end
