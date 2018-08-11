using Microbiome
using StatPlots
using Test

@testset "Abundances" begin
    # Constructors
    M = rand(100, 10)

    abund = abundancetable(
        M, ["sample_$x" for x in 1:10],
        ["feature_$x" for x in 1:100])


    @test typeof(abundanceplot(abund, topabund=5)) <: Plots.Plot
    @test typeof(abundanceplot(abund, sorton=:hclust)) <: Plots.Plot
    @test typeof(abundanceplot(abund, sorton=:x1)) <: Plots.Plot # Needs method feature sorting

    @test typeof(annotationbar(parse.(Color, ["red", "white", "blue"]))) <: Plots.Plot
end

@testset "Distances" begin
    srand(1)
    M = rand(100, 10)
    abund = abundancetable(
        M, ["sample_$x" for x in 1:10],
        ["feature_$x" for x in 1:100])

    dm = getdm(abund, BrayCurtis())
    # PCoA
    p = pcoa(dm, correct_neg=true)
    @test typeof(plot(p)) <: Plots.Plot
    @test typeof(plot(p)) <: Plots.Plot
end
