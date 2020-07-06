gcs_unmount <- function(mountpoint){
    if(!dir.exists(mountpoint)){
        stop("The mountpoint <",mountpoint ,"> does not exist")
    }
    os <- get_os()
    if(os == "windows"){
        
    }else if(os == "linux"){
        gcs_unmount_linux(mountpoint)
    }else if(os == "osx"){
        
    }else{
        stop("Unsupported system")
    }
}

gcs_unmount_linux <- function(mountpoint){
    if(!command_exist("fusermount")){
        stop("You do not have <gcsfuse> installed!")
    }
    system2("fusermount", c("-u", mountpoint))
}




