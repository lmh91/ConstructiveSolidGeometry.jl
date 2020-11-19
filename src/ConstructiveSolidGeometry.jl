module ConstructiveSolidGeometry

    # Base Packages
    using LinearAlgebra

    # Other Packages
    using StaticArrays
    using Rotations
    using ForwardDiff

    import Base: in, *
    
    abstract type AbstractCoordinateSystem end
    abstract type Cartesian <: AbstractCoordinateSystem end
    abstract type Cylindrical <: AbstractCoordinateSystem end

    abstract type AbstractGeometry{T} end 
    
    abstract type AbstractPrimitive{T} <: AbstractGeometry{T} end
    abstract type AbstractVolumePrimitive{T} <: AbstractPrimitive{T} end
    abstract type AbstractSurfacePrimitive{T} <: AbstractPrimitive{T} end
    abstract type AbstractLinePrimitive{T} <: AbstractPrimitive{T} end

    include("PointsAndVectors.jl")
    include("TranslationsAndRotations.jl")
    include("VolumePrimitives/VolumePrimitives.jl")



    # abstract type AbstractSet{T, IR, IT} <: AbstractGeometry{T, IR, IT} end   
    # include("Sets.jl")

end 
