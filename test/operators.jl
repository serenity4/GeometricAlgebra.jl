@testset "Operators" begin
    include("operators/addition.jl")
    include("operators/geometric_product.jl")
    include("operators/reverse.jl")
    include("operators/outer_product.jl")
    include("operators/inner_product.jl")
    include("operators/scalar_product.jl")
    include("operators/inverse.jl")
    include("operators/promotions.jl")
    include("operators/projections.jl")
    include("operators/magnitude.jl")
    include("operators/dual.jl")
    include("operators/regressive_product.jl")
end
