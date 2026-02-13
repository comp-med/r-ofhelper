# Check DNAnexus Binary

Verifies that the DNAnexus dx binary is properly installed and
accessible. This function checks that the dx command-line tool is
executable and functional.

## Usage

``` r
dx_check_binary(dx_binary = NULL)
```

## Arguments

- dx_binary:

  Character string specifying the path to the dx binary. If NULL
  (default), uses the cached binary path.

## Value

Invisible TRUE if binary is valid, aborts on failure

## Examples

``` r
if (FALSE) { # \dontrun{
# Check default dx binary
# dx_check_binary()
#
# Check specific binary path
# dx_check_binary("/usr/local/bin/dx")
} # }
```
