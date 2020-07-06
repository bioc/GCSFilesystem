gcs_mount <- function(bucket, mountpoint, implicit_dirs = TRUE){
    
    ## Determine if the folder-like structure will be used
    if(implicit_dirs){
        args <- "--implicit-dirs"
    }else{
        args <- character()
    }
    ## Load the credentials file if needed
    if(!GCSConnection:::.is_gcloud()){
        args <- c(args, paste0("--key-file=\"", GCSConnection:::.json_path(),"\""))
    }
    
    args <- c(args, bucket, mountpoint)
    ## Create the mountpoint folder if it does not exist
    if(!file.exists(mountpoint)){
        dir.create(mountpoint)
    }
    gcs_mount_linux(args)
}

gcs_mount_linux <- function(args){
    if(!command_exist("gcsfuse")){
        stop("You do not have <gcsfuse> installed!")
    }
    system2("gcsfuse", args)
}