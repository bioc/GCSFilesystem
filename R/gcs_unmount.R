#' Unmound a mounted GCS file system
#' 
#' Unmound a mounted GCS file system
#' 
#' @param mountpoint The path to the mounted GCS file system.
#' @return No return value
#' @examples 
#' ## Unmount the Z driver letter
#' ## Z driver must be a GCS mount point
#' gcs_unmount("Z")
#' @export
gcs_unmount <- function(mountpoint){
    check_required_program()
    os <- get_os()
    mountpoint <- normalizePath(mountpoint, mustWork = FALSE,
                                winslash = "/")
    if(os == "windows"){
        gcs_unmount_win(mountpoint)
    }else if(os == "linux"){
        gcs_unmount_linux(mountpoint)
    }else if(os == "osx"){
        gcs_unmount_linux(mountpoint)
    }else{
        stop("Unsupported system")
    }
    ## remove the mountpoint if the folder is empty
    if(dir.exists(mountpoint)){
        all_files <- list.files(mountpoint,
                                all.files=TRUE,
                                include.dirs=TRUE)
        all_files <- all_files[!all_files%in%c(".","..")]
        if(length(all_files) == 0){
            unlink(mountpoint, recursive = TRUE)
        }
    }
    invisible()
}


gcs_unmount_win <- function(mountpoint){
    system2("GCSDokan", c("-u", mountpoint))
}
gcs_unmount_linux <- function(mountpoint){
    system2("fusermount", c("-u", mountpoint))
}

gcs_unmount_mac <- function(mountpoint){
    system2("umount", mountpoint)
}




