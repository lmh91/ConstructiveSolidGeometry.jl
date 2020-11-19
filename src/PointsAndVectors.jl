abstract type AbstractCoordinatePoint{T, S} <: StaticArrays.FieldVector{3, T} end
abstract type AbstractCoordinateVector{T, S} <: StaticArrays.FieldVector{3, T} end


struct CartesianPoint{T} <: AbstractCoordinatePoint{T, Cartesian}
    x::T
    y::T
    z::T
end

@inline (*)(r::RotMatrix, p::CartesianPoint) = CartesianPoint(r.mat * p)

struct CartesianVector{T} <: AbstractCoordinateVector{T, Cartesian}
    x::T
    y::T
    z::T
end

struct CylindricalPoint{T} <: AbstractCoordinatePoint{T, Cylindrical}
    r::T
    φ::T
    z::T
end