"""
    @basis [mod=Main, prefix=:v, signature="Ø"] <dim>
Pull in all unit blade symbols from a `dim`-dimensional geometric algebra with a given `signature`.
The symbols are evaluated inside the module `mod`, prefixed with `prefix`.
"""
macro basis(mod, prefix, sig, dim)
    @assert dim isa Integer "Only numbers are supported for the dimension argument (received $dim)"
    prefix isa QuoteNode ? prefix = prefix.value : nothing
    @assert prefix isa Symbol "Only symbols are supported for the second argument (received $prefix)"
    if sig ∈ ["Ø", ""]
        sig = Ø
    else
        sig = Signature(count.(["+", "-", "𝟎"], Ref(sig))...)
        @assert dimension(sig) > 0 "Invalid zero-dimensional signature $sig"
    end
    ub = vcat(collect.(unit_blades(dim, sig))...)
    names = map(x -> Symbol(prefix, join(string.(indices(x)))), ub)
    exprs = map((x, y) -> :($x = $y), names, ub)
    quote
        for (b, name, expr) ∈ zip($ub, $names, $exprs)
            Base.eval($(esc(mod)), expr)
        end
        $ub
    end
end

macro basis(prefix, sig, dim) :(@basis($(esc(Main)), $prefix, $sig, $dim)) end
macro basis(sig, dim) :(@basis(:v, $sig, $dim)) end
macro basis(dim) :(@basis("Ø", $dim)) end
