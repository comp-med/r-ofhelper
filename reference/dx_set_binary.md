# Set DNAnexus Binary Path

Sets the path to the DNAnexus dx binary. This is typically called
internally by dx_init().

## Usage

``` r
dx_set_binary(dx_binary = NULL)
```

## Arguments

- dx_binary:

  Character string specifying the path to the dx binary. If NULL
  (default), assumes "dx" is in PATH.

## Value

Invisible TRUE if successful

## Examples

``` r
if (FALSE) { # \dontrun{
# Set dx binary path
# dx_set_binary("/usr/local/bin/dx")
} # }
```
