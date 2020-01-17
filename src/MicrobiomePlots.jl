module MicrobiomePlots

using Microbiome
using RecipesBase
using Colors
using Reexport
using Random
@reexport using StatsPlots

export
    abundanceplot,
    AnnotationBar,
    annotationbar
    # zeroyplot

include("recipes.jl")

end
