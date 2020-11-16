struct Signature{P,N,D} end
Signature(positive, negative, degenerate=0) = Signature{positive, negative, degenerate}()

const Ø = Signature{0,0,0}()

positive(::Signature{P}) where {P} = P

negative(::Signature{P,N}) where {P,N} = N

degenerate(::Signature{P,N,D}) where {P,N,D} = D

dimension(sig::Signature) = positive(sig) + negative(sig) + degenerate(sig)

is_degenerate(sig::Signature) = degenerate(sig) ≠ 0

function metric end

Base.show(io::IO, sig::Signature) = print(io, sig == Ø ? "Ø" : "<" * join(["+", "-", "𝟎"] .^ [positive(sig), negative(sig), degenerate(sig)]) * ">")

Base.broadcastable(sig::Signature) = Ref(sig)
