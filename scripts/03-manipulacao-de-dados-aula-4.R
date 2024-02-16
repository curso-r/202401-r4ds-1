# Pacotes -----------------------------------------------------------------
library(tidyverse)

# Base de dados -----------------------------------------------------------

imdb <- read_rds("dados/imdb.rds")

# Aula 4 ------------------------------------------------------------------

# Comand + Shift + R para criar a seção

# FORMAS PARA CRIAR UMA TABELA
# COM AS COLUNAS TITULO E NOTA,
# COM AS NOTAS DECRESCENTES

# FORMA 1
imdb_notas <- select(imdb, titulo, nota_imdb)

arrange(imdb_notas, desc(nota_imdb))

# FORMA 2
# CODIGO ANINHADO - NÃO É LEGAL
# dificil de ler
arrange(select(imdb, titulo, nota_imdb), desc(nota_imdb))

# PIPE ---------------------


# forma 3
# forma mais usada
# pipe - cano
# conecta as operações
# é um operador
# tidyverse %>%
# R base |>

imdb |>
  select(titulo, nota_imdb)

# select(imdb, titulo, nota_imdb)

imdb |>
  select(titulo, nota_imdb) |>
  arrange(desc(nota_imdb))

# salvar em um objeto
imdb_pipe <- imdb |> # usando a base do IMDB
  # quero selecionar as colunas titulo e nota
  select(titulo, nota_imdb) |>
  # ordenar de forma decrescente pela nota
  arrange(desc(nota_imdb))

# ATALHO DO |>: CTRL (command) + SHIFT + M

# Qual atalho usar? dá para mudar nas configurações
# Tools > Global options > Code > Use native pipe operator
# |> |> |> |> 

# %>% %>% %>% %>% %>% %>% 


# pipe nativo - Atalho: CTRL SHIFT M
imdb |>
  select(titulo, ano, nota_imdb, num_avaliacoes) |>
  arrange(desc(nota_imdb))

# pipe do tidyverse - Atalho: CTRL SHIFT M
imdb %>%
  select(titulo, ano, nota_imdb, num_avaliacoes) %>%
  arrange(desc(nota_imdb))



# PREPARATORIO PRO FILTER: DISTINCT -----------
# olhar as categorias de uma variável:

# Retorna uma tabela

distinct(imdb, direcao) # deixa apenas valores unicos!

# distinct(imdb, direcao, .keep_all = TRUE) |> View()



distinct(imdb, ano, producao) |>
  arrange(ano) |>
  View()



imdb |>
  distinct(direcao)

# Retorna um vetor
unique(imdb$direcao)




# Contagem ----
imdb |> 
  count(producao) |> View()


imdb |> 
  count(producao, sort = TRUE) |> View()

imdb |>
  count(direcao)

count(imdb, direcao, ano) |> View()

diretores_ordenados <- imdb |>
  count(direcao, sort = TRUE)

imdb |>
  filter(direcao == "George Lucas") 


# Intervalo - Aula 4 ---------------------------------------------------------------


# filter ------------------------------------------------------------------

# nome_da_funcao(base_de_dados, regra)

select(imdb, ano, nota_imdb)

arrange(imdb, desc(nota_imdb))

count(imdb, ano)

distinct(imdb, ano)

# filter() - filtrar linhas da base --------

# Aqui falaremos de Conceitos importantes para filtros,
# seguindo de exemplos!

## Comparações lógicas -------------------------------

# comparacao logica
# == significa: uma coisa é igual a outra?
x <- 1
# x = 1 - igual sozinho é uma atribuicao

# Teste com resultado verdadeiro
x == 1

# Teste com resultado falso
x == 2

# Exemplo com filtros!
# Filtrando uma coluna da base: O que for TRUE (verdadeiro)
# será mantido!

# filter(imdb, comparacoes_para_filtrar)

filter(imdb, direcao == "Quentin Tarantino")

# reescrever com pipe

imdb |>
  filter(direcao == "Quentin Tarantino") |>
  arrange(ano) |> # decrescente: desc(ano)
  select(titulo, ano, nota_imdb) |>
  View()


# coisas para tomar cuidado:
# colocar vários filtros no mesmo filter
imdb |> 
  filter(direcao == "Quentin Tarantino", nota_imdb == max(nota_imdb))

# Tem casos que é melhor deixar em dois filtros!
imdb |> 
  filter(direcao == "Quentin Tarantino") |> 
  filter(nota_imdb == max(nota_imdb))


imdb |>
  filter(direcao == "Quentin Tarantino") |>
  View()

imdb |>
  filter(
    direcao == "Quentin Tarantino",
    producao == "Miramax"
  ) |>
  View()


imdb |> 
  filter(direcao == "Quentin Tarantino", producao == "Miramax") |>
  View()


imdb |> 
  filter(direcao == "Quentin Tarantino") |> 
  filter(producao == "Miramax") |>
  View()


## Comparações lógicas -------------------------------

# maior
x > 3
x > 0
# menor
x < 3
x < 0


x > 1
x >= 1 # # Maior ou igual
x < 1
x <= 1 # menor ou igual

# Exemplo com filtros!

imdb |>
  filter(nota_imdb >= 9) |>
  View()

## Recentes e com nota alta
imdb |>
  filter(nota_imdb >= 9, num_avaliacoes > 10000) |>
  View()

# 3 filtros!
imdb |>
  filter(ano > 2010, nota_imdb > 8.5, num_avaliacoes > 1000) |>
  View()


# Esse & é igual a vírgula
imdb |> filter(ano > 2010 & nota_imdb > 8.5)

## Gastaram menos de 100 mil, faturaram mais de 1 milhão
imdb |>
  filter(orcamento < 100000, receita > 1000000) |>
  View()






## Lucraram
imdb |>
  filter(receita - orcamento > 0) |>
  View()

# Mesma coisa de cima, mas como a Beatriz prefere usar
imdb |> 
  select(titulo, ano, nota_imdb, orcamento, receita) |> 
  mutate(lucro = receita - orcamento) |>
  filter(lucro > 0) |> 
  View()



# Outra função útil: remover as linhas que tem NA
# em determinadas colunas
imdb |> 
  drop_na(orcamento) |> View()


imdb |> 
  drop_na(orcamento, receita) 

# cuidado pois tira todas as linhas que tem QUALQUER NA!
imdb |> 
  drop_na()


## Comparações lógicas -------------------------------

x != 2 # x é diferente de 2?
x != 1

# Exemplo com filtros!
imdb |>
  filter(direcao != "Quentin Tarantino") |>
  View()

## Comparações lógicas -------------------------------
# AULA 5 COMEÇAR AQUI! -------------------------------

# Mostrar exemplo que está em: https://gist.github.com/jtrecenti/01b823190c24508e29c1ea763ee0e0ee

# operador %in%
# o x é igual à 1
# o x faz parte do conjunto 1, 2 e 3? SIM
x %in% c(1, 2, 3)
# o x faz parte do conjunto 2, 3 e 4? NÃO
x %in% c(2, 3, 4)

# Exemplo com filtros! ISSO VAI TER QUE VOLTAR NO
# COMEÇO DA AULA QUE VEM

# Isso era pra retornar 0 linhas,  e voltou com 1. 
# Usou a reciclagem, mas isso tá errado.
imdb |> 
  filter(direcao == c("Christopher Nolan", "Matt Reeves")) |> View()

# para entender
imdb$direcao == c("Christopher Nolan", "Matt Reeves")


# O operador %in%

imdb |>
  filter(direcao %in% c("Matt Reeves", "Christopher Nolan")) |>
  View()

# Permite mais opções.
imdb |> 
  filter(ano %in% c(1990, 2000, 2010, 2020)) |>
  count(ano) |> View()
