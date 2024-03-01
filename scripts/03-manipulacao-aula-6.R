# Pacotes -----------------------------------------------------------------
library(tidyverse)

# Base de dados -----------------------------------------------------------

imdb <- read_rds("dados/imdb.rds")

# PRÓXIMA AULA: COMEÇAR COM O EXERCICIO EXTRA DO 3.1 - ok

# PRÓXIMA AULA: REVISAR O case_when() - OK!

# PRÓXIMA AULA: DÚVIDA ELIANA - CONVERTER NA DE UMA COLUNA EM 0 - OK!

# PRÓXIMA AULA: TRABALHO FINAL - OK!

# PRÓXIMA AULA: ESQUISSE - ok 


imdb_classe_lucro <- imdb |> 
  mutate(lucro = receita - orcamento,
         classe_lucro = case_when(
           is.na(orcamento) & is.na(receita) ~ "Lucro não calculado: sem informação de receita e orçamento",
           is.na(orcamento) ~ "Lucro não calculado: sem informação de orçamento",
           is.na(receita) ~ "Lucro não calculado: sem informação de receita",
           lucro > 0 ~ "Lucro positivo",
           lucro < 0 ~ "Prejuízo",
           TRUE ~ "CATEGORIZAR"
         ),
         .after = receita) 


# summarise ---------------------------------------------------------------

nota_descritiva <- imdb |> 
  summarise(
    # nome_da_coluna_que_queremos_criar = operacao cujo resultado será salvo nessa coluna
    quantidade_filmes = n(),
    media_nota = mean(nota_imdb),
    mediana_nota = median(nota_imdb),
    variancia_nota = var(nota_imdb),
    desvio_padrao_nota = sd(nota_imdb),
    max_nota = max(nota_imdb),
    min_nota = min(nota_imdb),
    amplitude = max_nota - min_nota
  ) 



imdb_classe_lucro |> 
  group_by(classe_lucro) |> 
  summarise(
    # nome_da_coluna_que_queremos_criar = operacao cujo resultado será salvo nessa coluna
    quantidade_filmes = n(),
    media_nota = mean(nota_imdb),
    mediana_nota = median(nota_imdb),
    variancia_nota = var(nota_imdb),
    desvio_padrao_nota = sd(nota_imdb),
    max_nota = max(nota_imdb),
    min_nota = min(nota_imdb),
    amplitude = max_nota - min_nota
  ) |> View()





imdb |> 
  group_by(producao) |> 
  summarise(
    # nome_da_coluna_que_queremos_criar = operacao cujo resultado será salvo nessa coluna
    quantidade_filmes = n(),
    media_nota = round(mean(nota_imdb), 2),
    mediana_nota = median(nota_imdb),
    variancia_nota = round(var(nota_imdb), 2),
    desvio_padrao_nota = sd(nota_imdb),
    max_nota = max(nota_imdb),
    min_nota = min(nota_imdb),
    amplitude = max_nota - min_nota
  ) |> 
  filter(quantidade_filmes > 0) |> 
  arrange(desc(quantidade_filmes)) 


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

imdb_classe_lucro |> 
  summarise(
    n_grupos = n_distinct(classe_lucro)
  )



imdb$direcao
unique(imdb$direcao) |> length()

# n_distinct() é similar à:
imdb |>
  distinct(direcao) |>
  nrow()





# funcoes que transformam -> N valores
log(1:10)
sqrt(1:10)
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
    nome_filmes = paste(titulo, collapse =", "),
  ) |>
  arrange(desc(qtd)) |> View()




imdb_uma_linha_por_diretor <- imdb |> 
  separate_longer_delim(direcao, delim = ",") |> 
  mutate(direcao = str_trim(direcao))


imdb_uma_linha_por_diretor |> 
  group_by(id_filme) |> 
  mutate(numero_de_linhas = n()) |>
  View()

imdb_uma_linha_por_diretor |> 
  group_by(direcao) |> 
  summarise(
    qtd_filmes = n(),
    media_nota = mean(nota_imdb)
  ) |> 
  arrange(desc(media_nota)) |> 
  filter(qtd_filmes > 1)



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

paste(imdb_tarantino$titulo, collapse = ", ")

mean(imdb_tarantino$nota_imdb)

paste0("x", "y")



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
geobr::list_geobr() |> View()
shape <- read_municipality("CE")
glimpse(shape)



glimpse(dados_pnud)


ceara_shape <- shape |> 
  mutate(muni_id = as.character(code_muni)) |> 
  left_join(dados_pnud, by = "muni_id") 


ceara_shape |> 
  ggplot() +
  geom_sf(aes(fill = gini)) +
  facet_wrap(~ano)



############

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
