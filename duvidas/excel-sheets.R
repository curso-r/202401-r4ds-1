library(readxl)

# Se não declaramos qual aba queremos abrir, ele abre por padrão a primeira.
v1 <- read_xlsx("dados/imdb_nao_estruturada.xlsx")

# Descobrir quais são os nomes das abas/planilhas
excel_sheets("dados/imdb_nao_estruturada.xlsx")

# Importar declarando qual é a aba que queremos abrir
v2 <- read_excel("dados/imdb_nao_estruturada.xlsx", sheet = "Sheet1")
