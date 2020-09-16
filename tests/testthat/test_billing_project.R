context("Test billing project")

authen = GCSConnection::gcs_get_cloud_auth()
billing = authen$billing_project
if(!is.null(billing)){
    tmp_root <- normalizePath(tempdir(),winslash = "/")
    tmp_dir <- paste0(tmp_root,"/GCSFilesystemTest_rp")
    if(dir.exists(tmp_dir)){
        gcs_unmount(tmp_dir)
        unlink(tmp_dir, recursive = TRUE)
    }
    remote_bucket <- "bioconductor_rp"
    bucket_root <- GCSConnection::gcs_dir(remote_bucket, billing_project = TRUE)
    
    
    test_that("gcs_mount bucket with billing project",{
        gcs_mount(remote_bucket,tmp_dir, billing=billing)
        Sys.sleep(3)
        mps <- gcs_list_mountpoints()
        expect_true(tmp_dir %in% mps$mountpoint)
        expect_true(dir.exists(tmp_dir))
        all_files <- list.files(tmp_dir,all.files =TRUE)
        expect_equal(length(all_files),length(names(bucket_root)))
        expect_true(all(all_files%in%names(bucket_root)))
    })
    
    test_that("read data with billing project",{
        all_files <- list.files(tmp_dir, all.files =TRUE)
        all_files <- all_files[!file.info(paste0(tmp_dir,"/",all_files))$isdir]
        all_files <- all_files[!is.na(all_files)]
        if(length(all_files)!=0){
            file_name <- paste0(tmp_dir,"/",all_files[1])
            con1 <- file(file_name,open = "rb")
            file_data1 <- readBin(con1, raw(),100)
            
            con2 <-bucket_root[[all_files[1]]]$get_connection(open = "rb")
            file_data2 <- readBin(con2, raw(),100)
            expect_equal(file_data1,file_data2)
            close(con1)
            close(con2)
        }
    })
    
    
    test_that("gcs_unmount",{
        gcs_unmount(tmp_dir)
        mps <- gcs_list_mountpoints()
        expect_false(tmp_dir %in% mps$mountpoint)
    })
}





