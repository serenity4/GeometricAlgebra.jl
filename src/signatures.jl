struct Signature{P,N,D} end
Signature(positive, negative, degenerate=0) = Signature{positive, negative, degenerate}()

const Ø = Signature{0,0,0}()

positive(::Signature{P}) where {P} = P
negative(::Signature{P,N}) where {P,N} = N
degenerate(::Signature{P,N,D}) where {P,N,D} = D

dimension(sig::Signature) = positive(sig) + negative(sig) + degenerate(sig)
is_degenerate(sig::Signature) = degenerate(sig) ≠ 0

include("blades.jl")

metric(x::UnitBlade{S,1,I}, y::UnitBlade{S,1,I}) where {S,I} = I[1] <= positive(S) ? 1 : I[1] <= positive(S) + negative(S) ? -1 : 0
metric(x::UnitBlade{S,1,I1}, y::UnitBlade{S,1,I2}) where {S,I1,I2} = 0
metric(x, y) = @error("Can only apply metric to grade 1 blades")

Base.show(io::IO, sig::Signature) = print(io, sig == Ø ? "Ø" : "<" * join(["+", "-", "𝟎"] .^ [positive(sig), negative(sig), degenerate(sig)]) * ">")

Base.broadcastable(sig::Signature) = Ref(sig)
