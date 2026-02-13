# Run Arbitrary DX Commands

A flexible wrapper for executing arbitrary DNAnexus commands through the
dx CLI. This function allows you to run any dx command with its
arguments.

## Usage

``` r
dx_run_cmd(cmd = NULL, ...)
```

## Arguments

- cmd:

  Character string specifying the dx command to run (e.g., "ls",
  "upload", "find")

- ...:

  Additional arguments to pass to the dx command

## Value

Character vector containing the command output (stdout)

## Examples

``` r
if (FALSE) { # \dontrun{
# List files in current directory
# dx_run_cmd("ls")
#
# Run a find command with filters
# dx_run_cmd("find", "projects", "--name", "MyProject")
} # }
```
