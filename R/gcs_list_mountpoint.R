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
    system_out <- system2("df", "-TP --type=fuse", stdout = TRUE)
    system_out[1] <- sub("Mounted on", "Mounted", system_out[1], fixed = TRUE)
    splited_result <- lapply(system_out, function(x) strsplit(x, " +"))
    headers <- splited_result[[1]][[1]]
    splited_result <- splited_result[-1]
    ind <- c(which(headers == "Filesystem"),
             which(headers == "Mounted"))
    final <- as.data.frame(t(vapply(splited_result, function(x) x[[1]][ind], character(2))))
    colnames(final) <- c("bucket", "mountpoint")
    final
}



