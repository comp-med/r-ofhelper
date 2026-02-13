# Create Command Input String for Jupyter Workstation

Creates a command input string for submission to a Jupyter workstation
using the `-icmd` flag. Combines user script content with ofhelper
package code for execution in the workstation environment.

## Usage

``` r
create_cmd_input_string(file, include_ofhelper = TRUE)
```

## Arguments

- file:

  Character string specifying the path to the user script file to be
  executed

- include_ofhelper:

  Logical. If `TRUE` (default), prepends the complete ofhelper package
  source code to the user script content. If `FALSE`, only returns the
  user script content.

## Value

Character string containing the combined script content ready for
submission to a Jupyter workstation via the `-icmd` flag

## Details

This function reads a user script file and optionally prepends the
complete ofhelper package source code to ensure all required functions
are available in the execution context. The resulting string can be
passed to a Jupyter workstation using the `-icmd` flag.

## Examples

``` r
if (FALSE) { # \dontrun{
# Create command string with ofhelper included
# cmd_string <- create_cmd_input_string("my_analysis.R")

# Create command string without ofhelper (not recommended)
# cmd_string <- create_cmd_input_string("my_analysis.R", include_ofhelper = FALSE)
} # }
```
