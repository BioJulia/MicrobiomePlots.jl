@userplot AbundancePlot
@recipe function f(plt::AbundancePlot; topabund=10, srt=collect(1:nsites(plt.args[1])))
    abun = plt.args[1]
    typeof(abun) <: AbstractComMatrix || error("AbundancePlot not defined for $(typeof(abun))")

    topabund = min(topabund, nfeatures(abun))
    2 <= topabund < 12 || error("n must be between 2 and 12")

    top = filterabund(abun, topabund)

    rows = featurenames(top)

    yflip := true
    bar_position := :stack
    label := rows
    GroupedBar((1:nsamples(top), Matrix(occurrences(top)[:,srt]')))
end

"""
    AnnotationBar(::Array{<:Color,1})

Array of colors for plotting a grid. Use `plot(::AnnotationBar; kwargs...)`
"""
struct AnnotationBar
    colors::Array{<:Color,1}
end

"""
    annotationbar(colors::AbstractArray{<:Color,1})
    annotationbar(labels::AbstractArray{<:AbstractString,1})
    annotationbar(labels::AbstractArray{<:AbstractString,1}, colormap::Dict{<:AbstractString,<:Color})
    annotationbar(labels::AbstractArray{<:AbstractString,1}, colors::AbstractArray{<:Color,1})

Create an `AnnotationBar` from a vector of colors or a vector of `labels` (`String`s).
- A vector of `Color`s will be used directly to create an `AnnotationBar`
- For an array of `String`s, each unique value will be assigned a random color from
  `Colors.color_names`.
- A vector of labels may be passed with a `Dict` with keys for each `label` mapping
  to a `Color` value.
- A vector of `labels` and `colors` may be used.
    - If the lengths of these vectors are the same,
      the `colors` will be used to create an AnnotationBar
    - If the length of `labels` is longer than the length of `colors`,
      each unique label will be assigned to one of the `colors`
"""
annotationbar(colors::AbstractArray{<:Color,1}) = AnnotationBar(colors)

function annotationbar(labels::AbstractArray{<:AbstractString,1}, colormap::Dict{<:AbstractString,<:Color})
    colorkeys = keys(colormap)
    all(label-> in(label, colorkeys), labels) || throw(ArgumentError("Colormap missing keys $(setdiff(labels, colorkeys))"))
    AnnotationBar([colormap[label] for label in labels])
end


function annotationbar(labels::AbstractArray{<:AbstractString,1}, colors::AbstractArray{<:Color,1})
    if length(labels) == length(colors)
        return annotationbar(colors)
    end
    ulabels = unique(labels)
    length(colors) < length(ulabels) && throw(ArgumentError("Must have at least 1 color for each unique label"))
    colormap = Dict(l => colors[i] for (i, l) in enumerate(ulabels))
    annotationbar(labels, colormap)
end

# if no colors are passed, give a unique random color to each label
function annotationbar(labels::AbstractArray{<:AbstractString,1})
    ulabels = unique(labels)
    colors = rand(keys(Colors.color_names), length(ulabels))
    colormap = Dict(l => parse(Colorant, colors[i]) for (i, l) in enumerate(ulabels))
    annotationbar(labels, colormap)
end

@recipe function f(bar::AnnotationBar)
    xs = Int[]
    for i in 1:length(bar.colors)
        append!(xs, [0,0,1,1,0] .+ (i-1))
    end
    xs = reshape(xs, 5, length(bar.colors))
    ys = hcat([[0,1,1,0,0] for _ in bar.colors]...)

    fc = reshape(bar.colors, 1, length(bar.colors))


    seriestype := :path
    fill := (0,1)
    fillcolor := fc
    legend := false
    color --> :black
    ticks := false
    framestyle := false
    xaxis --> false
    yaxis --> false
    xs, ys
end


# From Michael K. Borregaard (posted to slack 2018-05-18)
# Usage:
#
# x = randn(100)
# y = randn(100) + 2
# y[y.<0] = 0
#
# zeroyplot(x,y, yscale = :log10, color = :red, markersize = 8)
# @userplot ZeroYPlot
# @recipe function f(h::ZeroYPlot)
#            length(h.args) != 2 && error("zeroyplot only defined for x and y input arguments")
#            x, y = h.args
#            val0 = y .== 0
#
#            layout := @layout([a
#                               b{0.05h}])
#
#            markeralpha --> 0.4
#            seriestype --> :scatter
#
#            @series begin
#                primary := false
#                subplot := 2
#                yscale := :identity
#                ylim := (-1,1)
#                yticks := ([0],[0])
#                grid := false
#                x[val0], y[val0]
#            end
#
#            subplot := 1
#            x[.!val0], y[.!val0]
# end
