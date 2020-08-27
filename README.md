
# Introduction

`GCSFilesystem` provides a unified interface for mounting Google Cloud
Storage buckets to your local system. After a bucket has been mounted,
you can view and access the files and foleders in the bucket using your
file browser as if they are stored locally. You must has
[GCSDokan](https://github.com/Jiefei-Wang/GCSDokan) on Windows or
[gcsfuse](https://github.com/GoogleCloudPlatform/gcsfuse) on Linux prior
to using this package. You can find documents on how to install the
dependencies by clicking the links above.

# Credentials

The package uses [Google application default
credentials](https://cloud.google.com/docs/authentication/production) to
authenticate with Google, you can also manually provide a service
account JSON file to the function `gcs_mount` to temporary overwrite the
default setting. The document on how to create a service account can be
found
[here](https://cloud.google.com/docs/authentication/production#create_service_account).

# Usage

You can use `gcs_mount` to mount a bucket on your machine. In the
example, we will mount the bucket `genomics-public-data` to a temporary
directory in R

``` r
library(GCSFilesystem)
remote_bucket <- "genomics-public-data"
temp_dir <- paste0(tempdir(),"/GCSFilesystemExample")
gcs_mount(remote_bucket, temp_dir)
```

Note that the function can also be used to mount a directory inside a
bucket. Please refer to `?gcs_mount` for the details. After mounting the
package, you can browse the files in your file explore. Here we can list
all files in R using `list.files`

``` r
list.files(temp_dir)
#>  [1] "1000-genomes"                              
#>  [2] "1000-genomes-phase-3"                      
#>  [3] "clinvar"                                   
#>  [4] "cwl-examples"                              
#>  [5] "ftp-trace.ncbi.nih.gov"                    
#>  [6] "gatk-examples"                             
#>  [7] "gce-images"                                
#>  [8] "linkage-disequilibrium"                    
#>  [9] "NA12878.chr20.sample.bam"                  
#> [10] "NA12878.chr20.sample.DeepVariant-0.7.2.vcf"
#> [11] "platinum-genomes"                          
#> [12] "precision-fda"                             
#> [13] "README"                                    
#> [14] "references"                                
#> [15] "resources"                                 
#> [16] "simons-genome-diversity-project"           
#> [17] "test-data"                                 
#> [18] "ucsc"
```

You can find all mount points by `gcs_list_mountpoints`

``` r
gcs_list_mountpoints()
#>                 remote
#> 1 genomics-public-data
#>                                                          mountpoint
#> 1 C:/Users/wangj/AppData/Local/Temp/Rtmp4CHXNv/GCSFilesystemExample
```

Finally, after using the bucket, you can unmount it via `gcs_unmount`

``` r
gcs_unmount(temp_dir)
## check if the bucket has been unmounted
gcs_list_mountpoints()
#> [1] remote     mountpoint
#> <0 rows> (or 0-length row.names)
```
