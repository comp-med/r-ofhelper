# Create Complete ofhelper Package Source String

Creates a complete concatenated string of all ofhelper package R script
files. This function is specifically designed for environments like the
Our Future Health TRE where external packages cannot be installed,
allowing the complete package source to be embedded directly into
command executions.

## Usage

``` r
create_ofhelper_string()
```

## Value

Character string containing the complete source code of all ofhelper R
scripts concatenated together

## Details

The function reads all R scripts from the ofhelper package and combines
them into a single string that can be included in command inputs,
eliminating the need for package installation in restricted
environments.

## See also

[`create_cmd_input_string`](https://comp-med.github.io/r-ofhelper/reference/create_cmd_input_string.md)
for usage in Jupyter workstation contexts

## Examples

``` r
if (FALSE) { # \dontrun{
# Create the complete ofhelper package source
# ofhelper_code <- create_ofhelper_string()
} # }
```
