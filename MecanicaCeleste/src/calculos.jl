include("tipos.jl")

# Distância entre a Terra e o Sol em km 
const auKm = 149597870.7

"""
	calcular_elementoOrb(elemento, t, isAngular)

Calcula o valor atual de um elemento orbital.
Entrada: elemento (ElementoOrbital), t (dias desde J2000), isAngular (booleano)
Saída: valor do elemento (radianos se angular, unidade original caso contrário)
"""
function calcular_elementoOrb(elemento::ElementoOrbital, t, isAngular::Bool = true)
	res = elemento.valor_base + elemento.taxa * t
	if isAngular
		res = mod(res, 360)
		res = res * (π/180)
	end
	return res
end

"""
	tempo(d, m, y, h, min)

Calcula o tempo em dias desde a época J2000 (1 de janeiro de 2000, 0h UT).
Entrada: d (dia), m (mês), y (ano), h (hora), min (minutos) 
Saída: dias desde J2000 (Float64)
"""
function tempo(d, m, y, h, min)
	t = (367*y-(floor(7*(y+(floor((m+9)/12)))/4))+floor(275*m/9)+d-730530) + h/24 + min/(24*60)
	return round(t, digits = 3)
end

"""
	anomalia_excentrica(planeta, t)

Calcula a anomalia excêntrica resolvendo a equação de Kepler iterativamente.
Entrada: planeta (Planeta), t (dias desde J2000)
Saída: anomalia excêntrica em radianos (Float64)
"""
function anomalia_excentrica(planeta::Planeta, t)
	M = calcular_elementoOrb(planeta.M, t)
	e = calcular_elementoOrb(planeta.e, t, false)
	E_aprox = M

	while true
		delta_E = (M - E_aprox + e * sin(E_aprox)) / (1 - e * cos(E_aprox))
		E = E_aprox + delta_E
		if abs(delta_E) < 5e-6
			return E
		else
			E_aprox = E
		end
	end
end

"""
	anomalia_verdadeira(planeta, t)

Calcula a anomalia verdadeira a partir da anomalia excêntrica.
Entrada: planeta (Planeta), t (dias desde J2000)
Saída: anomalia verdadeira em radianos (Float64)
"""
function anomalia_verdadeira(planeta::Planeta, t)
	E = anomalia_excentrica(planeta, t)
	e = calcular_elementoOrb(planeta.e, t, false)

	v = 2 * atan(sqrt((1 + e) / (1 - e)) * tan(E / 2))

	return v
end

"""
	distancia_sol(planeta, t)

Calcula a distância do planeta ao Sol em unidades astronômicas.
Entrada: planeta (Planeta), t (dias desde J2000)
Saída: distância em UA (Float64)
"""
function distancia_sol(planeta::Planeta, t)
	v = anomalia_verdadeira(planeta, t)
	a = planeta.a
	e = calcular_elementoOrb(planeta.e, t, false)

	r = a*(1-e^2)/(1+e*cos(v))
	return r
end

"""
	coordenadas(planeta, t)

Calcula as coordenadas cartesianas do planeta no sistema eclíptico.
Entrada: planeta (Planeta), t (dias desde J2000)
Saída: tupla (x, y, z) em quilômetros
"""
function coordenadas(planeta::Planeta, t)
	r = (distancia_sol(planeta, t)) * auKm
	v = anomalia_verdadeira(planeta, t)
	i = calcular_elementoOrb(planeta.i, t)
	w = calcular_elementoOrb(planeta.w, t)
	omega = calcular_elementoOrb(planeta.omega, t)

	x = r * (cos(omega) * cos(w + v) - sin(omega) * sin(w + v) * cos(i))
	y = r * (sin(omega) * cos(w + v) + cos(omega) * sin(w + v) * cos(i))
	z = r * (sin(w + v) * sin(i))
	return (x, y, z)
end

"""
	coordenadasEclipticas(planeta, t)

Converte coordenadas cartesianas para longitude e latitude eclípticas.
Entrada: planeta (Planeta), t (dias desde J2000)
Saída: tupla (longitude, latitude) em graus
"""
function coordenadasEclipticas(planeta::Planeta, t)
	x, y, z = coordenadas(planeta, t)
	l = atan(y, x) * (180/π)
	b = atan(z, sqrt(x^2 + y^2)) * (180/π)

	l = mod(l, 360)
	return (l, b)
end

"""
	calcular_baricentro(sistema, t)

Calcula o centro de massa (baricentro) do sistema solar.
Entrada: sistema (vetor de Planeta), t (dias desde J2000)
Saída: coordenadas (X_cm, Y_cm, Z_cm) em km e massa total M_Tot
"""
function calcular_baricentro(sistema::Vector{Planeta}, t::Float64)
	# Calcula a massa total incluindo o Sol
	M_Tot = sum(planeta.massa for planeta in sistema)

	X_cm, Y_cm, Z_cm = 0.0, 0.0, 0.0

	for planeta in sistema
		if planeta.nome == "Sol"
			# O Sol está na origem (0,0,0)
			X_cm += (planeta.massa / M_Tot) * 0.0
			Y_cm += (planeta.massa / M_Tot) * 0.0
			Z_cm += (planeta.massa / M_Tot) * 0.0
		else
			x, y, z = coordenadas(planeta, t)

			X_cm += (planeta.massa / M_Tot) * x
			Y_cm += (planeta.massa / M_Tot) * y
			Z_cm += (planeta.massa / M_Tot) * z
		end
	end

	return X_cm, Y_cm, Z_cm, M_Tot
end

"""
	baricentro_dentro_sol(X_cm, Y_cm, Z_cm)

Verifica se o baricentro está dentro do Sol e calcula a razão da distância.
Entrada: coordenadas do baricentro (X_cm, Y_cm, Z_cm) em km
Saída: tupla (booleano indicando se está dentro, razão distância/raio solar)
"""
function baricentro_dentro_sol(X_cm::Float64, Y_cm::Float64, Z_cm::Float64)
	R_sol_km = 696340.0

	delta_km = sqrt(X_cm^2 + Y_cm^2 + Z_cm^2)

	delta = delta_km / R_sol_km

	return delta <= 1.0, delta
end
