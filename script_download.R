source("R/my-functions.R")

# Encontrando o caminho do arquivo .txt que contem as urls para o download
# dos arquivos
url_filename <- list.files("url/",
                           pattern = ".txt",
                           full.names = TRUE) # nome do arquivo txt

# Lendo as urls em um data.frame com a coluna V1 de urls.
# filter e str_detect retira as urls refrente ao download
# dos arquivos .pdf.
urls <- read.table(url_filename) |>
  dplyr::filter(!stringr::str_detect(V1,".pdf"))

# Extraindo o número de linhas do arquivo, número de urls
n_urls <- nrow(urls)


my_ncdf4_download(urls[1,1],
                  user="",
                  password = "")

# Vamos testar com 3 arquivos e observar o tempo de
# demora
tictoc::tic()
purrr::pmap(list(urls[1:3,1],
                 "input your user",
                 "your password"),
            my_ncdf4_download)
tictoc::toc()

# Usando multisession
# Vamos testar com 3 arquivos e observar o tempo de
# demora
future::plan("multisession")
tictoc::tic()
furrr::future_pmap(list(urls[1:3,1],
                        "input your user",
                        "your password"),
                   my_ncdf4_download)
tictoc::toc()

# Vamos fazer o download de todos
tictoc::tic()
furrr::future_pmap(list(urls[,1],"input your user","your password"),my_ncdf4_download)
tictoc::toc()
