var documenterSearchIndex = {"docs":
[{"location":"api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"","category":"page"},{"location":"api/","page":"API","title":"API","text":"Modules = [GeometricAlgebra]\nPrivate = false","category":"page"},{"location":"api/#GeometricAlgebra.Blade","page":"API","title":"GeometricAlgebra.Blade","text":"Blade{S,B,T}\n\nBlade living in the subspace spanned by B with signature S and a coefficient of type T. Can be interpreted as a scaled version of a UnitBlade.\n\n\n\n\n\n","category":"type"},{"location":"api/#GeometricAlgebra.Multivector","page":"API","title":"GeometricAlgebra.Multivector","text":"Linear combination of blades, forming a general multivector.\n\n\n\n\n\n","category":"type"},{"location":"api/#GeometricAlgebra.UnitBlade","page":"API","title":"GeometricAlgebra.UnitBlade","text":"UnitBlade{S,G,I}\n\nUnit blade with grade G, indices I, and Signature S.\n\n\n\n\n\n","category":"type"},{"location":"api/#GeometricAlgebra.:∧","page":"API","title":"GeometricAlgebra.:∧","text":"x ∧ y\n\nOuter product of x with y.\n\n\n\n\n\n","category":"function"},{"location":"api/#GeometricAlgebra.:⋅","page":"API","title":"GeometricAlgebra.:⋅","text":"x ⋅ y\n\nInner product of x with y.\n\n\n\n\n\n","category":"function"},{"location":"api/#GeometricAlgebra.grade_index-Tuple{Any,Any}","page":"API","title":"GeometricAlgebra.grade_index","text":"grade_index(dim, i)\n\nReturn the grade index of i.\n\nExample\n\njulia> grade_index(3, [1])\n1\n\njulia> grade_index(3, [3, 1])\n3\n\n\n\n\n\n","category":"method"},{"location":"api/#GeometricAlgebra.grade_projection-Tuple{Multivector,Any}","page":"API","title":"GeometricAlgebra.grade_projection","text":"Return the blades of grade g from a Multivector.\n\n\n\n\n\n","category":"method"},{"location":"api/#GeometricAlgebra.is_homogeneous-Tuple{Multivector}","page":"API","title":"GeometricAlgebra.is_homogeneous","text":"Whether the mv only contains elements of a single grade.\n\n\n\n\n\n","category":"method"},{"location":"api/#GeometricAlgebra.lcontract","page":"API","title":"GeometricAlgebra.lcontract","text":"lcontract(x, y)\n\nLeft contraction of x with y.\n\n\n\n\n\n","category":"function"},{"location":"api/#GeometricAlgebra.rcontract","page":"API","title":"GeometricAlgebra.rcontract","text":"rcontract(x, y)\n\nRight contraction of x with y. If x and y are \n\n\n\n\n\n","category":"function"},{"location":"api/#GeometricAlgebra.@basis-Tuple{Any,AbstractString}","page":"API","title":"GeometricAlgebra.@basis","text":"@basis [prefix=:v] <signature>\n\nPull all unit blade symbols from a geometric algebra with a given signature in the local scope.\n\nExamples\n\nTo obtain the unit blades of 𝒢³ the geometric algebra over the 3-dimensional vector space ℝ³, you just have to specify a positive signature with \"+++\":\n\njulia> @basis \"+++\" 3 # v is the default prefix\n\nTo bind the blades to variables with different prefix than the default v, just add the prefix before the signature:\n\njulia> @basis g \"+++\" 3 # assigned variables will be g, g1, g12...\n\n\n\n\n\n","category":"macro"},{"location":"intro/#Introduction","page":"Introduction","title":"Introduction","text":"","category":"section"},{"location":"intro/","page":"Introduction","title":"Introduction","text":"Geometric algebra can simplify many rules and exceptions that are commonly found in vector algebra. As an algebra, it is a tool that allows one to express mathematical operations over certain entities. It is widely known that 2D dilations and rotations are more easily described with complex numbers, and to a lesser extent that quaternions are preferred for dealing with 3D rotations. It turns out that complex numbers and quaternions are sub-algebras of geometric algebra. To be exact, the term geometric algebra refers to a Clifford algebra of a vector space over the field of real numbers.","category":"page"},{"location":"intro/","page":"Introduction","title":"Introduction","text":"It uses a more complex structure than vector algebra, where vectors are defined as simple arrays of numbers that have no meaning other than being a list of coordinates. However, what we traditionally consider as vectors are in reality a little more complicated than that. For example, one may find that vectors that result from a cross-product do not follow the same invariance laws than vectors do in physics, and label them as pseudovectors. Geometric algebra accounts for this dissimilarity, describing the cross-product of two vectors as bivectors. The cross-product itself is substituted by another product, called the outer product, and is also defined in two dimensions without requiring a 3D framework. By considering vectors as mathematical entities that possess a particular structure, many theorems and laws appear more natural.","category":"page"},{"location":"#GeometricAlgebra.jl","page":"Home","title":"GeometricAlgebra.jl","text":"","category":"section"},{"location":"#Status","page":"Home","title":"Status","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package is currently in heavy development. The source code and public API may change at any moment. Use at your own risk.","category":"page"},{"location":"","page":"Home","title":"Home","text":"If you accept working with an AGPL license, you should consider using Grassmann.jl instead.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"intro.md\", \"api.md\"]","category":"page"}]
}
