function basis(sig::Signature, prefix::Symbol, export_symbols::Bool, export_metadata::Bool, export_pseudoscalar::Bool, modname::Symbol)
    prefix isa Symbol || throw(ArgumentError("Only symbols are supported for the second argument (received $prefix)"))

    n = dimension(sig)
    n > 0 || throw(ArgumentError("Invalid zero-dimensional signature $sig"))

    _combinations = [[], combinations(1:n)...]

    inds = 1:2^n
    blade_symbols = map(x -> Symbol(prefix, join(string.(indices_from_linear_index(_combinations, x)))), inds)
    blades = Blade.(1, inds)
    exprs = map((x, y) -> (:(const $x = $y)), blade_symbols, blades)

    table = reshape([produce_indices(i, j, _combinations, sig) for i ∈ _combinations, j ∈ _combinations], 2^n, 2^n)

    exports = Symbol[]
    export_symbols && append!(exports, blade_symbols)
    export_metadata && append!(exports, [:N, :SIGNATURE, :TABLE, :MultivectorArray])
    export_pseudoscalar && push!(exports, :I)

    mod = :(module $modname
        using GeometricAlgebra: GeometricAlgebra, subscript, reverse_sign, scalar, ⋅, ∧
        using GeometricAlgebra.StaticArrays

        const ga = GeometricAlgebra

        import Base: fill, zero, *, getindex, show, reverse
        import GeometricAlgebra: Blade, KVector, Multivector, grade, grade_projection, geom, op_result_type, kvectors, kvector, dual, ∨, linear_index, indices_from_linear_index

        $(exprs...)

        const N = $n
        const SIGNATURE = $sig
        const TABLE = $table
        const I = $(last(blade_symbols))

        include($("$(@__DIR__)/dimension_dependent.jl"))
        include($("$(@__DIR__)/backends/precomputed.jl"))

        export $(exports...)

    end)

    mod, modname
end

function produce_indices(i, j, combinations, sig::Signature)
    concat_inds = vcat(i, j)
    inds = sort(filter(x -> count(==(x), concat_inds) == 1, concat_inds))
    double_inds = filter(x -> count(==(x), concat_inds) == 2, unique(concat_inds))
    metric_factor = prod(map(ei -> metric(sig, Val(ei)), double_inds))
    linear_index(combinations, inds), metric_factor * permsign(i, j)
end

"""
    @basis <signature> [prefix=v, export_symbols=true, export_metadata=true, export_pseudoscalar=true, modname=GeneratedGA]

Create a module `modname`, fill it with all unit blade symbols from a geometric algebra with a given `signature` prefixed with `prefix`, and import it with `using`.
The exported variables depend on the options `export_symbols` and `export_metadata`.
If `export_symbols` is true, then all unit blade symbols are exported.
If `export_metadata` is true, then the following symbols are exported:
- `N`: the dimension of the algebra
- `TABLE`: the table containing precomputed values for blade products
- `SIGNATURE`: the signature used to build the algebra
- `MultivectorArray`: a concrete multivector array representation, with `2^N` coefficients.
If `export_pseudoscalar` is true, then the alias `I = v₁...ₙ` will be exported.

## Examples

To obtain the unit blades of 𝒢(ℝ³) the geometric algebra over the 3-dimensional vector space ℝ³, you just have to specify a positive signature with "+++":

```julia
julia> @basis "+++" # v is the default prefix
```

To bind the blades to variables with different prefix than the default v, just add the prefix after the signature:

```julia
julia> @basis "+++" prefix=g # assigned variables will be g, g1, g12...
```
"""
macro basis(sig::AbstractString, opts...)
    try
        mod, modname = basis(Signature(sig), parse_macro_opts(collect(opts))...)
        :($(Expr(:toplevel, esc(mod))); using .$modname)
    catch e
        e isa ArgumentError || rethrow()
        :(throw($(esc(e))))
    end
end

const basis_macro_opts = [
    :prefix => :v,
    :export_symbols => true,
    :export_metadata => true,
    :export_pseudoscalar => true,
    :modname => :GeneratedGA,
]

function parse_macro_opts(opts::AbstractVector)
    check_opt.(opts)
    map(basis_macro_opts) do opt
        index = findfirst(==(opt.first), opt_name.(opts))
        isnothing(index) ? opt.second : last(opts[index].args)
    end
end

function check_opt(opt)
    opt isa Expr && opt.head == :(=) || throw(ArgumentError("Macro options must be `(name=value)` pairs"))
    opt_name(opt) ∈ first.(basis_macro_opts) || throw(ArgumentError("Unknown option '$(opt_name(opt))'. Available options are: $(join(first.(basis_macro_opts), ", "))"))
end

opt_name(opt::Expr) = first(opt.args)
