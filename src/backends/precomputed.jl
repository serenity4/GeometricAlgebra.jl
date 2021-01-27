function geom(x::Blade, y::Blade)
    i, ρ = TABLE[x.index, y.index]
    Blade(ρ * x.coef * y.coef, i)
end
