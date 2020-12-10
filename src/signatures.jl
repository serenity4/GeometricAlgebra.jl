struct Signature{P,N,D} end

Signature(positive, negative=0, degenerate=0) = Signature{positive, negative, degenerate}()
Signature(string::AbstractString) = Signature(count.(["+", "-", "𝟎"], Ref(string))...)

const Ø = Signature{0,0,0}()

@generated positive(::Signature{P}) where {P} = P

@generated negative(::Signature{P,N}) where {P,N} = N

@generated degenerate(::Signature{P,N,D}) where {P,N,D} = D

@generated dimension(::Signature{P,N,D}) where {P,N,D} = P + N + D

is_degenerate(sig::Signature) = degenerate(sig) ≠ 0

function metric end

Base.show(io::IO, sig::Signature) = print(io, sig == Ø ? "Ø" : "<" * join(["+", "-", "𝟎"] .^ [positive(sig), negative(sig), degenerate(sig)]) * ">")

Base.broadcastable(sig::Signature) = Ref(sig)
