using Test
using Grassmann
using BenchmarkTools

@basis S"∅∞+++" # conformal geometric algebra

@test v∞^2 == v∅^2 == 0
@test v∞ ⋅ v∅ == v∅ ⋅ v∞ == -1

# abstract type ConformalGeometry end

# struct Point <: ConformalGeometry
#     a
#     Point(a) = new(1/2 * (2a + a^2*n - n_))
# end

# struct Line <: ConformalGeometry
#     b
# end

# Point(a) = Point(a, 1/2 * (2a + a^2*n - n_))

# Line(p1::Point, p2::Point) = Line(p1, p2, p1 ∧ p2)
# Line(a1, a2) = Line(Point(a1), Point(a2))

# abstract type GeometryTrait end

# struct GeometryType end
# struct Point <: GeometryTrait end

# GeometryType(a) = a^2 == 0v ? Point :

vec3d(a::Grassmann.AbstractTensors.Values{5,Float64}) = a.v[3:end]
vec3d(a::Grassmann.AbstractTensors.Values{32,Float64}) = a.v[4:6]
vec3d(a::Grassmann.Chain{V,1,Float64,5}) = a.v[3:end]
vec3d(a::Grassmann.MultiVector{V,Float64,32}) = a.v[4:6]

point(vec3d) = vec3d + 0.5*vec3d^2*v∞ + v∅
translate(a, p) = exp(1/2 * v∞ * p) >>> a
rotate(a, r, α) = exp(-1/2 * α * r) >>> a

point_pair(a, b) = a ∧ b
circle(a, b, c) = point_pair(a, b) ∧ c
line(a, b) = circle(a, b, v∞)
radius(circ) = sqrt(-circ^2 / (circ ∧ v∞)^2)
center(circ) = circ * v∞ * circ
sphere(a, b, c, d) = circle(a, b, c) ∧ d
plane(a, b, c) = sphere(a, b, c, v∞)

a = point(v1)
b = point(v2)

@test a^2 == b^2 == 0

translate(a, 10v2)

@test rotate(a, v12, π/2) ≈ point(v2)
@test rotate(a, v12, π) ≈ point(-v1)
@test vec3d(translate(a, v1)) ≈ vec3d(point(2v1))

@test translate(translate(a, v1), -v1) ≈ a



point_pair(a, b)
line(a, b)
circ = circle(a, b, point(-v1))
radius(circ)

sph = sphere(a, b, point(v3), point(-v1))

radius(sph)