"""
    @basis [prefix=v, opt=nothing] <signature>

Pull all unit blade symbols from a geometric algebra with a given `signature` in the local scope, prefixed with `prefix`.
`opt` currently supports only one option, `:const`, which declares variables as `const`.

## Examples

To obtain the unit blades of 𝒢(ℝ³) the geometric algebra over the 3-dimensional vector space ℝ³, you just have to specify a positive signature with "+++":

```julia
julia> @basis "+++" # v is the default prefix
```

To bind the blades to variables with different prefix than the default v, just add the prefix before the signature:

```julia
julia> @basis g "+++" # assigned variables will be g, g1, g12...
```

When operating at a global scope, it is a good idea to declare everything as const with the option `:const`:

```julia
julia> @basis :const "+++" # variables will be declared as `const`
```

"""
macro basis(prefix, opt, sig::AbstractString)
    _const = opt isa QuoteNode && opt.value == :const

    assign = _const ? ex -> Expr(:const, ex) : identity

    prefix isa QuoteNode ? prefix = prefix.value : nothing
    @assert prefix isa Symbol "Only symbols are supported for the second argument (received $prefix)"

    sig = Signature(sig)

    dim = dimension(sig)
    @assert dim > 0 "Invalid zero-dimensional signature $sig"

    ublades = vcat(collect.(unit_blades(dim, sig))...)
    names = map(x -> Symbol(prefix, join(string.(indices(x)))), ublades)
    exprs = map((x, y) -> assign(:($x = $y)), names, ublades)

    quote
        $(esc.(exprs)...)
        $(esc(assign(:(MV = Multivector{$sig}))))
        $(esc(assign(:(_S = $sig))))
        $(Dict(names .=> ublades))
    end
end

macro basis(sig::AbstractString) esc(:(@basis(:v, $nothing, $sig))) end
macro basis(opt::QuoteNode, sig::AbstractString) esc(:(@basis(:v, $opt, $sig))) end
macro basis(prefix::Symbol, sig::AbstractString) esc(:(@basis($prefix, $nothing, $sig))) end
