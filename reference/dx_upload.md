# Upload Files to DNAnexus

Upload files to the currently selected DNAnexus project and folder. This
function provides a convenient wrapper around the \`dx upload\` command.

## Usage

``` r
dx_upload(files, target_dir = NULL, overwrite_old_files = TRUE)
```

## Arguments

- files:

  Character vector of file paths to upload. Can be glob patterns or
  individual file paths.

- target_dir:

  Character string specifying the target directory in DNAnexus. If NULL
  (default), uses the current working directory.

- overwrite_old_files:

  Logical. If TRUE (default), overwrites existing files with the same
  name. If FALSE, skips files that already exist.

## Value

Character vector containing the upload command output (stdout)

## Examples

``` r
if (FALSE) { # \dontrun{
# Upload a single file
# dx_upload("local_file.csv")
#
# Upload multiple files to a specific directory
# dx_upload(c("file1.csv", "file2.csv"), target_dir = "/my_folder")
#
# Upload with overwrite disabled
# dx_upload("data.csv", overwrite_old_files = FALSE)
#
# Upload files using glob patterns
# dx_upload("data_*.csv")
} # }
```
