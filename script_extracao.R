source("R/my-functions.R")
files_names <- list.files("data-raw/",
                          pattern = "nc")


exm <- ncdf4::nc_open(
  paste0("data-raw/",files_names[1])
)
typeof(exm)

for(i in 1:length(files_names)){
  df <- ncdf4::nc_open(paste0("data-raw/",files_names[i]))
  if(df$ndims!=0){
    if(i==1){
      xco2 <- my_ncdf4_extractor(df)
    }else{
      xco2 <- rbind(xco2,my_ncdf4_extractor(df)) # stack = empilhar as tabelas
    }
  }
  ncdf4::nc_close(df)
}
dplyr::glimpse(xco2)

xco2 <- xco2 |>
  dplyr::mutate(
    date = as.Date.POSIXct(time)
  )
# install.packages("readr")
readr::write_rds(xco2, "data/arquivo_xco2.rds")

xco2 <- readr::read_rds("data/arquivo_xco2.rds")
xco2 |>
  dplyr::sample_n(1000) |>
  ggplot2::ggplot(ggplot2::aes(x=date,y=xco2)) +
  ggplot2::geom_point() +
  ggplot2::geom_line()

xco2 |>
  dplyr::sample_n(1000) |>
  ggplot2::ggplot(ggplot2::aes(x=xco2, y=..density..)) +
  ggplot2::geom_histogram(bins = 9,
                          color="black",
                          fill="gray") +
  ggplot2::geom_density(fill="red",alpha=0.05) +
  ggplot2::theme_bw()
