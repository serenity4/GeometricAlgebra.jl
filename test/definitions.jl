dim = 3

@basis 3

sig = Signature(2, 1, 0)
G = GeomAlgebra(sig)
G2 = GeomAlgebra(Signature(1, 1, 1))

mv_1 = Multivector(1v1, 1v2)
mv_2 = Multivector(1v1, 1v12, 1v123)
