# Aula 3 ------------------------------------------------------------------


# Pacotes -----------------------------------------------------------------

library(tidyverse)


# Importação de dados -----------------------------------------------------

imdb <- read_csv("https://raw.githubusercontent.com/curso-r/main-r4ds-1/master/dados/imdb.csv")

# Jeitos de dar uma olhada na base ----------------------------------------

names(imdb)
head(imdb, 10)
tail(imdb, 10)

glimpse(imdb)

# install.packages("skimr")
library(skimr)

skim(imdb)
# dá um resuminho de como a base é!

# Manipulações ------------------------------------------------------------

# pacote dplyr, que mora no tidyverse

# muitas coisas que a gente quer fazer com uma tabela
# dá pra fazer misturando 6 em alguma ordem 6 verbos:

# select - SELECIONAR coluna
# filter - FILTRAR (manter ou remover) linhas
# arrange - ORDERNAR as linhas de acordo com colunas
# mutate - CRIAR colunas novas (a partir de pré existentes ou não)
# summarize - SUMARIZAR a tabela em um resumo menor (transformar as 28k linhas em uma média, ou variancia ou maximo, minimo etc)
# join_ - UNIR duas tabelas de acordo com uma chave (PROCV!)

####### EXEMPLO CONCEITUAL

# Desejo: a partir da tabela IMDB eu quero chegar em uma tabela que
# tem a média de nota no imdb dos filmes que saíram depois de 2000.

# Existe uma sequência de passos usando os 6 verbos que chega nisso:

# 1. PEGUE a base IMDB
# 2. FILTRE apenas aquelas linhas em que a coluna ano é >= 2000
# 3. SUMARIZE o resultado de 2. extraindo a média da coluna nota_imdb.

# agora teria um terceiro passo...

# que é transformar esse "esquema" passo-a-passo em um código em R
# vamos aprender nas próximas aulas!

# vamos começar com sequências de aplicações de verbo que tem 1 passo só

# select ------------------------------------------------------------------

# pedido: a tabela imdb é muito grande... quero ver uma versão dela
# que só tenha o nome, o ano e o a nota no imdb

# pra isso serve o select!!!

# 1. pegue o IMDB
# 2. SELECIONE apenas as colunas "nome do filme", "ano" e "nota no imdb"

# agora em R:

select(imdb, titulo)
# começando só pelo título
# o resultado ainda é uma tabela!

imdb_nota_ano <- select(imdb, titulo, ano, nota_imdb)
# posso guardar num objeto!

imdb_nota_ano_direcao <- select(imdb, titulo, ano, nota_imdb, direcao)

View(imdb_nota_ano_direcao)

select(imdb, data_lancamento, ano, titulo, direcao)

select(imdb, titulo:duracao)
# no excel A1:D1
# no R
1:10

select(imdb, num_avaliacoes, num_criticas_publico, num_criticas_critica)
# explícito

select(imdb, starts_with("num"))
# resumido

select(imdb, ends_with("cao"))
# resumido

select(imdb, contains("critica"))

# tem funções principais que a gente pode colocar dentro do select
# (normalmente a gente usa dentro do select só nome de coluna
# da tabela OU essas funções (que no fim viram colunas tb))

# starts_with("padrão")
# ends_with("padrão")
# contains("padrão")

#IMPORTANTE!

# o select precisa começar sempre por uma tabela:
# select(TABELA, colunas/funções)
# TABELA no nosso caso é IMDB

minha_tabela <- select(imdb, titulo, direcao, nota_imdb, contains("num"))
# podemos misturar!

View(minha_tabela)

# o select também remove!

imdb_sem_titulo <- select(imdb, -titulo)

imdb_sem_num <- select(imdb, -contains("num"))

# o - só funciona desse jeito no SELECT
# nem nos outros 6 comandos nem nos outros comandos do R em geral
# é garantido que - vai funcionar. às vezes vai, mas não sempre

# arrange -----------------------------------------------------------------

minha_tabela

arrange(minha_tabela, nota_imdb)

arrange(minha_tabela, -nota_imdb)
# aqui "inverte"

# pedido: quais são os 10 filmes pior avaliados?

# 1. pegue a tabela IMDB
# 2. ORDENE pena nota_imdb
# 3. SELECIONE apenas a coluna titulo
# 4. pegue as 10 primeiras linhas de 3. (aqui não é do dplyr, mas temos a função head)

imdb_ordenado <- arrange(imdb, nota_imdb)
imdb_ordenado_titulos <- select(imdb_ordenado, titulo, nota_imdb)
head(imdb_ordenado_titulos, 10)

# pedidos: 10 filmes MELHOR avaliados??

imdb_ordenado <- arrange(imdb, -nota_imdb)
imdb_ordenado_titulos <- select(imdb_ordenado, titulo, nota_imdb)
head(imdb_ordenado_titulos, 10)


# o que pode dar errado até aqui? -----------------------------------------

# no select podemos escrever nomes de colunas que não existem:

select(imdb, titlo)
# erro de que coluna não existe!
# o correto seria
select(imdb, titulo)

# um erro mais zuado

select(imbd, titulo)
# erro que me diz que ele não achou uma tabela
# que se chama imbd

select(imdb, "titulo")
# isso não é erro! funciona...

# erros:

select(imdb, titulo ano)
# esquecer de colocar vírgula
# o bom é que fica com o X do lado ^

select(imdb, Titulo)
# o R diferencia maiúsculas e minúsculas!
# tem que tomar cuidado

# esquecer de salvar/rodar causa erro:

arrange(imdb, -nota_imdb)
imdb_ordenado_titulos <- select(imdb_ordenado_nota, titulo, nota_imdb)
# esses comandos, isoladamente, dão erro! eu não crei um objeto
# "imdb_ordenado_nota"
# mesmo escrevendo corretamente:

imdb_ordenado_nota <- arrange(imdb, -nota_imdb)
imdb_ordenado_titulos <- select(imdb_ordenado_nota, titulo, nota_imdb)

# tem que lembrar de rodar!!! se não lembrar já era

# Intervalo - Aula 4 ---------------------------------------------------------------


# filter ------------------------------------------------------------------

# nome_da_funcao(base_de_dados, regra)

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


imdb |>
  filter(direcao == "Quentin Tarantino") |>
  View()

imdb |>
  filter(
    direcao == "Quentin Tarantino",
    producao == "Miramax"
  ) |>
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

imdb |>
  filter(ano > 2010, nota_imdb > 8.5, num_avaliacoes > 1000) |>
  View()
imdb |> filter(ano > 2010 & nota_imdb > 8.5)

## Gastaram menos de 100 mil, faturaram mais de 1 milhão
imdb |>
  filter(orcamento < 100000, receita > 1000000) |>
  View()

## Lucraram
imdb |>
  filter(receita - orcamento > 0) |>
  View()

imdb |>
  # é NA na receita OU é NA no orçamento
  # OU - satisfazer pelo menos uma das comparacoes/condicoes
  filter(is.na(receita) | is.na(orcamento)) |>
  # nrow()
  View()




## Comparações lógicas -------------------------------

x != 2
x != 1

# Exemplo com filtros!
imdb |>
  filter(direcao != "Quentin Tarantino") |>
  View()

## Comparações lógicas -------------------------------

# operador %in%
# o x é igual à 1
# o x faz parte do conjunto 1, 2 e 3? SIM
x %in% c(1, 2, 3)
# o x faz parte do conjunto 2, 3 e 4? NÃO
x %in% c(2, 3, 4)

# Exemplo com filtros!


# O operador %in%

imdb |>
  filter(direcao %in% c("Matt Reeves", "Christopher Nolan")) |>
  View()

# dá pra reescrever com o OU
imdb |>
  filter(
    direcao == "Matt Reeves" | direcao == "Christopher Nolan"
  )


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


# <-


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

imdb |>
  filter(!is.na(orcamento)) |>
  View()



imdb |>
  filter(!is.na(orcamento), !is.na(receita)) |>
  View()


#

imdb |>
  mutate(descricao_minusculo = str_to_lower(descricao)) |>
  filter(str_detect(descricao_minusculo, "woman|hero|friend")) |>
  View()


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



# ISSO DÁ ERRO
filter(imdb, orcamento == NA)

# contar os NA quando a variavel é categórica/texto
count(imdb, producao, sort = TRUE) |> View()

# para numéricos, assim é mais fácil
filter(imdb, is.na(orcamento)) |>
  nrow()
# tambem funciona para texto
filter(imdb, is.na(producao)) |>
  nrow()



# filtrar textos sem correspondência exata

textos <- c("a", "aa", "abc", "bc", "A", NA)
textos

library(stringr) # faz parte do tidyverse

str_detect(textos, pattern = "a")

str_view_all(textos, "a")

# validacao do padrao usado
str_view_all(imdb$descricao[1:10], "woman|movie", html = TRUE)


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
imdb |> filter(generos == "Crime")

# INTERVALO!



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
  mutate(lucro = receita - orcamento, .after = receita) |>
  View()


lucro_filmes <- imdb |>
  drop_na(orcamento, receita) |>
  select(titulo, ano, receita, orcamento) |>
  mutate(
    lucro = receita - orcamento,
    lucrou = lucro > 0,
    .after = orcamento
  ) |>
  arrange(lucro)


# A função ifelse é uma ótima ferramenta
# para fazermos classificação binária (2 CATEGORIAS)

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
      nota_imdb >= 5 & nota_imdb < 8 ~ "Média",
      nota_imdb < 5 ~ "Baixa",
      .default = "Outros"
      #  TRUE ~ "CATEGORIZAR" # Em alguns lugares aparece assim
    )
  )

nota_categorizada |>
  count(categoria_nota)

# classificacao com mais de 2 categorias:
# usar a função case_when()

imdb |>
  mutate(
    categoria_nota = case_when(
      nota_imdb >= 8 ~ "Alta",
      nota_imdb < 8 & nota_imdb >= 5 ~ "Média",
      nota_imdb < 5 ~ "Baixa",
      TRUE ~ "Não classificado"
    )
  ) |>
  View()


# summarise ---------------------------------------------------------------


# summarise(base_de_dados,
# nome_coluna_criar = operacao_que_quer_fazer,
# ...
# )

# funcao que sumariza - é bom para summarise
min(imdb$nota_imdb)

max(imdb$nota_imdb)

mean(imdb$nota_imdb)

sd(imdb$nota_imdb)

# não sumariza - bom para mutate
round(imdb$nota_imdb)

# Sumarizando uma coluna

imdb |>
  summarise(media_orcamento = mean(orcamento, na.rm = TRUE))

# repare que a saída ainda é uma tibble


# Sumarizando várias colunas
imdb |> summarise(
  media_orcamento = mean(orcamento, na.rm = TRUE),
  media_receita = mean(receita, na.rm = TRUE),
  media_lucro = mean(receita - orcamento, na.rm = TRUE)
)

# Diversas sumarizações da mesma coluna
imdb |> summarise(
  media_orcamento = mean(orcamento, na.rm = TRUE),
  mediana_orcamento = median(orcamento, na.rm = TRUE),
  variancia_orcamento = var(orcamento, na.rm = TRUE),
  variancia_orcamento = var(orcamento, na.rm = TRUE),
  desvio_padrao_orcamento = sd(orcamento, na.rm = TRUE)
)

# Tabela descritiva
imdb |> summarise(
  media_orcamento = mean(orcamento, na.rm = TRUE),
  media_receita = mean(receita, na.rm = TRUE),
  qtd = n(),
  qtd_direcao = n_distinct(direcao)
)


# n_distinct() é similar à:
imdb |>
  distinct(direcao) |>
  nrow()


# funcoes que transformam -> N valores
log(1:10)
sqrt()
str_detect()

# funcoes que sumarizam -> 1 valor - FUNÇÕES BOAS PARA SUMMARISE
mean(c(1, NA, 2))
mean(c(1, NA, 2), na.rm = TRUE)
n_distinct()


# group_by + summarise ----------------------------------------------------

# Agrupando a base por uma variável.

imdb |> group_by(producao)

# Agrupando e sumarizando
imdb |>
  group_by(producao) |>
  summarise(
    media_orcamento = mean(orcamento, na.rm = TRUE),
    media_receita = mean(receita, na.rm = TRUE),
    qtd = n(),
    qtd_direcao = n_distinct(direcao)
  ) |>
  arrange(desc(qtd))

# Agrupando e sumarizando
imdb |>
  group_by(direcao) |>
  summarise(
    media_orcamento = mean(orcamento, na.rm = TRUE),
    media_receita = mean(receita, na.rm = TRUE),
    media_nota = mean(nota_imdb),
    qtd = n(),
    nome_filmes = paste(titulo, collapse = ", "),
  ) |>
  arrange(desc(qtd))



imdb |>
  separate_longer_delim(direcao, delim = ", ", ) |>
  group_by(direcao) |>
  summarise(
    media_orcamento = mean(orcamento, na.rm = TRUE),
    media_receita = mean(receita, na.rm = TRUE),
    media_nota = mean(nota_imdb),
    qtd = n(),
    nome_filmes = paste(titulo, collapse = "; "), # knitr::combine_words()
  ) |>
  arrange(desc(qtd)) |>
  View()


imdb_tarantino <- imdb |>
  separate_longer_delim(direcao, delim = ", ", ) |>
  filter(direcao == "Quentin Tarantino")

imdb_tarantino$titulo

paste(imdb_tarantino$titulo, collapse = "; ")



paste("x", "y")



# left join ---------------------------------------------------------------

# tem mais que uma tabela

# queremos unir em tabela única

# coluna chave serve pra unir as tabelas

# dados do pacote abjData
# install.packages("abjData")
library(abjData)

abjData::pnud_uf

library(tidyverse)
dados_pnud <- pnud_min

# install.packages("geobr")
library(geobr)
shape <- read_municipality("CE")
glimpse(shape)


dados_pnud_2010 <- dados_pnud |>
  filter(ano == 2010) |>
  mutate(
    code_muni = muni_id,
    abbrev_state = uf_sigla
  )

# queremos fazer uma base que tenha os dados do shape
# junto com dados do pnud

shape_ce_pnud <- shape |>
  mutate(code_muni = as.character(code_muni)) |>
  left_join(dados_pnud_2010, by = c("code_muni", "abbrev_state"))


shape_ce_pnud |>
  ggplot() +
  geom_sf(aes(fill = idhm))


# A função left join serve para juntarmos duas
# tabelas a partir de uma chave.
# Vamos ver um exemplo bem simples.

band_members 
band_instruments

band_members |>
  left_join(band_instruments)

# name | band | plays
# 1 Mick  Stones | NA
# 2 John  Beatles | guitar
# 3 Paul  Beatles | bass


band_instruments |>
  left_join(band_members)

# name | plays | band

# A ordem do left_join() importa!


# o argumento 'by'
band_members |>
  left_join(band_instruments, by = "name")

# OBS: existe uma família de joins

band_instruments |>
  left_join(band_members)

band_instruments |>
  full_join(band_members) # mantem todos os dados das duas tabelas


band_instruments |>
  inner_join(band_members) # só vai aparecer o que tem em comum


band_instruments |> 
  anti_join(band_members) # só vai aparecer o que NÃO tem em comum


band_instruments |>
  right_join(band_members) # sao poucos casos onde é util!

band_members |>
  left_join(band_instruments)


# Um exemplo usando a outra base do imdb

imdb <- read_rds("dados/imdb.rds")
imdb_avaliacoes <- read_rds("dados/imdb_avaliacoes.rds")

imdb |>
  left_join(imdb_avaliacoes, by = "id_filme") |>
  View()

imdb |>
  full_join(imdb_avaliacoes, by = "id_filme") |>
  View()
