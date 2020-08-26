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


check_required_program <- function(){
  os <- get_os()
  if(os == "windows"){
    if(!command_exist("GCSDokan")){
      stop("You do not have <GCSDokan> installed!")
    }
  }else if(os == "linux"){
    if(!command_exist("gcsfuse")){
      stop("You do not have <gcsfuse> installed!")
    }
  }else if(os == "osx"){
    
  }else{
    stop("Unsupported system")
  }
}

command_exist <- function(x){
  if(get_os()== "windows"){
    result <- suppressWarnings(system2("where", args = x, stdout = TRUE))
    is.null(attr(result, "status"))
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
    if(get_os()!="windows"){
      tryCatch({
        dir.create(path, recursive = TRUE)
      },
      warning=function(w) {
        stop(w)
      })
    }else{
      ## if the path is a driver letter, we do not need to create it
      if(length(grep("[A-Za-z]:/$",path))==0){
        tryCatch({
          dir.create(path, recursive = TRUE)
        },
        warning=function(w) {
          stop(w)
        })
      }
    }
  }
}
