struct Tube{T} <: AbstractVolumePrimitive{T}
    r::T
    half_z::T
end

in(p::CartesianPoint, t::Tube) = 
    abs(p.z) <= t.half_z && p.x^2 + p.y^2 <= t.r^2



### BETA

function distance_to_surface(p::CartesianPoint, t::Tube)
    # there is probably be a much better implementation for this...
    r = sqrt(p[1]^2 + p[2]^2)
    d_top = if r <= t.r
        abs(t.half_z - p[3])
    else
        sqrt((t.half_z - p[3])^2 + (r - t.r)^2)
    end
    d_bot = if r <= t.r
        abs(p[3] + t.half_z)
    else
        sqrt((p[3] + t.half_z)^2 + (r - t.r)^2)
    end
    d_mantle = if p[3] > t.half_z
        sqrt((r - t.r)^2 + (p[3] - t.half_z)^2)
    elseif p[3] < -t.half_z
        sqrt((r - t.r)^2 + (p[3] + t.half_z)^2)
    else
        abs(r - t.r)
    end
    min(d_top, d_bot, d_mantle)
end

