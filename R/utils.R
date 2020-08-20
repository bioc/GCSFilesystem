get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin')
      os <- "osx"
  } else { ## mystery machine
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      os <- "osx"
    if (grepl("linux-gnu", R.version$os))
      os <- "linux"
  }
  tolower(os)
}


command_exist <- function(x){
  if(get_os()== "windows"){
    
  }else{
    result <- suppressWarnings(system2("which", args = x, stdout = TRUE))
    length(result) != 0
  }
}

check_dir<-function(path){
  if(!dir.exists(path)){
    if(file.exists(path)){
      stop("The path <", path, "> is a file, not a directory!")
    }
    dir.create(path)
  }
}
