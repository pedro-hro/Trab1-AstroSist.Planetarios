module MecanicaCeleste

using Plots

include("tipos.jl")
include("dados_planetas.jl")
include("calculos.jl")

# Definindo o tempo de referência
t = tempo(6, 8, 2070, 20, 45)

planetas = [mercurio, venus, terra, marte, jupiter, saturno, urano, netuno]
sistema_solar = [sol, mercurio, venus, terra, marte, jupiter, saturno, urano, netuno]

"""
	plotar_sistema_solar()

Cria um gráfico polar mostrando as posições angulares dos planetas.
Entrada: Nenhuma (usa variáveis globais t e planetas)
Saída: Objeto de gráfico Plots.jl com a visualização do sistema solar
"""

export plotar_sistema_solar
function plotar_sistema_solar()
	longitudes = Float64[]

	for (i, planeta) in enumerate(planetas)
		l, _ = coordenadasEclipticas(planeta, t)
		l = l * (π/180)
		push!(longitudes, l)
	end

	indices = collect(1:length(planetas))

	plt = plot(
		proj = :polar,
		legend = false,
		size = (800, 800),
		grid = true,
		gridstyle = :dash,
		gridlinewidth = 1.0,
		gridcolor = :black,
		gridalpha = 0.3,
		framestyle = :box,
		background_color = :white,
		foreground_color = :black,
		margin = 15Plots.mm,
		tickfontsize = 10,
		titlefontsize = 14,
	)

	angles = [0, 45, 90, 135, 180, 225, 270, 315]
	labels = ["0°", "45°", "90°", "135°", "180°", "225°", "270°", "315°"]
	xticks = (angles .* π/180, labels)
	plot!(plt, xticks = xticks)

	scatter!(plt, longitudes, indices,
		color = :black,
		markersize = 8,
		markershape = :circle,
		markerstrokewidth = 2,
		markerstrokecolor = :black,
	)

	yticks = (1:length(planetas), string.(1:length(planetas)))
	plot!(plt, yticks = yticks)

	for r in 1:8
		plot!(plt, range(0, 2π, length = 100), fill(r, 100),
			linecolor = :black, linewidth = 0.7, linealpha = 0.3,
			label = "")
	end

	for angle in angles .* π/180
		plot!(plt, [angle, angle], [0, 8.5],
			linecolor = :black, linewidth = 0.7, linealpha = 0.3,
			label = "")
	end

	return plt
end

"""
	generate_latex_data()

Gera arquivos LaTeX e um gráfico para criar um relatório completo do sistema solar.
Entrada: Nenhuma (usa variáveis globais t, planetas e sistema_solar)
Saída: Cria arquivos LaTeX e PNG no diretório "output" e um arquivo de relatório completo
"""

export generate_latex_data
function generate_latex_data()
	# Cria diretório de saída se não existir
	isdir("output") || mkdir("output")

	# Gera tabela de data e hora
	open("output/date_time.tex", "w") do file
		write(file, "\\begin{tabular}{|l|l|}\n")
		write(file, "\\hline\n")
		write(file, "Data: & 06/08/2070 \\\\\n")
		write(file, "\\hline\n")
		write(file, "Hora: & 20:45 \\\\\n")
		write(file, "\\hline\n")
		write(file, "\\end{tabular}\n")
	end

	# Gera tabela de elementos orbitais
	open("output/orbital_elements.tex", "w") do file
		write(file, "\\begin{tabular}{|l||l|l|l|l|l||l|l||l|l|}\n")
		write(file, "\\hline\n")
		write(file, "Planeta & \$\\Omega\$ (\\textdegree)& \$i\$ (\\textdegree)& \$\\varpi\$ (\\textdegree)& \$a\$ (ua)& ")
		write(file, "e & \$M\$ (\\textdegree)& \$E\$ (\\textdegree) & \$\\nu\$ (\\textdegree) & \$r\$ (ua) \\\\\n")
		write(file, "\\hline\\hline\n")

		for planeta in planetas
			omega = round(mod(calcular_elementoOrb(planeta.omega, t) * (180/π), 360), digits = 3)
			i = round(mod(calcular_elementoOrb(planeta.i, t) * (180/π), 360), digits = 3)
			w = round(mod(calcular_elementoOrb(planeta.w, t) * (180/π), 360), digits = 3)
			a = round(planeta.a, digits = 6)
			e = round(calcular_elementoOrb(planeta.e, t, false), digits = 6)
			M = round(mod(calcular_elementoOrb(planeta.M, t) * (180/π), 360), digits = 3)

			E = round(mod(anomalia_excentrica(planeta, t) * (180/π), 360), digits = 3)
			v = round(mod(anomalia_verdadeira(planeta, t) * (180/π), 360), digits = 3)
			r = round(distancia_sol(planeta, t), digits = 3)

			write(file, "$(planeta.nome) & $(lpad(omega, 7)) & $(lpad(i, 7)) & $(lpad(w, 7)) & ")
			write(file, "$(lpad(a, 7)) & $(lpad(e, 7)) & $(lpad(M, 7)) & ")
			write(file, "$(lpad(E, 7)) & $(lpad(v, 7)) & $(lpad(r, 8)) \\\\\n")
			write(file, "\\hline\n")
		end

		write(file, "\\end{tabular}\n")
	end

	# Gera tabela de coordenadas
	open("output/coordinates.tex", "w") do file
		write(file, "\\begin{tabular}{|l|l||l|l|l||l|l|}\n")
		write(file, "\\hline\n")
		write(file, "k & Planeta & \$X\$ (km) & \$Y\$ (km) & \$Z\$ (km) & \$l\$ (\\textdegree) & \$b\$ (\\textdegree) \\\\\n")
		write(file, "\\hline\\hline\n")

		for (k, planeta) in enumerate(planetas)
			x, y, z = coordenadas(planeta, t)
			x_int = round(Int, x)
			y_int = round(Int, y)
			z_int = round(Int, z)

			l, b = coordenadasEclipticas(planeta, t)
			l = round(l, digits = 3)
			b = round(b, digits = 3)

			write(file, "$(k) & $(planeta.nome) & $(lpad(x_int, 14)) & ")
			write(file, "$(lpad(y_int, 14)) & $(lpad(z_int, 14)) & ")
			write(file, "$(lpad(l, 15)) & $(lpad(b, 17)) \\\\\n")
			write(file, "\\hline\n")
		end

		write(file, "\\end{tabular}\n")
	end

	# Gera tabela de baricentro
	open("output/barycenter.tex", "w") do file
		write(file, "\\begin{tabular}{|l|l|l||l|l|l|}\n")
		write(file, "\\hline\n")
		write(file, "\$X_{cm}\$ (km) & \$Y_{cm}\$ (km) & \$Z_{cm}\$ (km) & \$\\Delta_{(km)}\$ & \$\\Delta\$ & Fora ou dentro? \\\\\n")
		write(file, "\\hline\n")

		X_cm, Y_cm, Z_cm, M_Tot = calcular_baricentro(sistema_solar, t)

		X_km_int = round(Int, X_cm)
		Y_km_int = round(Int, Y_cm)
		Z_km_int = round(Int, Z_cm)

		dist_centro = sqrt(X_cm^2 + Y_cm^2 + Z_cm^2)
		dist_centro_km_int = round(Int, dist_centro)

		dentro, fator_raio = baricentro_dentro_sol(X_cm, Y_cm, Z_cm)
		fator_raio = round(fator_raio, digits = 3)
		status = dentro ? "Dentro" : "Fora"

		write(file, "$(X_km_int) & ")
		write(file, "$(Y_km_int) & ")
		write(file, "$(Z_km_int) & ")
		write(file, "$(dist_centro_km_int) & ")
		write(file, "$(fator_raio) & ")
		write(file, "$(status) \\\\\n")
		write(file, "\\hline\n")
		write(file, "\\end{tabular}\n")
	end

	# Gera gráfico do sistema solar
	plt = plotar_sistema_solar()
	savefig(plt, "output/sistema_solar.png")

	# Cria o arquivo LaTeX completo
	open("complete_report.tex", "w") do file
		write(file, "\\documentclass{article}\n")
		write(file, "\\usepackage[textwidth=18.5cm, textheight=24cm]{geometry}\n")
		write(file, "\\usepackage{graphicx}\n\n")
		write(file, "\\begin{document}\n")
		write(file, "\\textbf{FIS02015 – Trabalho 1: Cálculo dos Elementos Orbitais}\n\n")
		write(file, "\\begin{enumerate}\n")
		write(file, "  \\item \\textbf{Data \\& Hora:} \\\\\\\\\n")
		write(file, "    \\input{output/date_time.tex}\n")
		write(file, "    \\hspace{6.63cm}\n")
		write(file, "    \\begin{tabular}{|l|l|}\n")
		write(file, "          \\hline\n")
		write(file, "          Nome: Pedro H. R. de Oliveira \\\\\n")
		write(file, "          \\hline\n")
		write(file, "          Cartão: 00590908\\\\\n")
		write(file, "          \\hline\n")
		write(file, "    \\end{tabular}\n")
		write(file, "  \\item \\textbf{Elementos orbitais:} \\\\\\\\\n")
		write(file, "    \\input{output/orbital_elements.tex}\n")
		write(file, "  \\item \\textbf{Coordenadas retangulares e coordenadas eclípticas:}\\\\\\\\\n")
		write(file, "    \\input{output/coordinates.tex}\n")
		write(file, "  \\item \\textbf{Baricentro do Sistema Solar:} \\\\\\\\\n")
		write(file, "    \\input{output/barycenter.tex}\n")
		write(file, "  \\item \\textbf{Posições angulares dos planetas:} \\\\\\\\\n")
		write(file, "    \\begin{minipage}{0.5\\textwidth}\n")
		write(file, "        \\begin{enumerate}\n")
		write(file, "          \\item[1. ] Mercúrio\n")
		write(file, "          \\item[2. ] Vênus\n")
		write(file, "          \\item[3. ] Terra\n")
		write(file, "          \\item[4. ] Marte\n")
		write(file, "          \\item[5. ] Júpiter\n")
		write(file, "          \\item[6. ] Saturno\n")
		write(file, "          \\item[7. ] Urano\n")
		write(file, "          \\item[8. ] Netuno\n")
		write(file, "        \\end{enumerate}\n")
		write(file, "    \\end{minipage}\n")
		write(file, "    \\begin{minipage}{0.5\\textwidth}\n")
		write(file, "            \\includegraphics[width=0.75\\textwidth]{output/sistema_solar.png}\n")
		write(file, "    \\end{minipage} \\n")
		write(file, "\\end{enumerate}\n")
		write(file, "\\end{document}\n")
	end
	# Print message indicating that the report was generated
	println("Relatório completo gerado como 'complete_report.tex' na pasta atual.")
end



end
