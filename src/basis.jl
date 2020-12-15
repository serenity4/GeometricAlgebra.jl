"""
    @basis [prefix=:v] <signature>

Pull all unit blade symbols from a geometric algebra with a given `signature` in the local scope.

## Examples

To obtain the unit blades of 𝒢³ the geometric algebra over the 3-dimensional vector space ℝ³, you just have to specify a positive signature with "+++":

```julia
julia> @basis "+++" 3 # v is the default prefix
```

To bind the blades to variables with different prefix than the default v, just add the prefix before the signature:

```julia
julia> @basis g "+++" 3 # assigned variables will be g, g1, g12...
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
