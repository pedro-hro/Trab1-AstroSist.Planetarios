module MecanicaCeleste
export resolver_questoes

    include("tipos.jl")
    include("dados_planetas.jl")
    include("calculos.jl")

    # Função principal para executar todas as questões
    function resolver_questoes()
        t = tempo(6, 8, 2070, 20, 45)
    
        planetas = [mercurio, venus, terra, marte, jupiter, saturno, urano, netuno]
        sistema_solar = [sol, mercurio, venus, terra, marte, jupiter, saturno, urano, netuno]
        data_hora = "06/08/2070 - 20:45"
    
        # Exibir resultado da Questão 1
        println("\n### Questão 1: Cálculo do tempo desde 01/01/2000 ###")
        println("Data atribuída: $data_hora")
        println("Tempo decorrido desde 01/01/2000 00:00 UT: $t dias")
    
        # Exibir resultados das Questões 2-5
        println("\n### Questões 2-5: Elementos orbitais, Anomalias e Distância ###")
        println("--------------------------------------------------------------------------------------------------------------")
        println("| Planeta   |  Ω (°)  |  i (°)  |  ω (°)  |    a    |    e    |  M (°)  |  E (°)  |  v (°)  |  r (UA)  |")
        println("--------------------------------------------------------------------------------------------------------------")
    
        for planeta in planetas
            # Elementos orbitais
            omega = round(mod(calcular(planeta.omega, t), 360), digits=3)
            i = round(calcular(planeta.i, t), digits=3)
            w = round(mod(calcular(planeta.w, t), 360), digits=3)
            a = round(planeta.a, digits=6)
            e = round(calcular(planeta.e, t), digits=6)
            M = round(mod(calcular(planeta.M, t), 360), digits=3)
        
            # Anomalias e distância
            E = round(mod(anomalia_excentrica(planeta, t), 360), digits=3)
            v = round(anomalia_verdadeira(planeta, t), digits=3)
            r = round(distancia_sol(planeta, t), digits=3)
        
            # Formatar e exibir linha da tabela
            println("| $(rpad(planeta.nome, 9)) | $(lpad(omega, 7)) | $(lpad(i, 7)) | $(lpad(w, 7)) | $(lpad(a, 7)) | $(lpad(e, 7)) | $(lpad(M, 7)) | $(lpad(E, 7)) | $(lpad(v, 7)) | $(lpad(r, 8)) |")
        end
        println("--------------------------------------------------------------------------------------------------------------")
    
        # Questão 6: Coordenadas cartesianas heliocêntricas
        println("\n### Questão 6: Coordenadas Cartesianas Heliocêntricas (UA) ###")
        println("----------------------------------------------------------------")
        println("| Planeta   |       x        |       y        |       z        |")
        println("----------------------------------------------------------------")
    
        for planeta in planetas
            x, y, z = coordenadas(planeta, t)
            x = round(x, digits=6)
            y = round(y, digits=6)
            z = round(z, digits=6)
        
            println("| $(rpad(planeta.nome, 9)) | $(lpad(x, 14)) | $(lpad(y, 14)) | $(lpad(z, 14)) |")
        end
        println("----------------------------------------------------------------")
    
        # Questão 7: Coordenadas eclípticas heliocêntricas
        println("\n### Questão 7: Coordenadas Eclípticas Heliocêntricas ###")
        println("--------------------------------------------------------")
        println("| Planeta   |  Longitude (λ)  |   Latitude (β)   |")
        println("--------------------------------------------------------")
    
        for planeta in planetas
            l, b = coordenadasEclipticas(planeta, t)
            l = round(l, digits=3)
            b = round(b, digits=3)
        
            println("| $(rpad(planeta.nome, 9)) | $(lpad(l, 15)) | $(lpad(b, 17)) |")
        end
        println("--------------------------------------------------------")
    
        # Questões 8 e 9: Baricentro do sistema solar e verificação
        println("\n### Questões 8 e 9: Baricentro do Sistema Solar ###")
    
        X_cm, Y_cm, Z_cm, M_Tot = calcular_baricentro(sistema_solar, t)
    
        # Converter para km
        X_km = X_cm * 149597870.7
        Y_km = Y_cm * 149597870.7
        Z_km = Z_cm * 149597870.7
    
        # Calcular distância do baricentro ao centro do Sol
        dist_centro = sqrt(X_cm^2 + Y_cm^2 + Z_cm^2)
        dist_centro_km = dist_centro * 149597870.7
    
        # Verificar se o baricentro está dentro do Sol
        dentro, fator_raio = baricentro_dentro_sol(X_cm, Y_cm, Z_cm)
    
        println("Coordenadas do baricentro (UA):")
        println("X = $(round(X_cm, digits=6))")
        println("Y = $(round(Y_cm, digits=6))")
        println("Z = $(round(Z_cm, digits=6))")
        println("\nCoordenadas do baricentro (km):")
        println("X = $(round(X_km, digits=1)) km")
        println("Y = $(round(Y_km, digits=1)) km")
        println("Z = $(round(Z_km, digits=1)) km")
        println("\nDistância do baricentro ao centro do Sol: $(round(dist_centro_km, digits=1)) km")
        println("Raio do Sol: 696340.0 km")
        println("Razão entre distância e raio solar: $(round(fator_raio, digits=3))")
    
        if dentro
            println("Conclusão: O baricentro está DENTRO do Sol.")
        else
            println("Conclusão: O baricentro está FORA do Sol.")
        end
    
        # Questão 10: Verificar quais planetas estão em conjunção, oposição ou quadratura com a Terra
        println("\n### Questão 10: Aspectos dos planetas em relação à Terra ###")
        println("--------------------------------------------------------------")
        println("| Planeta   |    Aspecto    |  Ângulo  |  Distância Terra-Planeta |")
        println("--------------------------------------------------------------")
    
        # Obter longitude da Terra
        l_terra, _ = coordenadasEclipticas(terra, t)
    
        for planeta in planetas
            if planeta.nome != "Terra"
                l_planeta, _ = coordenadasEclipticas(planeta, t)
            
                # Calcular diferença de longitude (ângulo)
                dif_angulo = mod(l_planeta - l_terra, 360)
            
                # Determinar aspecto
                aspecto = ""
                if abs(dif_angulo) < 10 || abs(dif_angulo - 360) < 10
                    aspecto = "Conjunção"
                elseif abs(dif_angulo - 180) < 10
                 aspecto = "Oposição"
                elseif abs(dif_angulo - 90) < 10 || abs(dif_angulo - 270) < 10
                 aspecto = "Quadratura"
                else
                    aspecto = "Outro"
             end
            
                # Calcular distância Terra-Planeta usando coordenadas cartesianas
                x_terra, y_terra, z_terra = coordenadas(terra, t)
                x_planeta, y_planeta, z_planeta = coordenadas(planeta, t)
            
                dist_terra_planeta = sqrt((x_planeta - x_terra)^2 + (y_planeta - y_terra)^2 + (z_planeta - z_terra)^2)
            
                println("| $(rpad(planeta.nome, 9)) | $(rpad(aspecto, 13)) | $(lpad(round(dif_angulo, digits=2), 8)) | $(lpad(round(dist_terra_planeta, digits=3), 23)) |")
            end
        end
        println("--------------------------------------------------------------")
    end
end