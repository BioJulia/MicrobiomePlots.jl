using Documenter, MicrobiomePlots

makedocs(
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true"),
    sitename = "MicrobiomePlots.jl",
    pages = [
        "Home" => "index.md",
        "Recipes" => "recipes.md",
        "Contributing" => "contributing.md"
    ],
    authors = "Kevin Bonham, PhD"
)

deploydocs(
    repo = "github.com/BioJulia/MicrobiomePlots.jl.git",
    julia = "1.2",
    osname = "linux",
    target = "build",
    deps = nothing,
    make = nothing
)
