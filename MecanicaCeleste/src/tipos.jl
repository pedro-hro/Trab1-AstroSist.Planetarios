# Elementos orbitais para o sistema solar
export ElementoOrbital, Planeta

struct ElementoOrbital
    valor_base :: Float64
    taxa :: Float64
end

struct Planeta
    nome :: String
    omega :: ElementoOrbital
    i :: ElementoOrbital
    w :: ElementoOrbital
    a :: Float64
    e :: ElementoOrbital
    M :: ElementoOrbital
    massa :: Float64
end