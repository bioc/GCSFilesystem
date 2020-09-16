#' Unmound a mounted GCS file system
#' 
#' Unmound a mounted GCS file system
#' 
#' @param mountpoint The path to the mounted GCS file system.
#' @return No return value
#' @examples 
#' ## Unmount a directory
#' ## No operation will be done 
#' ## if the directory does not exist or
#' ## not a mounted directory
#' gcs_unmount("path_to_your_mounted_directory")
#' @export
gcs_unmount <- function(mountpoint){
    if(!check_required_program()){
        return()
    }
    os <- get_os()
    mountpoint <- normalizePath(mountpoint, mustWork = FALSE,
                                winslash = "/")
    if(os == "windows"){
        gcs_unmount_win(mountpoint)
    }else if(os == "linux"){
        gcs_unmount_linux(mountpoint)
    }else if(os == "osx"){
        gcs_unmount_mac(mountpoint)
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
    system2("GCSDokan", paste0("-u ", "\"", mountpoint, "\""))
}
gcs_unmount_linux <- function(mountpoint){
    tryCatch(
        system2("fusermount", paste0("-u -z ", "\"", mountpoint, "\"")),
        error= function(e){
            if(length(grep("Device or resource busy", e,fixed = TRUE))!=0){
                Sys.sleep(3)
                system2("fusermount", paste0("-u -z ", "\"", mountpoint, "\""))
            }
            else{
                message(e)
                return()
            }
        }
    )
}

gcs_unmount_mac <- function(mountpoint){
    system2("umount", paste0("\"", mountpoint, "\""))
}




