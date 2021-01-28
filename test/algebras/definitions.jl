# vectors

a = 1.2v1 + 1.89v3 + 1.2v4

# Homogeneous multivectors

A = 1.3v1 + 2.7v12
B = 0.7v3 + 1.1v123 + 3.05v
C = 0.7v4 + 0.1v2 + 1.59v23 + 1.1v124 + 3.05v1234

A₀ = 0.9v
A₁ = 1.1v1
A₂ = 1.96v23
A₃ = 1.2v123
A₄ = 1.0v1234

B₀ = 2.3v
B₁ = 0.8v2
B₂ = -1.8v13
B₃ = 2.5v234
B₄ = 1.7v1234

C₀ = 0.3v
C₁ = 0.4v4
C₂ = 0.92v24
C₃ = 1.0v134
C₄ = 1.1v1234

As = (A₀, A₁, A₂, A₃, A₄)
Bs = (B₀, B₁, B₂, B₃, B₄)
Cs = (C₀, C₁, C₂, C₃, C₄)

Zs = tuple(As..., Bs..., Cs...)

# Non-homogeneous multivectors

SA = sum(As)
SB = sum(Bs)
SC = sum(Cs)

NHB₀ = 2.3v
NHB₁ = 0.3v1 + 0.8v2
NHB₂ = 0.47v12 + 0.92v23 - 1.8v13
NHB₃ = 1.0v123 + 2.5v234
NHB₄ = 1.7v1234

NHC₀ = 0.3v
NHC₁ = 0.4v4 + 0.3v2
NHC₂ = 0.47v13 + 0.92v24 - 1.8v14
NHC₃ = 1.0v134 + 2.5v124
NHC₄ = 1.1v1234

NHBs = (NHB₀, NHB₁, NHB₂, NHB₃, NHB₄)
NHCs = (NHC₀, NHC₁, NHC₂, NHC₃, NHC₄)

NHZs = tuple(NHBs..., NHCs...)
