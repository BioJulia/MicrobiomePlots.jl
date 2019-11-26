# Recipes Docs

```@autodocs
Modules = [MicrobiomePlots]
Private = false
```

## Abundances

Some convenience plotting types are available using
[MicrobiomePlots](https://github.com/BioJulia/MicrobiomePlots.jl)
and [StatsPlots](https://github.com/juliaplots/StatsPlots.jl)

```@example 1
ENV["GKSwstype"] = "100" # hide
using StatsPlots
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

savefig("abundanceplot.png"); nothing # hide
```

![abundance plot](./abundanceplot.png)

## Metadata

Perhaps you have some metadata that you'd like to add as well:

```@example 1
labels = ["a","a","b","a","b","b","b","b","a","a"]

plot(
    abundanceplot(abund, xticks=(1:10, samplenames(abund)), xrotation=45),
    plot(annotationbar(labels)),
    layout=grid(2,1, heights=[0.9,0.1]))

savefig("abundanceplot-annotations.png"); nothing # hide
```

![abundance plot with annotations](./abundanceplot-annotations.png)

## Distances

To plot this, use the `MDS` or `PCA` implementations
from [MultivariateStats](https://github.com/JuliaStats/MultivariateStats.jl) [^1]
and plotting functionality
from [StatsPlots](https://github.com/JuliaPlots/StatsPlots.jl)[^2].

```@example 2
using MultivariateStats
using StatsPlots

mds = fit(MDS, dm, distances=true)

plot(mds)

savefig("mds.png"); nothing # hide
```

![mds plot](./mds.png)

### Optimal Leaf Ordering

I also wrote a plotting recipe for making treeplots for `Hclust` objects
from the [`Clustering.jl`](http://github.com/JuliaStats/Clustering.jl) package,
and the recipe for plotting was moved into StatsPlots:

```@example 2
using Clustering

dm = [0. .1 .2
      .1 0. .15
      .2 .15 0.];

h = hclust(dm, linkage=:single);

plot(h)
savefig("hclustplot1.png"); nothing # hide
```

![hclust plot 1](./hclustplot1.png)

Note that even though this is a valid tree, the leaf `a` is closer to leaf `c`,
despite the fact that `c` is more similar to `b` than to `a`. This can be fixed
with a method derived from the paper:

[Bar-Joseph et. al. "Fast optimal leaf ordering for hierarchical clustering." _Bioinformatics_. (2001)](https://doi.org/10.1093/bioinformatics/17.suppl_1.S22)[^3]

```@example 2
h2 = hclust(dm, linkage=:single, branchorder=:optimal);

plot(h2)

savefig("hclustplot2.png"); nothing # hide
```

![hclust plot 1](./hclustplot2.png)

[^1]: Requires https://github.com/JuliaStats/MultivariateStats.jl/pull/85
[^2]: Requires https://github.com/JuliaPlots/StatsPlots.jl/pull/152
[^3]: Requires https://github.com/JuliaStats/Clustering.jl/pull/170
