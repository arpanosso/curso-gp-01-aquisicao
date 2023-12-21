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

# criando a função para o download
my_ncdf4_download <- function(url_unique){
  n_split <- length(
    stringr::str_split(url_unique,
                       "/",
                       simplify=TRUE))
  filenames_nc <- stringr::str_split(url_unique,
                                     "/",
                                     simplify = TRUE)[,n_split]
  repeat{
    dw <- try(download.file(url_unique,
                            paste0("data-raw/",filenames_nc),
                            method="wget",
                            extra= c("--user=seu.nome --password suasenha")
    ))
    if(!(inherits(dw,"try-error")))
      break
  }
}
my_ncdf4_download(urls[1,1])

# Vamos testar com 3 arquivos e observar o tempo de
# demora
tictoc::tic()
purrr::map(urls[1:3,1],my_ncdf4_download)
tictoc::toc()

# Usando multisession
# Vamos testar com 3 arquivos e observar o tempo de
# demora
future::plan("multisession")
tictoc::tic()
furrr::future_map(urls[1:3,1],my_ncdf4_download)
tictoc::toc()

# Vamos fazer o download de todos
tictoc::tic()
furrr::future_map(urls[,1],my_ncdf4_download)
tictoc::toc()
