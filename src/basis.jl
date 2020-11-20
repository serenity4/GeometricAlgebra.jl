"""
    @basis [prefix=:v, signature="Ø"] <dim>

Pull all unit blade symbols from a `dim`-dimensional geometric algebra with a given `signature` in the local scope.

## Examples

```julia
julia> @basis 3 # no signature

julia> @basis "+++" 3 # v is the default prefix

julia> @basis g "+++" 3 # assigned variables will be g, g1, g12...
```

"""
macro basis(prefix, sig::AbstractString, dim::Integer)
    prefix isa QuoteNode ? prefix = prefix.value : nothing
    @assert prefix isa Symbol "Only symbols are supported for the second argument (received $prefix)"
    if sig ∈ ["Ø", ""]
        sig = Ø
    else
        sig = Signature(count.(["+", "-", "𝟎"], Ref(sig))...)
        @assert dimension(sig) > 0 "Invalid zero-dimensional signature $sig"
    end
    ublades = vcat(collect.(unit_blades(dim, sig))...)
    names = map(x -> Symbol(prefix, join(string.(indices(x)))), ublades)
    exprs = map((x, y) -> :($x = $y), names, ublades)

    quote
        $(esc.(exprs)...)
        $ublades
    end
end

macro basis(sig::AbstractString, dim::Integer) esc(:(@basis(:v, $sig, $dim))) end
macro basis(dim::Integer) esc(:(@basis("Ø", $dim))) end
