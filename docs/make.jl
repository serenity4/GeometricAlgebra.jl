using Documenter, GeometricAlgebra

makedocs(;
    modules=[GeometricAlgebra],
    format=Documenter.HTML(prettyurls = true),
    pages=[
        "Home" => "index.md",
        "Introduction" => "intro.md",
        "API" => 
            "api.md"
        ,
    ],
    repo="https://github.com/serenity4/GeometricAlgebra.jl/blob/{commit}{path}#L{line}",
    sitename="GeometricAlgebra.jl",
    authors="serenity4 <cedric.bel@hotmail.fr>",
)

deploydocs(
    repo = "github.com/serenity4/GeometricAlgebra.jl.git",
)
