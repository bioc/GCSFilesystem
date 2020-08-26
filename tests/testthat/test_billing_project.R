# context("Test billing project")
# 
# authen = gcs_get_cloud_auth()
# billing = authen$billing_project
# no_billing = is.null(billing)
# 
# tmp_dir <- paste0(tempdir(),"/GCSFilesystemTest3")
# if(dir.exists(tmp_dir)){
#     unlink(tmp_dir, recursive = TRUE)
# }
# 
# remote_bucket <- "bioconductor_rp"
# remote_bucket <- GCSConnection::gcs_dir(remote_bucket, billing_project = TRUE)
# 
# 
# skip_if(condition, message = NULL)




