gcs_mount <- function(bucket, mountpoint, mode = c("rw", "r"), implicit_dirs = TRUE){
    mode <- match.arg(mode)
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
    
    if(os == "windows"){
        
    }else if(os == "linux"){
        gcs_mount_linux(args, mode)
    }else if(os == "osx"){
        
    }else{
        stop("Unsupported system")
    }
    
}

gcs_mount_linux <- function(args, mode){
    if(mode == "r"){
        file_mode <- "444"
        dir_mode <- "555"
    }else{
        ## mode == "rw"
        file_mode <- "644"
        dir_mode <- "755"
    }
    if(!command_exist("gcsfuse")){
        stop("You do not have <gcsfuse> installed!")
    }
    system2("gcsfuse", c(args, "--dir-mode", dir_mode, "--file-mode", file_mode))
}