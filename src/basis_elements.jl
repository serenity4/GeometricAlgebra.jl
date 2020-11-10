struct BasisElement{G, I, D, V<:SVector{D, Int}} <: GAEntity{D}
    bits::V
    function BasisElement(bits::V) where {D, V<:SVector{D, Int}}
        G = sum(bits)
        new{G, grade_index(bits), D, V}(bits)
    end
end
BasisElement(bits::Integer...) = BasisElement(SVector{length(bits), Int}(bits))

struct Element{B<:BasisElement, T}
    coef::T
    basis::B
end

basis_index(b::BasisElement{G,I,D}) where {G,I,D} = sum(binomial.(D, 1:G-1)) + I
grade_index(b::BasisElement{G,I}) where {G,I} = I

blade(a::BasisElement, b::BasisElement) = BasisElement(a.bits .+ b.bits)

grade(b::BasisElement{G}) where {G} = G
grade(b::Element) = grade(b.basis)

basis_index_in_grade(g, b::BasisElement{N}) where {N} = N

bits_from(ints...) = bits_from(SVector(ints))
function bits_from(ints::SVector{N}) where {N}
    res = @MVector(zeros(N))
    setindex!.(Ref(res), 1, ints)
    res
end

function grade_index(bits)
    grade = sum(bits)
    bits_bool = bits .== 1
    if grade == 0
        return 1
    elseif grade == 1
        return findfirst(bits_bool)
    else
        grade_index(bits[2:end]) + (first(bits) == 1 ? 0 : length(bits) -1)
    end
end

function bases(D)
    r = (0, 1)
    BasisElement.(SVector{2^D,Int}(i, j, k) for i = r, j = r, k = r)
end
