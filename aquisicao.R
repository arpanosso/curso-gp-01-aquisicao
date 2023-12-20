url_filename <- dir("url/",pattern = ".txt") # nome do arquivo txt

urls <- read.table(paste0("url/",url_filename)) # leu as urls dentro do arquivo



n_urls <- nrow(urls) # numero de linhas no arquivo urls

n_split <- length(stringr::str_split(urls[1,1],"/",simplify=TRUE))

n_split

filenames_nc <- stringr::str_split_fixed(urls[,1],"/",n=Inf)[,n_split] # armazenando o nome dos arquivos
filenames_nc

#### download

for(i in 1:n_urls){
  repeat{
    dw <- try(download.file(urls[i,1],
                            paste0("data-raw/",filenames_nc[i]),
                            method="wget",
                            extra= c("--user=alan.panosso --password FMB675fmb675@")
    ))
    if(!(inherits(dw,"try-error")))
      break
  }
}
