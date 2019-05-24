module MicrobiomePlots

using Microbiome
using RecipesBase
using Colors
import StatsPlots: GroupedBar

export
    abundanceplot,
    AnnotationBar,
    annotationbar
    # zeroyplot

include("recipes.jl")

end
