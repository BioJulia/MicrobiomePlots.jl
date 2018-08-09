using Microbiome
using Test

@testset "Abundances" begin
    # Constructors
    M = rand(100, 10)

    abund = abundancetable(
        M, ["sample_$x" for x in 1:10],
        ["feature_$x" for x in 1:100])


# Plotting - not working on 0.7
    @test_skip typeof(abundanceplot(abund, topabund=5)) <: Plots.Plot
    @test_skip typeof(abundanceplot(abund, sorton=:hclust)) <: Plots.Plot
    @test_skip typeof(abundanceplot(abund, sorton=:x1)) <: Plots.Plot # Needs method feature sorting

    @test_skip typeof(annotationbar(parse.(Color, ["red", "white", "blue"]))) <: Plots.Plot
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
    # Plotting - not working on 0.7
    @test_skip typeof(plot(p)) <: Plots.Plot
    @test_skip typeof(plot(p)) <: Plots.Plot
end
