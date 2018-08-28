module MicrobiomePlots

using Microbiome
using RecipesBase
using StatPlots

export
    abundanceplot,
    annotationbar,
    zeroyplot

include("recipes.jl")

end
