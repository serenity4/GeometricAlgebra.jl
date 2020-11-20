using GeometricAlgebra
using DataStructures
using MacroTools: postwalk, prewalk, @capture
import BenchmarkTools
import Grassmann

include("printing.jl")
include("utils.jl")

function run_benchmark(name, expr::Expr, level)
    indent_level = level * 2
    result = @eval @localbenchmark $expr
    replprint(string(minimum(result)), newline=1, prefix=name * ": "; indent_level)
end

function run_benchmark(name, group, level)
    indent_level = level * 2
    replprint(name; indent_level, newline=1, bold=true, color=color_levels[level])
    for (k, v) ∈ group
        run_benchmark(k, v, level + 1)
    end
end

function run_benchmarks(suite)
    replprint("Benchmarking geometric algebras", newline=1, color=:yellow)

    ga_suite = prepare_suite!(deepcopy(suite))
    grassmann_suite = prepare_suite!(deepcopy(suite); grassmann=true)

    run_benchmark("GeometricAlgebra", ga_suite, 1)
    run_benchmark("Grassmann", grassmann_suite, 1)
end

function prepare_suite!(suite; grassmann=false)
    for (k, v) ∈ suite
        if v isa Expr
            if grassmann
                suite[k] = postwalk(suite[k]) do x
                    if is_blade_symbol(x)
                        Symbol(replace(string(x), r"^v" => "g"))
                    else
                        x
                    end
                end
            end
        else
            prepare_suite!(v; grassmann)
        end
    end
    suite
end

is_blade_symbol(x) = x isa Symbol && startswith(string(x), r"v\d+")

make_suite(base) = make_suite!(OrderedDict(), base)

function make_suite!(suite, base)
    res = DefaultOrderedDict(() -> OrderedDict())
    for (k, v) ∈ base
        if v isa Vector{Expr}
            res[k] = OrderedDict(string.(v) .=> v)
        else
            res[k] = make_suite(v)
        end
    end
    res
end

color_levels = [:red, :cyan]

@basis "+++"
Grassmann.@basis "+++" G g

suite_base = DefaultOrderedDict(() -> OrderedDict())
suite_base["Geometric product"] = [
    :(5v1 * 5v2),
]
suite_base["Addition"] = [
    :(5v1 + 5v2),
]
suite_base["Mixed"]= [
    :((5v1 + 3v3 + 1v12) * 5v2),
]

suite = make_suite(suite_base)

run_benchmarks(suite)
