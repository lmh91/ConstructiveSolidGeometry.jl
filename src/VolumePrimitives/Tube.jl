struct Tube{T} <: AbstractVolumePrimitive{T}
    r::T
    half_z::T
end

in(p::CartesianPoint, t::Tube) = 
    abs(p.z) <= t.half_z && sqrt(p.x^2 + p.y^2) <= t.r
