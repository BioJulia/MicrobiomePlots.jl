using Documenter, Microbiome

makedocs(
    format = :html,
    sitename = "MicrobiomePlots.jl",
    pages = [
        "Home" => "index.md",
        "Recipes" => "recipes.md"
        "Contributing" => "contributing.md"
    ],
    authors = "Kevin Bonham, PhD"
)

deploydocs(
    repo = "github.com/BioJulia/Microbiome.jl.git",
    julia = "1.0",
    osname = "linux",
    target = "build",
    deps = nothing,
    make = nothing
)
