include("src/MecanicaCeleste.jl")

using .MecanicaCeleste
using Plots

# Função para gerar os dados em LaTeX
function main()
	generate_latex_data()
end

main()