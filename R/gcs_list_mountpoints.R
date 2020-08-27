#' List all GCS mountpoints
#' 
#' List all GCS mountpoints. The function uses `GCSDokan``
#' on Windows or the command `df` on Linux to show all 
#' mountpoints. Due to the system differences, the function
#' is only able to show the bucket name on Linux and can
#' show the full remote path on Windows.
#' 
#' @return a data.frame object with the first column named `remote`
#' and second named `mountpoint`
#' @examples 
#' gcs_list_mountpoints()
#' @export
gcs_list_mountpoints <- function(){
    check_required_program()
    os <- get_os()
    if(os == "windows"){
        gcs_list_mountpoints_win()
    }else if(os == "linux"){
        gcs_list_mountpoints_linux()
    }else if(os == "osx"){
        gcs_list_mountpoints_mac()
    }else{
        stop("Unsupported system")
    }
}

gcs_list_mountpoints_win <- function(){
    col_names <- c("remote", "mountpoint")
    col_num <- length(col_names)
    system_out <- suppressWarnings(
        system2("GCSDokan", "-l", stdout = TRUE, stderr = NULL))
    system_out <- system_out[-1]
    if(length(system_out) == 0){
        return(setNames(data.frame(matrix(ncol = col_num, nrow = 0)), col_names))
    }
    splited_result <- lapply(system_out, function(x) strsplit(x, " *\t\t"))
    final <- as.data.frame(matrix(unlist(splited_result), ncol = col_num, byrow = TRUE))
    final[,1:2] <- final[,2:1]
    colnames(final) <- col_names
    final
}
gcs_list_mountpoints_linux <- function(){
    system_out <- suppressWarnings(
        system2("df", c("--type=fuse","--output=source,used,target"), stdout = TRUE, stderr = NULL))
    if(length(system_out) == 0){
        col_names <- c("remote", "mountpoint")
        col_num <- length(col_names)
        return(setNames(data.frame(matrix(ncol = col_num, nrow = 0)), col_names))
    }
    
    table_title <- system_out[1]
    table_content <- system_out[-1]
    title_end <- gregexpr(" +", table_title)[[1]]
    
    ## Capture remote bucket
    remote <- substr(table_content, 1, title_end[2]-1)
    remote <- gsub(" +[0-9]+$", "", remote)
    
    ## Capture mount points
    mountpoint <- trimws(
        substring(table_content, title_end[2])
    )
    data.frame(remote = remote, mountpoint = mountpoint)
}

gcs_list_mountpoints_mac <- function(){
    system_out <- suppressWarnings(
        system2("df", "-t osxfuse", stdout = TRUE, stderr = NULL))
    if(length(system_out) == 0){
        col_names <- c("remote", "mountpoint")
        col_num <- length(col_names)
        return(setNames(data.frame(matrix(ncol = col_num, nrow = 0)), col_names))
    }
    
    table_title <- system_out[1]
    table_content <- system_out[-1]
    title_end <- gregexpr(" +", table_title)[[1]]
    
    ## Capture remote bucket
    remote <- substr(table_content, 1, title_end[2]-1)
    remote <- gsub(" +[0-9]+$", "", remote)
    
    ## Capture mount points
    mountpoint <- trimws(
        substring(table_content, title_end[length(title_end)-1])
    )
    data.frame(remote = remote, mountpoint = mountpoint)
}

