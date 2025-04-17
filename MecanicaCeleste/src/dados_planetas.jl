include("tipos.jl")

# Dados dos planetas do sistema solar
# Fonte: https://www.stjarnhimlen.se/comp/ppcomp.html
sol = Planeta("Sol",
	ElementoOrbital(0.0, 0.0),
	ElementoOrbital(0.0, 0.0),
	ElementoOrbital(0.0, 0.0),
	1.000000,
	ElementoOrbital(0.016709, -1.151e-9),
	ElementoOrbital(356.0470, 0.9856002585),
	1.9885e30,
)

mercurio = Planeta("Mercúrio",
	ElementoOrbital(48.3313, 3.24587e-5),
	ElementoOrbital(7.0047, 5.00e-8),
	ElementoOrbital(29.1241, 1.01444e-5),
	0.387098,
	ElementoOrbital(0.205635, 5.59e-10),
	ElementoOrbital(168.6562, 4.0923344368),
	3.3011e23,
)

venus = Planeta("Vênus",
	ElementoOrbital(76.6799, 2.4659e-5),
	ElementoOrbital(3.3946, 2.75e-8),
	ElementoOrbital(54.8910, 1.38374e-5),
	0.723330,
	ElementoOrbital(0.006773, -1.302e-9),
	ElementoOrbital(48.0052, 1.602130224),
	4.8675e24,
)

terra = Planeta("Terra",
	ElementoOrbital(0.0, 0.0),
	ElementoOrbital(0.0, 0.0),
	ElementoOrbital(282.9404, 4.70935e-5),
	1.000000,
	ElementoOrbital(0.016709, -1.151e-9),
	ElementoOrbital(356.0470, 0.9856002585),
	5.9722e24,
)

marte = Planeta("Marte",
	ElementoOrbital(49.5574, 2.11081e-5),
	ElementoOrbital(1.8497, -1.78e-8),
	ElementoOrbital(286.5016, 2.92961e-5),
	1.523688,
	ElementoOrbital(0.093405, 2.516e-9),
	ElementoOrbital(18.6021, 0.5240207766),
	6.4171e23,
)

jupiter = Planeta("Júpiter",
	ElementoOrbital(100.4542, 2.76854e-5),
	ElementoOrbital(1.3030, -1.557e-7),
	ElementoOrbital(273.8777, 1.64505e-5),
	5.20256,
	ElementoOrbital(0.048498, 4.469e-9),
	ElementoOrbital(19.8950, 0.0830853001),
	1.8981e27,
)

saturno = Planeta("Saturno",
	ElementoOrbital(113.6634, 2.38980e-5),
	ElementoOrbital(2.4886, -1.081e-7),
	ElementoOrbital(339.3939, 2.97661e-5),
	9.55475,
	ElementoOrbital(0.055546, -9.499e-9),
	ElementoOrbital(316.9670, 0.0334442282),
	5.6834e26,
)

urano = Planeta("Urano",
	ElementoOrbital(74.0005, 1.3978e-5),
	ElementoOrbital(0.7733, 1.9e-8),
	ElementoOrbital(96.6612, 3.0565e-5),
	19.18171,
	ElementoOrbital(0.047318, 7.45e-9),
	ElementoOrbital(142.5905, 0.011725806),
	8.6810e25,
)

netuno = Planeta("Netuno",
	ElementoOrbital(131.7806, 3.0173e-5),
	ElementoOrbital(1.7700, -2.55e-7),
	ElementoOrbital(272.8461, -6.027e-6),
	30.05826,
	ElementoOrbital(0.008606, 2.15e-9),
	ElementoOrbital(260.2471, 0.005995147),
	1.02413e26,
)
