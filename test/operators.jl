@testset "Operators" begin
    include("operators/addition.jl")
    include("operators/geometric_product.jl")
    include("operators/outer_product.jl")
    include("operators/inner_product.jl")
    include("operators/inverse.jl")
    include("operators/promotions.jl")
end
