# Trabalho da Área 1: Mecânica Celeste - Sistema Solar

## Descrição

Este projeto implementa cálculos de mecânica celeste para determinar as posições e outros parâmetros orbitais dos planetas do Sistema Solar para uma data e hora específicas. O código foi desenvolvido em Julia como parte do trabalho da Área 1 de Astrofísica de Sistemas Planetários.

A data de referência para os cálculos é **06 de Agosto de 2070, às 20:45 UT**.

## Cálculos Realizados

O programa calcula e apresenta os seguintes resultados para a data especificada:

1.  **Tempo Juliano (t):** Número de dias decorridos desde a época J2000.0 (01/01/2000 00:00 UT).
2.  **Elementos Orbitais:** Calcula os elementos orbitais instantâneos para cada planeta:
    - Longitude do Nodo Ascendente (Ω)
    - Inclinação (i)
    - Argumento do Periélio (ω)
    - Semi-eixo Maior (a) - _Considerado constante neste modelo_
    - Excentricidade (e)
    - Anomalia Média (M)
3.  **Anomalia Excêntrica (E):** Calculada iterativamente a partir da Anomalia Média e da Excentricidade (Equação de Kepler).
4.  **Anomalia Verdadeira (v):** O ângulo real do planeta em sua órbita medido a partir do periélio.
5.  **Distância Heliocêntrica (r):** A distância do planeta ao Sol em Unidades Astronômicas (UA).
6.  **Coordenadas Cartesianas Heliocêntricas (x, y, z):** Posição do planeta no espaço em relação ao Sol, no sistema de referência eclíptico.
7.  **Coordenadas Eclípticas Heliocêntricas (λ, β):** Longitude e latitude eclípticas do planeta vistas do Sol.
8.  **Posição do Baricentro:** Calcula as coordenadas (X_cm, Y_cm, Z_cm) do centro de massa do Sistema Solar (considerando Sol e os 8 planetas).
9.  **Verificação do Baricentro:** Determina se o baricentro calculado está dentro ou fora do volume do Sol.
10. **Aspectos Planetários:** Verifica se os outros planetas estão em conjunção, oposição ou quadratura em relação à Terra, com base na diferença de longitude eclíptica, e calcula a distância Terra-Planeta.

## Estrutura do Projeto

O código está organizado de forma modular em Julia:

```
MecanicaCeleste/
├── main.jl             # Ponto de entrada: executa os cálculos e salva a saída
├── output.txt          # Arquivo gerado com os resultados dos cálculos
└── src/
    ├── MecanicaCeleste.jl # Módulo principal que organiza e executa as funções
    ├── tipos.jl          # Definição das estruturas de dados (ElementoOrbital, Planeta)
    ├── dados_planetas.jl # Definição das constantes e dados iniciais dos planetas
    └── calculos.jl       # Contém as funções matemáticas para os cálculos orbitais
```

## Como Executar

1.  Certifique-se de ter o Julia instalado (https://julialang.org/downloads/).
2.  Navegue até o diretório raiz do projeto (`MecanicaCeleste/`).
3.  Execute o script principal no terminal:
    ```bash
    julia main.jl
    ```
4.  Os resultados serão salvos no arquivo `output.txt`.

## Dependências

- Julia (linguagem de programação)
- Nenhuma biblioteca externa é necessária (apenas módulos padrão do Julia).
