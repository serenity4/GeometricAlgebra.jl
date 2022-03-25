using GeometricAlgebra

@basis "++𝟎"

a = 1.0v1 + 1.0v2 + 1.0v3
b = 0.0v1 + 0.0v2 + 1.0v3
c = 0.5v1 + 0.5v2 + 1.0v3

l1 = a ∧ b
l2 = a ∧ c

magnitude2(a)
