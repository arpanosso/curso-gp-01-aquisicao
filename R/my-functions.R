#' Função utilizada para extração de colunas
#' específicas de arquivo ncdf4 para xco2
my_ncdf4_extractor <- function(ncdf4_file){
  data_frame_name <- ncdf4::nc_open(ncdf4_file)
  if(data_frame_name$ndims!=0){
    dft <- data.frame(
      "longitude"=ncdf4::ncvar_get(data_frame_name,varid="longitude"),
      "latitude"=ncdf4::ncvar_get(data_frame_name,varid="latitude"),
      "time"=ncdf4::ncvar_get(data_frame_name,varid="time"),
      "xco2"=ncdf4::ncvar_get(data_frame_name,varid="xco2"),
      "xco2_quality_flag"=ncdf4::ncvar_get(data_frame_name,varid="xco2_quality_flag"),
      "xco2_incerteza"=ncdf4::ncvar_get(data_frame_name,varid="xco2_uncertainty")
    ) |>
      dplyr::filter(xco2_quality_flag==0) |>
      tibble::as_tibble()
    }
  ncdf4::nc_close(data_frame_name)
  return(dft)
}

#' Função utilizada para downloads
my_ncdf4_download <- function(url_unique,
                              user="input your user",
                              password="input your password"){
  if(is.character(user)==TRUE & is.character(password)==TRUE){
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
                              extra= c(paste0("--user=", user,
                                              " --password ",
                                              password))
      ))
      if(!(inherits(dw,"try-error")))
        break
    }
  }else{
    print("seu usuário ou senha não é uma string")
  }
}
