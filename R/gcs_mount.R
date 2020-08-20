gcs_mount <- function(bucket, mountpoint, mode = c("rw", "r"), temp_dir = NULL ,
                      billing = NULL, refresh = 60,
                      implicit_dirs = TRUE, key_file = NULL, additional_args = NULL){
    mode <- match.arg(mode)
    ## Create the mountpoint folder if it does not exist
    check_dir(mountpoint)
    if(!is.null(temp_dir)){
        check_dir(temp_dir)
    }
    os <- get_os()
    if(os == "windows"){
        
    }else if(os == "linux"){
        gcs_mount_linux(bucket = bucket, mountpoint = mountpoint, mode = mode,
                        temp_dir = temp_dir , 
                        billing = billing, refresh = refresh,
                        implicit_dirs = implicit_dirs,
                        key_file = key_file,additional_args=additional_args)
    }else if(os == "osx"){
        
    }else{
        stop("Unsupported system")
    }
    
}

gcs_mount_linux <- function(bucket, mountpoint, mode = c("rw", "r"), temp_dir = NULL ,
                            billing = NULL, refresh = 60,
                            implicit_dirs = TRUE, key_file = NULL, additional_args = NULL){
    if(!command_exist("gcsfuse")){
        stop("You do not have <gcsfuse> installed!")
    }
    ## Determine if the folder-like structure will be used
    if(implicit_dirs){
        args <- "--implicit-dirs"
    }else{
        args <- character()
    }
    ## Load the credentials file if needed
    if(!is.null(key_file)){
        args <- c(args, paste0("--key-file= \"", key_file,"\""))
    }
    if(!is.null(temp_dir)){
        args <- c(args, paste0("--temp-dir \"", temp_dir,"\""))
    }
    if(!is.null(billing)){
        args <- c(args, paste0("--billing-project ", billing))
    }
    ## Refresh rate
    args <- c(args, paste0("--stat-cache-ttl ", refresh,"s"))
    args <- c(args, paste0("--type-cache-ttl ", refresh,"s"))
    
    if(mode == "r"){
        file_mode <- "444"
        dir_mode <- "555"
    }else{
        ## mode == "rw"
        file_mode <- "644"
        dir_mode <- "755"
    }
    args <- c(args, "--dir-mode", dir_mode, "--file-mode", file_mode)
    args <- c(args, bucket, mountpoint)
    system2("gcsfuse", args)
}