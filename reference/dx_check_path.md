# Check DNAnexus Path

Verifies that the current working directory path in DNAnexus is valid
and accessible. This function ensures that the cached path matches the
current environment path.

## Usage

``` r
dx_check_path(...)
```

## Arguments

- ...:

  parameters to pass to \`dx_run_cmd\`

## Value

Invisible TRUE if path is valid, aborts on failure

## Examples

``` r
if (FALSE) { # \dontrun{
# Check current path
# dx_check_path()
} # }
```
