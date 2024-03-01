# Resposta do exercício extra:


# Exercício extra ------------------------------
# Usando de exemplo dados abertos da Câmara,
# faça a importação de dados dos DEPUTADOS.
# Descrição:
# Lista com identificadores e informações sobre todos os
# parlamentares que já estiveram em exercício em algum
# momento na história da Câmara.
# Link da página:
# https://dadosabertos.camara.leg.br/swagger/api.html#staticfile
# Dica: utilize a funcionalidade "import dataset" do RStudio.
library(tidyverse)
library(readr)
deputados <-
  read_delim(
    "https://dadosabertos.camara.leg.br/arquivos/deputados/csv/deputados.csv",
    delim = ";",
    escape_double = FALSE,
    col_types = cols(dataNascimento = col_date(format = "%Y-%m-%d")),
    trim_ws = TRUE
  )

glimpse(deputados)

# paste0 - colar valores -----------------


# 2008 até 2023
# https://www.camara.leg.br/cotas/Ano-2023.csv.zip

ano_para_buscar <- 2012

# paste adiciona espaços
paste("https://www.camara.leg.br/cotas/Ano-",
      ano_para_buscar,
      ".csv.zip")


# paste0 não adiciona espaços
paste0("https://www.camara.leg.br/cotas/Ano-",
       ano_para_buscar,
       ".csv.zip")


anos_com_dados <- 2008:2023

links_para_baixar <- paste0("https://www.camara.leg.br/cotas/Ano-",
                            anos_com_dados,
                            ".csv.zip")



# Dúvida Eliana: substituir NA por 0 -----------------------

# visualizando os NAs
naniar::gg_miss_var(deputados)


deputados_alterado <- deputados |>
  mutate(# funcao replace_na altera os NAs de uma coluna por algum valor que
    # indicamos
    uf_nascimento = replace_na(ufNascimento, "0"))

# visualizando os NAs
naniar::gg_miss_var(deputados_alterado)

deputados_alterado |>
  count(uf_nascimento)


# esquisse -----------------------
library(ggplot2)

library(esquisse)
ggplot(diamonds) +
  aes(x = "", y = x, fill = cut) +
  geom_boxplot() +
  scale_fill_viridis_d(option = "viridis", direction = 1) +
  ggthemes::theme_fivethirtyeight() +
  theme(legend.position = "top")



# The mtcars dataset is natively available
# head(mtcars)

# A really basic boxplot.
ggplot(mtcars, aes(x = as.factor(cyl), y = mpg)) +
  geom_boxplot(fill = "slateblue", alpha = 0.2) +
  xlab("cyl")
