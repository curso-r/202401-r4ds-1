
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
