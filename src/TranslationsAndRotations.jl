struct StrechedPrimitive{T,P<:AbstractVolumePrimitive{T}} <: AbstractPrimitive{T}
    p::P
    inv_s::SVector{3,T}
    StrechedPrimitive(p::P, s::SVector{3,T}) where {T,P} = new{T,P}(p, inv.(s))
end
@inline in(p::CartesianPoint, rp::StrechedPrimitive) = in(CartesianPoint(rp.inv_s .* p), rp.p)

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
