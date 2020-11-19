Base.convert(::Type{<:Blade{S,B,T}}, b::B) where {S,B,T} = Blade(one(T), b)
Base.convert(::Type{Multivector}, b::Blade) = Multivector(b)
Base.convert(::Type{<:Blade{S}}, n::Number) where {S} = scalar(n, S)
Base.convert(::Type{<:Blade{S}}, n::UnitBlade) where {S} = Blade(1, n)

Base.promote_rule(::Type{B}, T::Type{Blade{S,B}}) where {S,B} = T
Base.promote_rule(::Type{Blade{S}}, ::Type{Blade{S}}) where {S} = Multivector
Base.promote_rule(::Type{Blade{S,B,T}}, type::Type{Blade{S,B,T}}) where {S,B,T} = type
Base.promote_rule(::Type{<:UnitBlade{S}}, type::Type{<:Blade{S}}) where {S} = type
Base.promote_rule(::Type{<:Number}, ::Type{<:BladeLike{S}}) where {S} = Blade{S}
Base.promote_rule(::Type{<:Multivector}, ::Type{<:Blade}) = Multivector
