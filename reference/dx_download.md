# Download Files from DNAnexus

Download files from the currently selected DNAnexus project and folder.
This function provides a convenient wrapper around the \`dx download\`
command.

## Usage

``` r
dx_download(files, local_dir = ".", overwrite_existing = TRUE)
```

## Arguments

- files:

  Character vector of DNAnexus file identifiers or paths to download.

- local_dir:

  Character string specifying the local directory to download files to.
  If NULL (default), uses the current working directory.

- overwrite_existing:

  Logical. If TRUE (default), overwrites existing local files with the
  same name. If FALSE, skips files that already exist.

## Value

Character vector containing the download command output (stdout)

## Examples

``` r
if (FALSE) { # \dontrun{
# Download a single file
# dx_download("file_id_123")
#
# Download multiple files to a specific directory
# dx_download(c("file_id_1", "file_id_2"), local_dir = "./downloads")
#
# Download with overwrite disabled
# dx_download("file_id_123", overwrite_existing = FALSE)
} # }
```
