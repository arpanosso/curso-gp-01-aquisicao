# Carregnado minhas funções
source("R/my-functions.R")

# Buscando o caminho de todos os arquivos ncdf4 na pasta
files_names <- list.files("data-raw/",
                          pattern = "nc",
                          full.names = TRUE)

# Abrindo um arquivo, e identificando o tipo deste (lista)
exm <- ncdf4::nc_open(files_names[1])
typeof(exm)

# Utilizando a função previamente criada para extrair
# as colunas do meu arquivo ncdf4
my_ncdf4_extractor(files_names[1])

# estraindo e empilhando os arquivos utilizando a função
# map do pacote purrr
xco2 <- purrr::map_df(files_names, my_ncdf4_extractor) |>
  dplyr::mutate(
    date = as.Date.POSIXct(time)
  )
dplyr::glimpse(xco2)

# Salvando o arquivo tratado na pasta data
readr::write_rds(xco2, "data/arquivo_xco2.rds")

# Lendo o arquivo novamente
xco2 <- readr::read_rds("data/arquivo_xco2.rds")
dplyr::glimpse(xco2)

# Gráfico de Dispersão de pontos ao longo do tempo
xco2 |>
  dplyr::sample_n(1000) |>
  ggplot2::ggplot(ggplot2::aes(x=date,y=xco2)) +
  ggplot2::geom_point() +
  ggplot2::geom_line()

# Histograma de xco2
xco2 |>
  dplyr::sample_n(1000) |>
  ggplot2::ggplot(ggplot2::aes(x=xco2, y=..density..)) +
  ggplot2::geom_histogram(bins = 9,
                          color="black",
                          fill="gray") +
  ggplot2::geom_density(fill="red",alpha=0.05) +
  ggplot2::theme_bw()
