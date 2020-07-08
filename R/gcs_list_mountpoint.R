gcs_list_mountpoint <- function(){
    os <- get_os()
    if(os == "windows"){
        
    }else if(os == "linux"){
        gcs_list_mountpoint_linux()
    }else if(os == "osx"){
        
    }else{
        stop("Unsupported system")
    }
}

gcs_list_mountpoint_linux <- function(){
    col_names <- c("bucket", "mountpoint")
    col_num <- length(col_names)
    system_out <- suppressWarnings(
        system2("df", c("--type=fuse","--output=source,target"), stdout = TRUE, stderr = NULL))
    if(length(system_out) == 0){
        return(setNames(data.frame(matrix(ncol = col_num, nrow = 0)), col_names))
    }
    system_out <- system_out[-1]
    splited_result <- lapply(system_out, function(x) strsplit(x, " +"))
    final <- as.data.frame(matrix(unlist(splited_result), ncol = col_num, byrow = TRUE))
    colnames(final) <- column_names
    final
}



