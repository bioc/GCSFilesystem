context("Test filesystem")

## We do the test only when we have the credentials
if(Sys.getenv("GOOGLE_APPLICATION_CREDENTIALS")!=""){
    tmp_root <- normalizePath(tempdir(),winslash = "/")
    tmp_dir1 <- paste0(tmp_root,"/GCSFilesystemTest1")
    tmp_dir2 <- paste0(tmp_root,"/GCSFilesystemTest2")
    tmp_dir3 <- paste0(tmp_root,"/GCSFilesystem Test3")
    
    if(dir.exists(tmp_dir1)){
        unlink(tmp_dir1, recursive = TRUE)
    }
    if(dir.exists(tmp_dir2)){
        unlink(tmp_dir2, recursive = TRUE)
    }
    if(dir.exists(tmp_dir3)){
        unlink(tmp_dir3, recursive = TRUE)
    }
    
    remote_bucket <- "genomics-public-data"
    remote_folder <- paste0(remote_bucket,"/clinvar")
    
    bucket_root <- GCSConnection::gcs_dir(remote_bucket)
    bucket_folder <- GCSConnection::gcs_dir(remote_folder)
    
    
    test_that("gcs_mount bucket",{
        gcs_mount(remote_bucket,tmp_dir1)
        Sys.sleep(1)
        expect_true(dir.exists(tmp_dir1))
        all_files <- list.files(tmp_dir1,include.dirs = TRUE)
        expect_equal(length(all_files),length(names(bucket_root)))
        expect_true(all(all_files%in%names(bucket_root)))
    })
    
    test_that("gcs_mount folder",{
        gcs_mount(remote_folder,tmp_dir2)
        Sys.sleep(1)
        expect_true(dir.exists(tmp_dir2))
        all_files <- list.files(tmp_dir2,include.dirs = TRUE)
        expect_equal(length(all_files),length(names(bucket_folder)))
        expect_true(all(all_files%in%names(bucket_folder)))
    })
    
    test_that("gcs_mount folder with space",{
        gcs_mount(remote_folder,tmp_dir3)
        Sys.sleep(1)
        expect_true(dir.exists(tmp_dir3))
        all_files <- list.files(tmp_dir3,include.dirs = TRUE)
        expect_equal(length(all_files),length(names(bucket_folder)))
        expect_true(all(all_files%in%names(bucket_folder)))
    })
    
    test_that("gcs_list",{
        mps <- gcs_list_mountpoints()
        expect_true(remote_bucket %in% mps$remote)
        if(get_os()=="windows")
            expect_true(remote_folder %in% mps$remote)
        
        expect_true(tmp_dir1 %in% mps$mountpoint)
        expect_true(tmp_dir2 %in% mps$mountpoint)
        expect_true(tmp_dir3 %in% mps$mountpoint)
    })
    
    
    
    test_that("gcs_unmount",{
        gcs_unmount(tmp_dir1)
        mps <- gcs_list_mountpoints()
        if(get_os()=="windows"){
            expect_false(remote_bucket %in% mps$remote)
        }
        expect_false(tmp_dir1 %in% mps$mountpoint)
        expect_false(dir.exists(tmp_dir1))
        
        gcs_unmount(tmp_dir2)
        mps <- gcs_list_mountpoints()
        expect_false(tmp_dir2 %in% mps$mountpoint)
        expect_false(dir.exists(tmp_dir2))
        
        
        gcs_unmount(tmp_dir3)
        mps <- gcs_list_mountpoints()
        expect_false(tmp_dir3 %in% mps$mountpoint)
        expect_false(dir.exists(tmp_dir3))
        if(get_os()=="windows"){
            expect_false(remote_folder %in% mps$remote)
        }else{
            expect_false(remote_bucket %in% mps$remote)
        }
    })
    
    
    
    
    
}

