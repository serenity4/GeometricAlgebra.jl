@testset "Promotion" begin
    @test promote_type(Blade{Ø,UnitBlade{Ø,0,()}}, UnitBlade{Ø,0,()}) == Blade{Ø,UnitBlade{Ø,0,()}}
end
