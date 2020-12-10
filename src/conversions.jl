Base.convert(::Type{<:Blade{S,B,T}}, b::B) where {S,B,T} = Blade(one(T), b)

function Base.convert(::Type{Multivector{S,T}}, b::Blade{S}) where {S,T,B}
    coefs = @SVector zeros(T, 2^dimension(S))
    Multivector{S}(setindex(coefs, b.coef, linear_index(b)))
end

Base.convert(::Type{Multivector{S}}, b::Blade{S,B,T}) where {S,B,T} = convert(Multivector{S,T}, b)
Base.convert(::Type{T}, b::Blade{S,<:UnitBlade{S,0,()},T}) where {S, T} = b.coef

Base.convert(::Type{<:Blade{S}}, n::Number) where {S} = scalar(n, S)
Base.convert(::Type{<:Blade{S}}, n::UnitBlade) where {S} = Blade(1, n)

Base.promote_rule(::Type{B}, T::Type{Blade{S,B}}) where {S,B} = T
Base.promote_rule(::Type{Blade{S}}, ::Type{Blade{S}}) where {S} = Multivector{S}
Base.promote_rule(::Type{Blade{S,B,T1}}, type::Type{Blade{S,B,T2}}) where {S,B,T1,T2} = Blade{S,B,promote_type(T1, T2)}
Base.promote_rule(::Type{<:UnitBlade{S}}, type::Type{<:Blade{S}}) where {S} = type
Base.promote_rule(::Type{<:Number}, ::Type{<:BladeLike{S}}) where {S} = Blade{S}
Base.promote_rule(::Type{<:Multivector{S,T1}}, ::Type{<:Blade{S,B,T2}}) where {S,B,T1,T2} = Multivector{S,promote_type(T1, T2)}
Base.promote_rule(::Type{T}, ::Type{Blade{S,<:UnitBlade{S,0,()},T}}) where {S, T} = T
