Base.:*(a::Number, b::BasisElement) = Element(a, b)
Base.:*(a::Number, b::Element) = Element(a * b.coef, b.basis)
Base.:+(a::Element{<:BasisElement{G,I,D}}, b::Element{<:BasisElement{G,I,D}}) where {G,I,D} = Element(a.coef + b.coef, a.basis)
Base.:+(a::Element, b::ZeroElement) = a
Base.:+(a::ZeroElement, b::Element) = b

"""
    `a ∧ b`
Outer product between `a` and `b`.
"""
function ∧ end

function ∧(a::Element{N1,D}, b::Element{N2,D}) where {N1,N2,D}
    basis_a, basis_b = a.basis, b.basis
    bits_a, bits_b = basis_a.bits, basis_b.bits
    for (i, j) ∈ zip(bits_a, bits_b)
        i == 1 == j && return zero(typeof(basis_a))
    end
    ρ = a.coef * b.coef
    s = sign(∧, bits_a, bits_b)
    Element(s * ρ, blade(basis_a, basis_b))
end

function Base.sign(::typeof(∧), a, b)
    @assert length(a) == length(b)
    res = 1
    current = :a
    for i ∈ 1:length(a)
        if b[i] == 1
            current = :b
        elseif current == :b && a[i] == 1
            res *= -1
            current = :a
        end
    end
    res
end
