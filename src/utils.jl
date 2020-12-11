"""
    @type_commutative 2 3 f(op, x::Type1, y::Type2) = ...

Wrap a method definition, resulting in the definition of another method
which uses the first when x and y are swapped.
"""
macro type_commutative(ix, iy, expr)
    additional_decl = deepcopy(expr)
    f_decl, f_body = additional_decl.args
    if f_decl.head == :where
        f_decl = first(f_decl.args)
    end
    
    f_args = @view f_decl.args[2:end]
    @assert length(f_args) >= 2 "The method must have at least two arguments"
    if isnothing(ix) || isnothing(iy)
        @assert length(f_args) == 2 "`ix` and `iy` must be provided for a method with more than 2 arguments"
        ix = 1
        iy = 2
    end
    f_args[ix], f_args[iy] = f_args[iy], f_args[ix]
    quote
        $(esc(expr))
        $(esc(additional_decl))
    end
end

macro type_commutative(expr) :(@type_commutative($nothing, $nothing, $expr)) end

"""
Return `val` as a subscript, used for printing `UnitBlade` and `Blade` instances.
"""
function subscript(val)
    r = div(val, 10)
    subscript_char(x) = Char(8320 + x)
    r > 0 ? string(subscript_char(r), subscript_char(mod(val, 10))) : string(subscript_char(val))
end
