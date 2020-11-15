struct Signature
    positive
    negative
    degenerate
end
Signature(p, n) = Signature(p, n, 0)

dimension(sig::Signature) = sig.positive + sig.negative + sig.degenerate
is_degenerate(sig::Signature) = sig.degenerate ≠ 0

struct GeomAlgebra
    metric::Function
    sig::Signature
end

function GeomAlgebra(sig::Signature)
    metric(x, y) = @error("Can only apply metric to grade 1 blades")
    metric(x::UnitBlade{1,I1}, y::UnitBlade{1,I2}) where {I1,I2} = 0
    metric(x::UnitBlade{1,I}, y::UnitBlade{1,I}) where {I} = I[1] <= sig.positive ? 1 : I[1] <= sig.positive + sig.negative ? -1 : 0
    GeomAlgebra(metric, sig)
end

Base.show(io::IO, sig::Signature) = print(io, "<", "+"^sig.positive, "-"^sig.negative, "𝟎"^sig.degenerate, ">")
Base.show(io::IO, ga::GeomAlgebra) = print(io, "GA ", ga.sig)
