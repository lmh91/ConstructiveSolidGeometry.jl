using Test
using ConstructiveSolidGeometry
using BenchmarkTools
using LinearAlgebra
using Rotations
using Unitful
using StaticArrays
using Plots

using ConstructiveSolidGeometry: 
    CartesianPoint, CartesianVector,
    StrechedPrimitive, RotatedPrimitive, TranslatedPrimitive,
    Tube, 
    distance_to_surface, direction_to_nearest_surface


T = Float64

@testset "Points" begin
    cp1 = CartesianPoint{T}(1, 2, 3)
    @test cp1 + cp1 == CartesianPoint{T}(2, 4, 6)
    @test cp1 - cp1 == CartesianPoint{T}(0, 0, 0)
    @test cp1 ⋅ cp1 == 14
    @test norm(cp1) == sqrt(14)
end


@testset "Volume Primitives" begin
    @testset "Tube" begin
        tube = Tube(0.2, 1.0) # r = 1, half_z = 1 -> h = 2 
        @test CartesianPoint{T}(0, 0, 0) in tube
        @test CartesianPoint{T}(tube.r, 0, tube.half_z) in tube
        @test !(CartesianPoint{T}(tube.r, 0, 1.1*tube.half_z) in tube) 
        @test !(CartesianPoint{T}(1.1*tube.r, 0, tube.half_z) in tube) 
    end
end

begin
    tube = Tube(1.0, 1.0) # r = 1, half_z = 1 -> h = 2 
    cp1 = CartesianPoint{T}(0.2, 0, 0.95) 
    
    distance_to_surface(cp1, tube)

    direction_to_nearest_surface(cp1, tube)
    
    streched_tube = StrechedPrimitive(tube, SVector(1.0, 3.0, 10.0))
    direction_to_nearest_surface(cp1, streched_tube)
    
    rot_tube = RotatedPrimitive(tube, RotMatrix(RotX(deg2rad(90))))
    direction_to_nearest_surface(cp1, rot_tube)
end




@testset "Streching - Rotation - Translation" begin 
    rot = RotX(deg2rad(90))
    t = CartesianVector{T}(2, 0, 0 )
    streching = SVector(1.0, 3.0, 1.0)

    tube = Tube(0.2, 1.0) # r = 1, half_z = 1 -> h = 2 

    streched_tube = StrechedPrimitive(tube, streching)
    rot_tube = RotatedPrimitive(tube, RotMatrix(rot))
    translated_tube = TranslatedPrimitive(tube, t)
    translated_rotated_tube = TranslatedPrimitive(rot_tube, t)
    rot_streched_tube =  RotatedPrimitive(streched_tube, RotMatrix(rot))
    translated_rot_streched_tube = TranslatedPrimitive(rot_streched_tube, t)

    cp1 = CartesianPoint{T}(0, 0, 1)
    
    @test (cp1 in tube)
    @test cp1 in streched_tube
    @test !(cp1 in rot_tube) 
    @test !(cp1 in rot_streched_tube)
    @test !(cp1 in translated_tube) 
    @test !(cp1 in translated_rotated_tube) 
    @test !(cp1 in translated_rot_streched_tube)
end
    
rot = RotX(deg2rad(90))
t = CartesianVector{T}(1, 0, 0 )
tube = Tube(0.2, 1.0) # r = 1, half_z = 1 -> h = 2 
streching = SVector(1.0, 3.0, 1.0)
streched_tube = StrechedPrimitive(tube, streching)
rot_tube = RotatedPrimitive(tube, RotMatrix(rot))
translated_tube = TranslatedPrimitive(tube, t)
translated_rotated_tube = TranslatedPrimitive(rot_tube, t)
rot_streched_tube =  RotatedPrimitive(streched_tube, RotMatrix(rot))
translated_rot_streched_tube = TranslatedPrimitive(rot_streched_tube, t)
cp1 = CartesianPoint{T}(0, 0, 1)

@code_warntype cp1 in tube
@code_warntype cp1 in streched_tube
@code_warntype cp1 in rot_tube
@code_warntype cp1 in rot_streched_tube
@code_warntype cp1 in translated_tube
@code_warntype cp1 in translated_rotated_tube
@code_warntype cp1 in translated_rot_streched_tube

@btime cp1 in translated_rot_streched_tube


begin
    plts = []
    for p in [  
                tube, 
                streched_tube, 
                rot_tube, 
                rot_streched_tube, 
                translated_tube, 
                translated_rotated_tube ,
                translated_rot_streched_tube,
            ]
        xs = T[]
        ys = T[]
        zs = T[]
        for x in -2:0.05:2
            for y in -2:0.05:2
                for z in -2:0.05:2
                    if CartesianPoint{T}(x, y, z) in p
                        push!(xs, x)
                        push!(ys, y)
                        push!(zs, z)
                    end
                end
            end
        end
        push!(plts, plot3d(xs, ys, zs, st=:scatter, ms = 2, markerstrokewidth = 0,
                            xlims = (-2,2), ylims = (-2,2), zlims = (-2,2)))
    end
    plot(plts..., size = (1200,1200))
end