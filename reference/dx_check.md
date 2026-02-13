# Check DNAnexus Environment Status

Performs comprehensive checks on the DNAnexus environment to ensure it's
properly configured and accessible. This function verifies connectivity,
initialization, binary, authentication, project, and path settings.

## Usage

``` r
dx_check(check_connectivity = TRUE)
```

## Arguments

- check_connectivity:

  Logical. If TRUE (default), checks internet connectivity to DNAnexus
  API before performing other checks.

## Value

Invisible TRUE if all checks pass, aborts on failure

## Examples

``` r
if (FALSE) { # \dontrun{
# Perform comprehensive environment check
# dx_check()
#
# Skip connectivity check
# dx_check(check_connectivity = FALSE)
} # }
```
