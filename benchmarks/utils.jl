# All these functions were borrowed from the
# unregistered package LocalScopeBenchmarks.jl

function collect_symbols(expr)
    assignments = OrderedDict{Symbol, Expr}()
    prewalk(expr) do x
        if x isa Symbol
            assignments[x] = Expr(:$, x)
            return nothing
        elseif x isa Expr && x.head == :$
            # Don't recurse inside $() interpolations,
            # since those will already be interpolated
            return nothing
        else
            return x
        end
    end
    assignments
end

function parse_setup(setup::Expr)
    assignments = OrderedDict()
    postwalk(setup) do x
        if @capture(x, a_ = b_)
            assignments[a] = b
        end
        x
    end
    assignments
end

function lower_setup(assignments::AbstractDict)
    Expr(:block, [Expr(:(=), k, v) for (k, v) in assignments]...)
end

function parse_params(kwargs)
    params_dict = OrderedDict((@assert x.head == :kw; x.args[1] => x.args[2]) for x in kwargs)
end

function lower_params(params::AbstractDict)
    [Expr(:kw, k, v) for (k, v) in params]
end

function interpolate_locals_into_setup(args...)
    core, kwargs = BenchmarkTools.prunekwargs(args...)
    params = parse_params(kwargs)
    setup_assignments = parse_setup(get(() -> Expr(:block), params, :setup))
    local_assignments = collect_symbols(core)
    setup = merge(local_assignments, setup_assignments)
    params[:setup] = lower_setup(setup)
    core, lower_params(params)
end

macro localbenchmark(args...)
    core, params = interpolate_locals_into_setup(args...)
    quote
        BenchmarkTools.@benchmark(Ref($(core))[], $(params...))
    end
end
