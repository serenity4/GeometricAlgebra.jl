module ConformalGeometry

function one_level_outer_product!(list, bit::Val{1})
    push!(list, 0)
    push!(list, 1)
end

function one_level_outer_product!(list, bit::Val{0})
    push!(list, 0)
end

end
