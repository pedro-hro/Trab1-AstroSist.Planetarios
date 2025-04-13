include("tipos.jl")

function calcular(elemento::ElementoOrbital, t)
    return elemento.valor_base + elemento.taxa * t
end

# 0.1) Cálculo do tempo com referência em 0h UT de 1 de janeiro de 2000
function tempo(d, m, y, h, min)
    t = (367*y-(floor(7*(y+(floor((m+9)/12)))/4))+floor(275*m/9)+d-730530) + h/24 + min/(24*60)   
    return round(t, digits=3) 
end

# 0.3) Cálculo da anomalia excêntrica
function anomalia_excentrica(planeta::Planeta, t)
    # Calcular anomalia média para o tempo t (em graus)
    M_graus = calcular(planeta.M, t)
    
    # Calcular excentricidade para o tempo t
    e = calcular(planeta.e, t)
    
    # Converter anomalia média para radianos para os cálculos trigonométricos
    M_rad = M_graus * (π/180)
    
    # Valor inicial: E = M (boa aproximação inicial para órbitas pouco excêntricas)
    E_aprox = M_rad
    
    # Iteração
    while true
        delta_E = (M_rad - E_aprox + e * sin(E_aprox)) / (1 - e * cos(E_aprox))
        E = E_aprox + delta_E
        if abs(delta_E) < 5e-6
            return E * (180/π)
        else 
            E_aprox = E
        end
    end
end

# 0.4) Cálculo da anomalia verdadeira
function anomalia_verdadeira(planeta::Planeta, t)
    E = anomalia_excentrica(planeta, t) * (π/180)  # Converter para radianos
    e = calcular(planeta.e, t)

    # Calcular anomalia verdadeira
    v = 2 * atan(sqrt((1 + e) / (1 - e)) * tan(E / 2))
    v_deg = mod(v * (180/π), 360)  # Converter para graus e garantir que esteja entre 0 e 360

    return v_deg
end

# 0.5) Cálculo da Distância do Planeta ao Sol
function distancia_sol(planeta::Planeta, t)
    # Calcular anomalia verdadeira
    v = anomalia_verdadeira(planeta, t)
    
    # Calcular semi-eixo maior
    a = planeta.a

    # Calcular excentricidade
    e = calcular(planeta.e, t)
    
    # Converter anomalia verdadeira para radianos
    v_rad = v * (π/180)
    # Calcular distância do Sol
    r = a*(1-e^2)/(1+e*cos(v_rad))
    return r
end

# 0.6) Cálculo das coordenadas cartesianas
function coordenadas(planeta::Planeta, t)
    r = distancia_sol(planeta, t)
    v = anomalia_verdadeira(planeta, t) * (π/180)
    i = calcular(planeta.i, t) * (π/180)
    w = calcular(planeta.w, t) * (π/180)
    omega = calcular(planeta.omega, t) * (π/180)
    x = r * (cos(omega) * cos(w + v) - sin(omega) * sin(w + v) * cos(i))
    y = r * (sin(omega) * cos(w + v) + cos(omega) * sin(w + v) * cos(i))
    z = r * (sin(w + v) * sin(i))
    return (x, y, z)
end

# 0.7) Coordenadas Eclipticas Heliocentricas
function coordenadasEclipticas(planeta::Planeta, t)
    x, y, z = coordenadas(planeta, t)
    l = atan(y/x) * (180/π)
    b = atan(z/sqrt(x^2 + y^2)) * (180/π)
    
    l = mod(l, 360)

    return (l, b)
end

# 0.8) Calcular o baricentro do sistema solar
function calcular_baricentro(sistema::Vector{Planeta}, t::Float64)
    X_0, Y_0, Z_0 = 0.0, 0.0, 0.0
    
    M_Tot = sum(planeta.massa for planeta in sistema)
    
    X_cm, Y_cm, Z_cm = 0.0, 0.0, 0.0
    
    for planeta in sistema
        if planeta.nome != "Sol"
            x, y, z = coordenadas(planeta, t)
            
            X_cm += (planeta.massa / M_Tot) * x
            Y_cm += (planeta.massa / M_Tot) * y
            Z_cm += (planeta.massa / M_Tot) * z
        end
    end
    
    return X_cm, Y_cm, Z_cm, M_Tot
end

function baricentro_dentro_sol(X_cm::Float64, Y_cm::Float64, Z_cm::Float64)
    R_sol_km = 696340.0  # Raio do Sol em km
    
    delta_km = sqrt(X_cm^2 + Y_cm^2 + Z_cm^2) * 149597870.7  # Distância em km
    
    delta = delta_km / R_sol_km  # Razão entre distância e raio
    
    return delta <= 1.0, delta
end