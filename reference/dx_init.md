# Initialize DNAnexus Environment

Initializes the DNAnexus environment by setting up the binary,
authentication, project, and path. This function must be called before
other DNAnexus functions can be used.

## Usage

``` r
dx_init(
  dx_binary = NULL,
  dx_token = NULL,
  dx_project = NULL,
  dx_path = NULL,
  check_connectivity = TRUE
)
```

## Arguments

- dx_binary:

  Character string specifying the path to the dx binary. If NULL
  (default), assumes "dx" is in PATH.

- dx_token:

  Character string specifying the DNAnexus authentication token. If NULL
  (default), tries to use existing authentication.

- dx_project:

  Character string specifying the DNAnexus project ID. If NULL
  (default), no project is selected.

- dx_path:

  Character string specifying the DNAnexus project path. If NULL
  (default), uses project root.

- check_connectivity:

  Logical. If TRUE (default), checks connectivity before initialization.

## Value

Invisible TRUE if successful, aborts on failure

## Examples

``` r
if (FALSE) { # \dontrun{
# Initialize with default settings
# dx_init()
#
# Initialize with specific settings
# dx_init(
#   dx_binary = "/path/to/dx",
#   dx_token = "your-token-here",
#   dx_project = "project-xxxxx",
#   dx_path = "/data"
# )
} # }
```
