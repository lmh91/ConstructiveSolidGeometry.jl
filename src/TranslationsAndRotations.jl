struct StrechedPrimitive{T,P<:AbstractVolumePrimitive{T}} <: AbstractPrimitive{T}
    p::P
    inv_s::SVector{3,T}
    StrechedPrimitive(p::P, s::SVector{3,T}) where {T,P} = new{T,P}(p, inv.(s))
end
@inline in(p::CartesianPoint, sp::StrechedPrimitive) = in(CartesianPoint(sp.inv_s .* p), sp.p)

struct RotatedPrimitive{T,P<:Union{AbstractVolumePrimitive{T},StrechedPrimitive{T}},RT} <: AbstractPrimitive{T}
    p::P
    r::RotMatrix{3,RT,9}
end
@inline in(p::CartesianPoint, rp::RotatedPrimitive) = in(rp.r * p, rp.p)

struct TranslatedPrimitive{T,P<:AbstractPrimitive{T}} <: AbstractPrimitive{T}
    p::P
    t::CartesianVector{T}
end
@inline in(p::CartesianPoint, tp::TranslatedPrimitive) = in(p - tp.t, tp.p)



### BETA 

distance_to_surface(p::CartesianPoint, sp::StrechedPrimitive)   = distance_to_surface(CartesianPoint(sp.inv_s .* p), sp.p)
distance_to_surface(p::CartesianPoint, rp::RotatedPrimitive)    = distance_to_surface(rp.r * p, rp.p)
distance_to_surface(p::CartesianPoint, tp::TranslatedPrimitive) = distance_to_surface(p - tp.t, tp.p)

function direction_to_nearest_surface(p::CartesianPoint{T}, g::AbstractGeometry{T}) where {T}
    grad = x -> ForwardDiff.gradient(x -> -distance_to_surface(CartesianPoint(x), g), x); # g = ∇f
    CartesianVector(grad(T[p.x,p.y,p.z]))
end
