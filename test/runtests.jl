using Microbiome
using MicrobiomePlots
using StatsPlots
using Plots
using Colors
using Random
using Test

@testset "Abundances" begin
Random.seed!(1)
    M = rand(100, 10)

    abund = abundancetable(
        M, ["sample_$x" for x in 1:10],
        ["feature_$x" for x in 1:100])


    @test typeof(abundanceplot(abund, topabund=5)) <: Plots.Plot
    @test typeof(abundanceplot(abund, srt=collect(10:-1:1))) <: Plots.Plot

    @test_skip typeof(abundanceplot(abund, srt=:feature_1)) <: Plots.Plot # Needs method feature sorting

    ann = annotationbar(parse.(Color, ["red", "white", "blue"]))

    @test typeof(plot(ann)) <: Plots.Plot
end
