module timeprop
1
2
function perform_timeprop(F::Function, tmax::Float64, x0::Float64, v0::Float64, h::Float64)::Tuple{Float64, Float64}
    if tmax <= 0.0
        error("tmax must be positive")
    end
    if h <= 0.0
        error("h must be positive")
    end

    x::Float64 = x0
    v::Float64 = v0
    t::Float64 = 0.0
    while t < tmax
        v = v + h * F(x, t)
        x = x + h * v
        t = t + h
    end
    return (x, v)
end

end