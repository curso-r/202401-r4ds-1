# Pacotes -----------------------------------------------------------------
library(tidyverse)

# Base de dados -----------------------------------------------------------

imdb <- read_rds("dados/imdb.rds")

## Comparações lógicas -------------------------------
# AULA 5 COMEÇAR AQUI! -------------------------------

# Mostrar exemplo que está em: https://gist.github.com/jtrecenti/01b823190c24508e29c1ea763ee0e0ee


x <- 1

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
  # NÃO USAR O == NO CASO DE c()
  filter(direcao == c("Christopher Nolan", "Matt Reeves"))

# filme 1 - nolan
# filme 2 - reeves
# filme 3 - nolan
# filme 4 - reeves

# O operador %in%

imdb |>
  filter(direcao %in% c("Matt Reeves", "Christopher Nolan")) |>
  View()

# Permite mais opções.
imdb |>
  filter(ano %in% c(1990, 2000, 2010, 2020)) |>
  count(ano) |>
  View()




# dá pra reescrever com o OU
imdb |>
  filter(
    direcao == "Matt Reeves" | direcao == "Christopher Nolan"
  )


imdb |>
  filter(
    str_detect(generos, "Comedy")
  )


imdb |>
  filter(
    str_detect(generos, "Adventure") | str_detect(generos, "Animation")
  ) |> View()


imdb |>
  filter(
    str_detect(generos, "Adventure"), str_detect(generos, "Animation")
  ) |> View()


# E o contains não funciona?
# Não :( contains() funciona com funções de para selecionar colunas!
# imdb |>
#   filter(
#     contains("Adventure")
#   )
# `contains()` must be used within a *selecting* function.


# ISSO NAO FUNCIONA
# imdb |>
#  filter(direcao == c("..", '...'))


diretores_favoritos_do_will <- imdb |>
  filter(
    direcao %in% c(
      "Quentin Tarantino",
      "Christopher Nolan",
      "Matt Reeves",
      "Steven Spielberg",
      "Francis Ford Coppola"
    )
  ) |>
  view()




## Operadores lógicos -------------------------------
## operadores lógicos - &, | , !

## & - E - Para ser verdadeiro, os dois lados
# precisam resultar em TRUE
x <- 5

x >= 3 # verdadeiro

x <= 7 # verdadeiro

x >= 3 & x <= 7 #

x >= 3 & x <= 4

# no filter, a virgula funciona como o &!
imdb |>
  filter(ano > 2010, nota_imdb > 8.5) |>
  View()


# menos frequente de ser usado, mas funciona!
imdb |>
  filter(ano > 2010 & nota_imdb > 8.5)


## Operadores lógicos -------------------------------

## | - OU - Para ser verdadeiro, apenas um dos
# lados precisa ser verdadeiro

# operador |

y <- 2
y >= 3 # FALSO
y <= 7 # VERDADEIRO

# & - Resultado falso, VERDADEIRO + FALSO = FALSO
# | - Resultado verdadeiro, VERDADEIRO + FALSO = VERDADEIRO

y >= 3 | y <= 7

y >= 3 | y <= 0

# Exemplo com filter

## Lucraram mais de 500 milhões OU têm nota muito alta
imdb |>
  filter(receita - orcamento > 500000000 | nota_imdb > 9) |>
  View()

# O que esse quer dizer?
imdb |>
  filter(ano > 2010 | nota_imdb > 8.5) |>
  View()


imdb |>
  # é NA na receita OU é NA no orçamento
  # OU - satisfazer pelo menos uma das comparacoes/condicoes
  filter(is.na(receita) | is.na(orcamento)) |>
  # nrow()
  View()




## Operadores lógicos -------------------------------

## ! - Negação - É o "contrário"
# NOT

# operador de negação !
# é o contrario

!TRUE

!FALSE

# Exemplo com filter

imdb |>
  filter(!direcao %in% c(
    "Quentin Tarantino",
    "Christopher Nolan",
    "Matt Reeves",
    "Steven Spielberg",
    "Francis Ford Coppola"
  )) |>
  View()


# . função que testa se algo é um valor faltante - NA
is.na("bia")
is.na(NA)

!is.na("bia")


imdb |>
  filter(is.na(orcamento)) |> View()



imdb |>
  filter(!is.na(orcamento)) |>
  View()




imdb |>
  filter(!is.na(orcamento), !is.na(receita)) |>
  View()


## Filtrando a partir de textos ----

imdb_desc <- imdb |>
  # criar uma coluna nova
  # essa coluna se chamará descricao_minusculo
  # e o que ela vai ter?
  # o conteúdo da coluna descricao,
  # com o texto em letras minúsculas
  mutate(descricao_minusculo = str_to_lower(descricao))



textos_desc <- imdb_desc$descricao_minusculo[1:5]

str_view(textos_desc, "woman")

str_detect(textos_desc, "woman")



str_view(textos_desc, "woman|male")

str_detect(textos_desc, "woman|male")


str_extract(textos_desc, "woman")

# nesse caso não usamos o %in%, e sim o |
# O | é o ou.
imdb_desc |>
  filter(str_detect(descricao_minusculo, "woman|friend")) |>
  View()

# nesse caso, a vírgula quer dizer E - &
imdb |>
  mutate(descricao_minusculo = str_to_lower(descricao)) |>
  filter(
    str_detect(descricao_minusculo, "woman"),
   str_detect(descricao_minusculo, "friend")
  ) |>
  View()


##  NA ----

# exemplo com NA
is.na(imdb$orcamento)

imdb |>
  filter(!is.na(orcamento))

# tira toooodas as linhas que tenham algum NA
imdb |>
  drop_na()

# tira as linhas que tem NA nas colunas indicadas
imdb |>
  drop_na(orcamento)

imdb |>
  drop_na(orcamento, receita)


# o filtro por padrão tira os NAs!
df <- tibble(x = c(1, 2, 3, NA))
df


filter(df, x > 1)

filter(df, x < 2)

# NA == 1
# NA > 1
#
# NA == NA


# manter os NAs!
filter(df, x > 1 | is.na(x))
# Por padrão, a função filter retira os NAs.



# ISSO DÁ UM RESULTADO ERRADO
filter(imdb, orcamento == NA)


## Contar os NAs ----------------------

# contar os NA quando a variavel é categórica/texto
count(imdb, producao, sort = TRUE) |> View()

# para numéricos, assim é mais fácil
filter(imdb, is.na(orcamento)) |>
  nrow()

is.na(imdb$orcamento)


sum(is.na(imdb$orcamento))

# tambem funciona para texto
filter(imdb, is.na(producao)) |>
  nrow()



# filtrar textos sem correspondência exata

textos <- c("a", "aa", "abc", "bc", "A", NA)
textos

library(stringr) # faz parte do tidyverse

str_detect(textos, pattern = "a")

str_view(textos, "a")

# validacao do padrao usado
str_view(imdb$descricao[1:10], "woman|movie", html = TRUE)

str_view(imdb$descricao[1:10], "woman|movie")


## Pegando os seis primeiros valores da coluna "generos"
imdb$generos[1:6]

str_detect(
  string = imdb$generos[1:6],
  pattern = "Drama"
)


## Pegando apenas os filmes que
## tenham o gênero ação
imdb |>
  filter(str_detect(generos, "Action")) |>
  View()


# filtra generos que contenha filmes que tenha "Crime" no texto
imdb |>
  filter(str_detect(generos, "Crime")) |>
  View()

# filtra generos que seja IGUAL e APENAS "Crime"
imdb |> filter(generos == "Crime") |> View()


# mutate ------------------------------------------------------------------

# mutate(base, nome_da_coluna_para_criar = operacao_que_tem_resultado,
# nome_da_coluna_para_criar_2 = operacao_que_tem_resultado)

# Modificando uma coluna
imdb |>
  mutate(duracao = duracao / 60) |>
  View()

# Criando uma nova coluna

imdb |>
  mutate(duracao_horas = duracao / 60) |>
  View()

# util pra criar colunas em uma posicao especifica
imdb |>
  mutate(duracao_horas = duracao / 60, .after = duracao) |>
  View()

imdb |>
  mutate(
    duracao_horas = duracao/60, .before = pais
  )


imdb |>
  mutate(lucro = receita - orcamento, .after = receita) |>
  View()


# o resultado dessa sequencia de operações (pipeline) será salva em lucro_filmes
lucro_filmes <- imdb |>
  # removendo filmes que tenham NA em orçamento ou em receita
  drop_na(orcamento, receita) |>
  # selecionar as colunas titulo, ano, receita e orcamento
  select(titulo, ano, receita, orcamento) |>
  mutate(
    # vamos criar a coluna lucro, que é o resultado de receita - orçamento
    lucro = receita - orcamento,
    # verificando se o filme lucrou
    lucrou = lucro > 0,
    # essas colunas criadas serão adicionas depois da coluna orçamento
    .after = orcamento
  ) |>
  # ordenando de forma crescente as linhas de acordo com os valores da coluna lucro.
  arrange(lucro)


# A função ifelse é uma ótima ferramenta
# para fazermos classificação binária (2 CATEGORIAS)

idade <- 27
if(idade < 18){
  "menor de idade"
} else {
  "maior de idade"
}


# if else
# SE A CONDICAO FOR VERDADEIRA, FACA TAL COISA,
# SE NAO, FACA OUTRA COISA
imdb |>
  mutate(
    lucro = receita - orcamento,
    houve_lucro = ifelse(lucro > 0, "Sim", "Não")
  ) |>
  View()


nota_categorizada <- imdb |>
  select(titulo, nota_imdb) |>
  mutate(
    categoria_nota = case_when(
      # quando essa condicao for verdadeira ~ salve esse valor,
      nota_imdb >= 8 ~ "Alta",
      nota_imdb >= 5 ~ "Média",
      nota_imdb < 5 ~ "Baixa",
      # .default = "CATEGORIZAR" # VERSÃO MAIS RECENTE
      TRUE ~ "CATEGORIZAR" # Em alguns lugares aparece assim pois é a versão mais antiga
    )
  )

nota_categorizada |>
  count(categoria_nota)

# classificacao com mais de 2 categorias:
# usar a função case_when()


# PRÓXIMA AULA: COMEÇAR COM O EXERCICIO EXTRA DO 3.1

# PRÓXIMA AULA: REVISAR O case_when()
