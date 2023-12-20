files_names <- list.files("data-raw/",
                          pattern = "nc")


exm <- ncdf4::nc_open(
  paste0("data-raw/",files_names[1])
)
typeof(exm)

for(i in 1:length(files_names)){
  if(i==1){
    df <- ncdf4::nc_open(paste0("data-raw/",files_names[i]))
    if(df$ndims==0){

    }else{
      xco2 <- data.frame(
        "longitude"=ncdf4::ncvar_get(df,varid="longitude"),
        "latitude"=ncdf4::ncvar_get(df,varid="latitude"),
        "time"=ncdf4::ncvar_get(df,varid="time"),
        "xco2"=ncdf4::ncvar_get(df,varid="xco2"),
        "xco2_quality_flag"=ncdf4::ncvar_get(df,varid="xco2_quality_flag"),
        "xco2_incerteza"=ncdf4::ncvar_get(df,varid="xco2_uncertainty")
      ) |>
        dplyr::filter(xco2_quality_flag==0) # quality = 0 ==> obs sem nuvem
    }
    ncdf4::nc_close(df)
  }else{
    df_a <- ncdf4::nc_open(paste0("data-raw/",files_names[i]))
    if(df_a$ndims == 0){

    }else{
      xco2_a <- data.frame(
        "longitude"=ncdf4::ncvar_get(df_a,varid="longitude"),
        "latitude"=ncdf4::ncvar_get(df_a,varid="latitude"),
        "time" = ncdf4::ncvar_get(df_a,varid="time"),
        "xco2" = ncdf4::ncvar_get(df_a,varid="xco2"),
        "xco2_quality_flag"=ncdf4::ncvar_get(df_a,varid="xco2_quality_flag"),
        "xco2_incerteza"=ncdf4::ncvar_get(df_a,varid="xco2_uncertainty")
      ) |>
        dplyr::filter(xco2_quality_flag==0)
    }
    ncdf4::nc_close(df_a)
    xco2 <- rbind(xco2,xco2_a) # stack = empilhar as tabelas
  }
}



