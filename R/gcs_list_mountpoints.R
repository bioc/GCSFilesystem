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
        gcs_list_mountpoint_win()
    }else if(os == "linux"){
        gcs_list_mountpoint_linux()
    }else if(os == "osx"){
        gcs_list_mountpoint_linux()
    }else{
        stop("Unsupported system")
    }
}

gcs_list_mountpoint_win <- function(){
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
gcs_list_mountpoint_linux <- function(){
    col_names <- c("remote", "mountpoint")
    col_num <- length(col_names)
    system_out <- suppressWarnings(
        system2("df", c("--type=fuse","--output=source,target"), stdout = TRUE, stderr = NULL))
    if(length(system_out) == 0){
        return(setNames(data.frame(matrix(ncol = col_num, nrow = 0)), col_names))
    }
    system_out <- system_out[-1]
    splited_result <- lapply(system_out, function(x) strsplit(x, " +"))
    final <- as.data.frame(matrix(unlist(splited_result), ncol = col_num, byrow = TRUE))
    colnames(final) <- col_names
    final
}



