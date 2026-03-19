# Convenience Functions

``` r
library(ofhelper)
```

## Rationale

Primarily, this package is intended to reduce friction when working on
OFH in R by providing wrapper functions for common tasks with some
quality-of-life improvements like better error handling.

## Running `dx` Commands

A very basic wrapper around `dx` named
[`dx_run_cmd()`](https://comp-med.github.io/r-ofhelper/reference/dx_run_cmd.md)
is provided that makes it easier to execute arbitrary `dx` commands. The
main advantages are:

1.  Automatically keep track of the location of the `dx` binary via the
    package cache and that
2.  Gracefully fail when `dx` returns an error if you want it to
3.  Return the output of `dx` in a structured list by separating the
    exit code, output to STDOUT and output to STDERR

``` r
# Make sure you initialize first by providing your dx binary path and project ID
dx_init(
#   [...]
)

# Running the command will return a list if successful
dx_run_cmd("ls")
#> $exit_code
#> [1] 0
#> 
#> $stdout
#>  [1] "dir1"
#>  [2] "dir2"
#>  [3] "dir3"
#> 
#> $stderr
character(0)
```

By default, the function will throw an error when a command fails and
return the error message.

``` r
# you can also simply use `dx_ls`, but it's a good example
dx_run_cmd("ls", "does-not-exist")
#> Error in `dx_run_cmd()`:
#> ! Call to `dx` returned exit code 3 with error message:
#> dxpy.utils.resolver.ResolutionError: Unable to resolve "does-not-exist" to a
#> data object or folder name in '/'
#> Run `rlang::last_trace()` to see where the error occurred.
```

If you do not want the to throw an error, set the `fail_on_dx_error` to
`FALSE`. This let’s you work with the output regardless of success or
failure.

``` r
dx_run_cmd("ls", "does-not-exist", fail_on_dx_error = FALSE)
#> $exit_code [1] 3
#>
#> $stdout character(0)
#>
#> $stderr [1] "dxpy.utils.resolver.ResolutionError: Unable to resolve
#> \"does-not-exist\" to a data object or folder name in '/'"
```

## Up- and Downloading files in the TRE

When processing data in the TRE, you might want to up- or download files
to the TRE project space using `dx upload` or `dx download`. From within
R, this can be accomplished using
[`system2()`](https://rdrr.io/r/base/system2.html) calls, but this can
be brittle and by default, no files will be overwritten during upload,
even though that would be expected on most systems, thus requiring
several commands to check for existing files, delete them if present and
then upload the new files. the functions
[`dx_download()`](https://comp-med.github.io/r-ofhelper/reference/dx_download.md)
and
[`dx_upload()`](https://comp-med.github.io/r-ofhelper/reference/dx_upload.md)
were written to simplify this workflow.
