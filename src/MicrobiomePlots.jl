module MicrobiomePlots

using Microbiome
using RecipesBase
using Colors
using Reexport
@reexport using StatsPlots

export
    abundanceplot,
    AnnotationBar,
    annotationbar
    # zeroyplot

include("recipes.jl")

end
