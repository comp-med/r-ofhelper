# Check if a File Exists on DNAnexus

Checks whether a specific file exists in the current DNAnexus project
and path. This function uses the dx CLI to verify file existence.

## Usage

``` r
dx_file_exists(file_path)
```

## Arguments

- file_path:

  Character string specifying the path to the file on DNAnexus (e.g.,
  "data/input.csv" or "project-xxxx:/file_name.txt")

## Value

Logical indicating whether the file exists (TRUE/FALSE)

## Examples

``` r
if (FALSE) { # \dontrun{
# Check if a file exists
# file_exists <- dx_file_exists("data/input.csv")
#
# Check if a file exists with full path
# file_exists <- dx_file_exists("project-xxxx/data/file.txt")
} # }
```
