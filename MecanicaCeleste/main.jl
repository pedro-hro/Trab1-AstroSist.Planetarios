include("src/MecanicaCeleste.jl")
using .MecanicaCeleste: resolver_questoes

# Executar todas as questões
function main()
    open("output.txt", "w") do file
        redirect_stdout(file) do
            resolver_questoes()
        end
    end
    println("Output salvo em 'output.txt'")
end

main()