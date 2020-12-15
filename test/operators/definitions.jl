A = 1.3v1 + 2.7v12
B = 0.7v3 + 1.1v123 + 3.05v
C = 0.7v4 + 0.1v2 + 1.59v23 + 1.1v124 + 3.05v1234

A₀ = 0.9v
A₁ = 1.1v1
A₂ = 1.96v23
A₃ = 1.2v123
A₄ = 1.0v1234

B₀ = 2.3v
B₁ = 0.3v1 + 0.8v2
B₂ = 0.47v12 + 0.92v23 - 1.8v13
B₃ = 1.0v123 + 2.5v234
B₄ = 1.7v1234

C₀ = 0.3v
C₁ = 0.4v4 + 0.3v2
C₂ = 0.47v13 + 0.92v24 - 1.8v14
C₃ = 1.0v134 + 2.5v124
C₄ = 1.1v1234

As = [A₀, A₁, A₂, A₃, A₄]
Bs = [B₀, B₁, B₂, B₃, B₄]
Cs = [C₀, C₁, C₂, C₃, C₄]

D = sum(Bs)

odd_mvs(mvs) = [mv for (i, mv) ∈ enumerate(mvs) if isodd(i)]
even_mvs(mvs) = [mv for (i, mv) ∈ enumerate(mvs) if iseven(i)]
