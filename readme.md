# Astronomia de Sistemas Planetários - Cálculos de Órbitas Planetárias

![GitHub](https://img.shields.io/badge/Julia-1.8+-9558B2)
![Tamanho do repositório](https://img.shields.io/github/repo-size/pedro-hro/Trab1-AstroSist.Planetarios)

Este repositório contém a implementação computacional e documentação do trabalho sobre **cálculo de órbitas planetárias**, desenvolvido para a disciplina de Astronomia de Sistemas Planetários (FIS02015) da UFRGS. O projeto calcula e visualiza diversas propriedades orbitais do Sistema Solar para uma data específica usando princípios de Mecânica Celeste.

---

## 🔭 Descrição do Projeto

### Objetivo Principal

Calcular as posições e parâmetros orbitais dos planetas do Sistema Solar para uma data específica (06/08/2070, 20:45 UT), aplicando algumas equações fundamentais da mecânica celeste, como por exemplo:

$$r = \frac{a(1-e^2)}{1+e\cos\nu}$$

$$
\vec{r} = \begin{pmatrix}
r(\cos\Omega\cos(\omega+\nu) - \sin\Omega\sin(\omega+\nu)\cos i) \\
r(\sin\Omega\cos(\omega+\nu) + \cos\Omega\sin(\omega+\nu)\cos i) \\
r\sin(\omega+\nu)\sin i
\end{pmatrix}
$$

### Principais Componentes

- **Cálculos Implementados**:
  1. Elementos orbitais (Ω, i, ω, a, e, M)
  2. Anomalias excêntrica e verdadeira
  3. Coordenadas heliocêntricas cartesianas e eclípticas
  4. Baricentro do Sistema Solar
- **Resultados Chave**:
  - Tabelas com valores calculados para cada planeta
  - Visualização das posições angulares dos planetas
  - Verificação da posição do baricentro em relação ao raio solar

---

## 📂 Estrutura do Repositório

```
MecanicaCeleste/
├── main.jl                 🚀 Script principal de execução
├── complete_report.tex     📄 Relatório LaTeX gerado
├── output/                 📊 Arquivos de saída gerados
│   ├── date_time.tex          🗓️ Informações de data
│   ├── orbital_elements.tex   🌌 Elementos orbitais
│   ├── coordinates.tex        📍 Coordenadas calculadas
│   ├── barycenter.tex         ⚖️ Dados do baricentro
│   └── sistema_solar.png      🪐 Visualização das posições
└── src/
    ├── MecanicaCeleste.jl    🧮 Módulo principal
    ├── tipos.jl              📋 Definição dos tipos de dados
    ├── dados_planetas.jl     🌍 Dados iniciais dos planetas
    └── calculos.jl           📐 Funções de cálculo
```

---

## ⚙️ Instalação e Dependências

1. **Clonar o repositório**:

   ```bash
   git clone https://github.com/seu-usuario/MecanicaCeleste.git
   ```

2. **Instalar dependências**:

   - Julia (v1.8 ou superior):

     ```bash
     # Em sistemas Debian/Ubuntu
     sudo apt install julia
     ```

   - Pacotes Julia necessários:

     ```julia
     using Pkg
     Pkg.add("Plots")
     ```

   - LaTeX (para compilar o relatório):
     ```bash
     sudo apt install texlive-full
     ```

---

## 🚀 Como Executar

1. **Navegue até o diretório do projeto**:

   ```bash
   cd MecanicaCeleste
   ```

2. **Execute o script principal**:

   ```bash
   julia main.jl
   ```

3. **Saídas geradas**:
   - Arquivos LaTeX na pasta `output/`
   - Visualização `sistema_solar.png`
   - Relatório completo `complete_report.tex`
4. **Compilar o relatório LaTeX**:
   ```bash
   pdflatex complete_report.tex
   ```

---

## 📧 Contato

**Autor**:

- Pedro H. R. de Oliveira - [@pedro-hro](https://github.com/pedro-hro)
  **Afiliação**:  
  Instituto de Física - UFRGS  
  Porto Alegre, RS - Brasil

**Disciplina**:  
FIS02015 - Astronomia de Sistemas Planetários  
Prof. Dr. José Eduardo da Silveira Costa
