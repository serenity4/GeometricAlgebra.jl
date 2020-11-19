using GeometricAlgebra
using BenchmarkTools
import Grassmann

packages = ["GeometricAlgebra", "Grassmann"]

suite = BenchmarkGroup(packages)

@basis v "+++" 3

package = "GeometricAlgebra"
suite[package] = BenchmarkGroup()
suite[package]["geometric_product"] = BenchmarkGroup()
suite[package]["geometric_product"]["5v1 + 5v1"] = @benchmarkable Ref(5*$v1)[] * Ref(5*$v1)[]
suite[package]["geometric_product"]["5v1 + 5v2"] = @benchmarkable Ref(5*$v1)[] * Ref(5*$v2)[]
suite[package]["addition"] = BenchmarkGroup()
suite[package]["addition"]["5v1 + 5v2"] = @benchmarkable Ref(5*$v1)[] + Ref(5*$v2)[]
suite[package]["mixed"] = BenchmarkGroup()
suite[package]["mixed"]["(5v1 + 3v3 + 1v12) * 5v2"] = @benchmarkable Ref(5*$v1 + 3*$v3 + 1*$v12)[] * Ref(5*$v2)[]

Grassmann.@basis "+++" G v

package = "Grassmann"
suite[package] = BenchmarkGroup(["geometric_product", "addition", "mixed"])
suite[package]["geometric_product"] = BenchmarkGroup()
suite[package]["geometric_product"]["5v1 + 5v1"] = @benchmarkable Ref(5*$v1)[] * Ref(5*$v1)[]
suite[package]["geometric_product"]["5v1 + 5v2"] = @benchmarkable Ref(5*$v1)[] * Ref(5*$v2)[]
suite[package]["addition"] = BenchmarkGroup()
suite[package]["addition"]["5v1 + 5v2"] = @benchmarkable Ref(5*$v1)[] + Ref(5*$v2)[]
suite[package]["mixed"] = BenchmarkGroup()
suite[package]["mixed"]["(5v1 + 3v3 + 1v12) * 5v2"] = @benchmarkable Ref(5*$v1 + 3*$v3 + 1*$v12)[] * Ref(5*$v2)[]

println(run(suite))
