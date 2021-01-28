using GeometricAlgebra

@basis "++++-"

const n = 1.0v4 + 1.0v5
const n̄ = 1.0v4 - 1.0v5

point(x) = 0.5 * (2x + magnitude2(x) * n - n̄)
point_pair(A, B) = A ∧ B
circle(A, B, C) = point_pair(A, B) ∧ C
line(A, B) = circle(A, B, n)
norm(X) = -X ⋅ n
sphere(A, B, C, D) = circle(A, B, C) ∧ D
plane(A, B, C) = sphere(A, B, C, n)
radius2(X::Trivector) = - X^2 / (X ∧ n)^2
radius2(X::Quadvector) = X^2 / (X ∧ n)^2
normalize(X) = - X / (X ⋅ n)
center(X) = X * n * X

@testset "3D Conformal Geometric Algebra" begin
    @testset "n & n̄" begin
        @test magnitude2(n) == 0
        @test magnitude2(n̄) == 0
        @test n ⋅ n̄ == n̄ ⋅ n == 2v
        @test n̄ * n * n̄ == 4n̄
        @test n * n̄ * n == 4n
    end

    O = point(0v)

    @testset "Conformal points" begin
        @test O == -0.5n̄

        a = sum(randn(3) .* [v1, v2, v3])
        b = sum(randn(3) .* [v1, v2, v3])

        A = point(a)
        B = point(b)

        @test A ⋅ B ≈ -0.5 * (a - b)^2
        @test all(x -> -x ⋅ n ≈ 1v, [A, B])
    end

    @testset "Circles" begin
        C1 = circle(point(1v1), point(1v2), point(-1v1))
        @test C1 == 2.0v125
        @test normalize(center(C1)) == O
        @test radius2(C1) == 1v

        C2 = circle(point(4v1), point(2v1 + 2v2), point(0v1))
        @test C2 == 4(-v124 + v125 - 4v245)
        @test normalize(center(C2)) == point(2v1)
        @test radius2(C2) == 4v
    end

    @testset "Spheres" begin
        S1 = sphere(point(1v1), point(1v2), point(1v3), point(-1v1))
        @test S1 == 2.0v1235
        @test normalize(center(S1)) == O
        @test radius2(S1) == 1v

        S2 = sphere(point(0v1), point(4v1), point(2v1 + 2v2), point(2v1 + 2v3))
        @test normalize(center(S2)) == point(2v1)
        @test radius2(S2) == 4v
    end
end

# M = line(O, A) ∨ line(A, C)
# circle(A, B, C) ∨ circle(A, B, D)

# @test dual(A) == A ⋅ reverse(I)
# @test dual(dual(A) ∧ dual(B)) == A ∨ B

# @test (a - b)^2 == -2 * (A ⋅ B) / ((A ⋅ n) * (B ⋅ n))

# @test norm(A) == 1v
