# Baixando e descompactando
# https://transparencia.metrosp.com.br/dataset/pesquisa-origem-e-destino


url_od_2017 <- "https://transparencia.metrosp.com.br/sites/default/files/OD-2017.zip"

# fazer o download, indicar o caminho onde queremos que seja baixado
download.file(url_od_2017, destfile = "dados/dados_od_2017_sp.zip")


# descompactar o zip
utils::unzip("dados/dados_od_2017_sp.zip", 
             exdir = "dados/dados_od_2017_sp/")

# PESQUISAR O ERRO: 
# Error in utils::unzip("dados/dados_od_2017_sp.zip", 
# exdir = "dados/dados_od_2017_sp/") : 
#   cannot open file 
# 'dados/dados_od_2017_sp//OD-2017/Banco de Dados-OD2017/CORRESPOND�NCIA ENTRE 
# ZONAS 2007 e 2017.xlsx': Illegal byte sequence

