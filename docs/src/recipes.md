# Recipes Docs

## Abundances

Some convenience plotting types are available using
[MicrobiomePlots](https://github.com/BioJulia/MicrobiomePlots.jl),
Which also re-exports everything in [StatsPlots](https://github.com/juliaplots/StatsPlots.jl)

```@example 1
ENV["GKSwstype"] = "100" # hide
using Microbiome
using MicrobiomePlots
using Distributions
using Random # hide
Random.seed!(1) # hide

# add some high abundance bugs to be a bit more realistic
function spikein(spikes, y, x)
    m = rand(LogNormal(), y, x)
    for s in spikes
        m[s, :] = rand(LogNormal(3., 0.5), x)'
    end
    return m
end

# 100 species in 10 samples, with every 10th bug a bit more abundant
bugs = spikein(1:10:100, 100, 10)

abund = abundancetable(bugs,
    ["sample_$x" for x in 1:10],
    ["species_$x" for x in 1:100]);

relativeabundance!(abund)
abundanceplot(abund, xticks=(1:10, samplenames(abund)), xrotation=45)
```

## Metadata

Perhaps you have some metadata that you'd like to add as well:

```@example 1
labels = ["a","a","b","a","b","b","b","b","a","a"]

plot(
    abundanceplot(abund, xticks=(1:10, samplenames(abund)), xrotation=45),
    plot(annotationbar(labels)),
    layout=grid(2,1, heights=[0.9,0.1]))
```

## Distances

To plot this, use the `MDS` or `PCA` implementations
from [MultivariateStats](https://github.com/JuliaStats/MultivariateStats.jl)
and plotting functionality
from [StatsPlots](https://github.com/JuliaPlots/StatsPlots.jl).

```@example 1
using MultivariateStats
using Distances

# Note - one [SpatialEcology #36](https://github.com/EcoJulia/SpatialEcology.jl/pull/36)
# is released, one will be able to do `pairwise(BrayCurtis(), abund)` directly
dm = pairwise(BrayCurtis(), occurrences(abund))

mds = fit(MDS, dm, distances=true)

plot(mds)
```

### Optimal Leaf Ordering

I also wrote a plotting recipe for making treeplots for `Hclust` objects
from the [`Clustering.jl`](http://github.com/JuliaStats/Clustering.jl) package,
and the recipe for plotting
was [moved into](https://github.com/JuliaPlots/StatsPlots.jl#dendrograms) StatsPlots:

```@example 2
using Clustering
using Distances
using MicrobiomePlots
using Random

n = 40

mat = zeros(Int, n, n)
# create banded matrix
for i in 1:n
    last = minimum([i+Int(floor(n/5)), n])
    for j in i:last
        mat[i,j] = 1
    end
end

# randomize order
mat = mat[:, randperm(n)]
dm = pairwise(Euclidean(), mat, dims=2)

# normal ordering
hcl1 = hclust(dm, linkage=:average)
plot(
    plot(hcl1, xticks=false),
    heatmap(mat[:, hcl1.order], colorbar=false, xticks=(1:n, ["$i" for i in hcl1.order])),
    layout=grid(2,1, heights=[0.2,0.8])
    )
```

Compare to:

```@example 2
# optimal ordering
hcl2 = hclust(dm, linkage=:average, branchorder=:optimal)
plot(
    plot(hcl2, xticks=false),
    heatmap(mat[:, hcl2.order], colorbar=false, xticks=(1:n, ["$i" for i in hcl2.order])),
    layout=grid(2,1, heights=[0.2,0.8])
    )
```


```@autodocs
Modules = [MicrobiomePlots]
Private = false
```
