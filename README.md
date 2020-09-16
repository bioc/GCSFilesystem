    library(GCSFilesystem)

Introduction
============

`GCSFilesystem` provides an unified interface for mounting Google Cloud
Storage buckets to your local system. After a bucket has been mounted,
you can view and access the files and folders in the bucket using your
file browser as if they are stored locally. You must has
[GCSDokan](https://github.com/Jiefei-Wang/GCSDokan) on Windows or
[gcsfuse](https://github.com/GoogleCloudPlatform/gcsfuse) on Linux or
macOs prior to using this package. You can find documents on how to
install the dependencies by clicking the links above.

Credentials
===========

The package uses [Google application default
credentials](https://cloud.google.com/docs/authentication/production) to
authenticate with Google. In most case, you need to provide a service
account JSON file to verify your identity. For automatically finding
your credentials when using the package, the path to the JSON file can
be stored at the environment variable `GOOGLE_APPLICATION_CREDENTIALS`.
You can also manually provide the JSON file to the package by specifying
the argument `key_file` to the function `gcs_mount`. The document of how
to create a service account can be found
[here](https://cloud.google.com/docs/authentication/production#create_service_account).

Note that there are some buckets which allow anonymous access. For
windows, these buckets can be directly mounted without a credentials.
For Linux and macOs, the current version of `gcsfuse` does not support
anonymous access and you still need to provide a credentials file to
access the buckets.

Basic usage
===========

You can use `gcs_mount` to mount a bucket on your machine. In the
example, we will mount the bucket `genomics-public-data` to a temporary
directory in R

    remote_bucket <- "genomics-public-data"
    temp_dir <- paste0(tempdir(),"/GCSFilesystemExample")
    gcs_mount(remote_bucket, temp_dir)

Note that the function can also be used to mount a directory inside a
bucket. For example, you can use
`gcs_mount("genomics-public-data/clinvar", temp_dir)` to mount the
folder `clinvar` to your temporary directory. After mounting the
package, you can browse the files in your file explore. Here we can list
all files in R using `list.files`

    list.files(temp_dir)
    #>  [1] "1000-genomes"                               "1000-genomes-phase-3"                      
    #>  [3] "clinvar"                                    "cwl-examples"                              
    #>  [5] "ftp-trace.ncbi.nih.gov"                     "gatk-examples"                             
    #>  [7] "linkage-disequilibrium"                     "NA12878.chr20.sample.bam"                  
    #>  [9] "NA12878.chr20.sample.DeepVariant-0.7.2.vcf" "platinum-genomes"                          
    #> [11] "precision-fda"                              "README"                                    
    #> [13] "references"                                 "resources"                                 
    #> [15] "simons-genome-diversity-project"            "test-data"                                 
    #> [17] "ucsc"

You can find all mount points by `gcs_list_mountpoints`

    gcs_list_mountpoints()
    #>                 remote                                                        mountpoint
    #> 1 genomics-public-data C:/Users/wangj/AppData/Local/Temp/Rtmpqelnec/GCSFilesystemExample
    #> 2      bioconductor_rp                                                                T:

Finally, after using the bucket, you can unmount it via `gcs_unmount`

    gcs_unmount(temp_dir)
    ## check if the bucket has been unmounted
    gcs_list_mountpoints()
    #>            remote mountpoint
    #> 1 bioconductor_rp         T:

Advance topics
==============

Billing project
---------------

Some buckets have billing project enabled, which means you are
responsible for all the charges that occurs when accessing the bucket.
For avoiding unintentional cost, the billing project is not enabled by
default. If you want to access this type of buckets, you must specify
your project Id in the argument `billing` when calling
`gcs_mount`(e.g. `gcs_mount("bucket", "mount-point", billing = "my-project-Id")`).
Otherwise, you would not be able to see the files in the bucket. Please
note that it is not recommended to add the argument `billing` for all
the call to `gcs_mount`. If you did it, you *WILL* be changed by Google
even if you are trying to access a bucket without billing project
enabled.

Refresh rate
------------

Since accessing remote files are relatively expensive, the information
of files and folders in the mounted bucket will be cached for a certain
period of time. The changes to the remote bucket will not be immediately
visible until the local information has been expired. By default, the
refresh rate is 60 seconds. You can change the refresh rate via the
argument `refresh` when mounting a bucket.

Cache
-----

Certain optimization can be made to facilitate your access to the Google
Bucket. Since accessing remote files has much higher latency than
accessing local files, using local cache can greatly reduce the number
of remote requests and reuse the data that has been downloaded before.
The cache will be enabled by default and the cache data will be stored
on disk. Only Windows users are allowed to change the cache setting, the
available cache types are `none`, `disk` and `memory`. They can be
changed via the argument `cache_type` and `cache_arg` in the function
`gcs_mount`.
