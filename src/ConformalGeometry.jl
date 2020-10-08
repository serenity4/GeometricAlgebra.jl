module ConformalGeometry

abstract type _Node{T} end
abstract type NullNode{T} <: _Node{T} end

# struct MultivectorNode{T, L <: _Node} <: _Node
#     left::L{T}
#     right::L{T}
#     value::T
# end

function one_level_outer_product(list, bit::Val{false})
    add_bit_list(list, false)
end

function one_level_outer_product(list, bit::Val{true})
    add_bit_list(list, true, false)
end

function add_bit_list(list, bit)
    isempty(list) && return [[bit]]
    list_res = []
    foreach(list) do label
        push!(list_res, vcat(label, bit))
    end
    list_res
end

function add_bit_list(list, bit_1, bit_2)
    isempty(list) && return [[bit_1], [bit_2]]
    list_res = []
    foreach(list) do label
        push!(list_res, vcat(label, bit_1))
        push!(list_res, vcat(label, bit_2))
    end
    list_res
end

function sign_outer!(signs, current_sign, comp, depth, d)
    if depth == d
        push!(signs, current_sign)
    else
        sign_outer!(signs, current_sign == comp, comp, depth+1, d)
        sign_outer!(signs, current_sign, !comp, depth+1, d)
    end
end

function per_grade_outer_product(sign, a, b, list_a, ck, grade, d, label_n_ones, depth)
    if label_n_ones == grade
        for (i, u) ∈ enumerate(list_a)
            v = copy(u)
            @views v[1:(d-depth)] = .!(v[1:(d-depth)])
            ck += sign[i] * a[v] * b[.!(u)]
        end
    else
        list = BitVector()
        depth += 1
        if depth ≠ d
            push!(list, one_level_outer_product!(list_a, Val{true}))
            # to finish
        end

    end
end

# 1 goes to left, 0 goes to right
binary_tree_index(label) = binary_tree_index(0, label)
binary_tree_index(index, label::Nothing) = index + 1
function binary_tree_index(index, label)
    bit = first(label)
    index = 2*index + !bit
    binary_tree_index(index, length(label) == 1 ? nothing : label[2:end])
end

apply_sign(a, sign::Val{true}) = a
apply_sign(a, sign::Val{false}) = -a

function coef_outer_product_labels(label)
    list_a = []
    foreach(label) do bit
        list_a = one_level_outer_product(list_a, Val(bit))
    end
    list_a
end

function coef_outer_product(a, b, label)
    d = sum(label)
    signs = BitVector()
    sign_outer!(signs, true, true, 0, d)
    list_a = coef_outer_product_labels(label)
    ck = zero(eltype(a))
    for (i, (label, label_rev)) ∈ enumerate(zip(list_a, reverse(list_a)))
        la = binary_tree_index(label)
        lb = binary_tree_index(label_rev)
        sign = signs[i] ? "+" : "-"
        # println("$sign a$(2^3 - la) * b$(2^3 - lb) ($label, $label_rev)")
        ck += apply_sign(a[la] * b[lb], Val(signs[i]))
    end
    ck
end

export one_level_outer_product,
       coef_outer_product,
       sign_outer!,
       binary_tree_index,
       coef_outer_product_labels

end

