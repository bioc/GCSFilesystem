#' Unmound a mounted GCS file system
#' 
#' Unmound a mounted GCS file system
#' 
#' @param mountpoint The path to the mounted GCS file system,
#' the value must match the one in `gcs_list_mountpoints`.
#' @return No return value
#' @examples 
#' ## Unmount the Z driver letter
#' ## Z driver must be a GCS mount point
#' gcs_unmount("Z")
gcs_unmount <- function(mountpoint){
    check_required_program()
    os <- get_os()
    mp <- gcs_list_mountpoints()
    if(os == "windows"){
        gcs_unmount_win(mountpoint)
    }else if(os == "linux"){
        gcs_unmount_linux(mountpoint)
    }else if(os == "osx"){
        
    }else{
        stop("Unsupported system")
    }
}


gcs_unmount_win <- function(mountpoint){
    system2("GCSDokan", c("-u", mountpoint))
}



gcs_unmount_linux <- function(mountpoint){
    system2("fusermount", c("-u", mountpoint))
}




