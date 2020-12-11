Base.convert(::Type{<:Blade{S,B,T}}, b::B) where {S,B,T} = Blade(one(T), b)
Base.convert(::Type{Multivector{S}}, b::Blade{S,B,T}) where {S,B,T} = convert(Multivector{S,T}, b)
Base.convert(T::Type{<:Number}, b::ScalarBlade) = b.coef
Base.convert(::Type{<:Blade{S}}, n::Number) where {S} = scalar(n, S)
Base.convert(T::Type{<:Blade{S}}, b::UnitBlade{S}) where {S} = Blade(one(eltype(T)), b)

function Base.convert(::Type{Multivector{S,T}}, b::Blade{S}) where {S,T,B}
    coefs = @SVector zeros(T, 2^dimension(S))
    Multivector{S}(setindex(coefs, b.coef, linear_index(b)))
end

Base.convert(T::Type{<:Multivector}, b::UnitBlade) = convert(T, convert(Blade{signature(T), typeof(b), eltype(T)}, b))
Base.convert(T::Type{<:Multivector}, b::Number) = convert(T, convert(ScalarBlade{signature(T), eltype(T)}, b))

Base.promote_rule(::Type{B}, T::Type{Blade{S,B}}) where {S,B} = T
Base.promote_rule(::Type{B}, ::Type{B}) where {B<:UnitBlade} = Blade{signature(B),B}
Base.promote_rule(::Type{<:UnitBlade{S}}, ::Type{<:UnitBlade{S}}) where {S} = Multivector{S}
Base.promote_rule(::Type{<:Blade{S,B,T1}}, ::Type{<:Blade{S,B,T2}}) where {S,B,T1,T2} = Blade{S,B,promote_type(T1, T2)}
Base.promote_rule(::Type{<:Blade{S,B,T}}, T2::Type{<:Blade{S,B,T}}) where {S,B,T} = Multivector{S, T}
Base.promote_rule(::Type{B}, T::Type{<:Blade{S,B}}) where {S,B<:UnitBlade{S}} = T
Base.promote_rule(::Type{<:UnitBlade}, ::Type{<:Blade{S,B,T}}) where {S,B,T} = Multivector{S,T}
Base.promote_rule(N::Type{<:Number}, T::Type{<:UnitBlade{S}}) where {S} = promote_rule(T, ScalarBlade{S,N})
Base.promote_rule(N::Type{<:Number}, T::Type{<:Blade{S}}) where {S} = promote_rule(T, ScalarBlade{S, promote_type(N, eltype(T))})
Base.promote_rule(::Type{<:Multivector{S,T1}}, ::Type{<:Blade{S,B,T2}}) where {S,B,T1,T2} = Multivector{S,promote_type(T1, T2)}

function mul_promote_single(x, S)
    R = mul_promote_type(typeof(x), S)
    convert(R, x)
end

mul_promote_single(x::Zero, _) = x
mul_promote_single(x::Blade, _) = x
mul_promote_single(x::Multivector, _) = x

function mul_promote(x, y)
    _x = mul_promote_single(x, typeof(y))
    _y = mul_promote_single(y, typeof(x))
    _x, _y
end

mul_promote_type(T, S) = error("No promotion rule for $T with $S")
mul_promote_type(N::Type{<:Number}, ::Type{<:Union{<:Blade{S,<:UnitBlade,T}, <:Multivector{S,T}}}) where {S,T} = ScalarBlade{S,promote_type(N, T)}
mul_promote_type(N::Type{<:Number}, ::Type{<:UnitBlade{S}}) where {S} = ScalarBlade{S,N}
mul_promote_type(B::Type{<:UnitBlade}, ::Type{<:Union{N,Blade{S,_B,N},Multivector{S,N}}}) where {N<:Number,S,_B} = Blade{signature(B), B, N}
