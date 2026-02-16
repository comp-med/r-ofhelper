# Run Arbitrary DX Commands

A flexible wrapper for executing arbitrary DNAnexus commands through the
dx CLI. This function allows you to run any dx command with its
arguments.

## Usage

``` r
dx_run_cmd(cmd = NULL, ..., dx_stdout = TRUE, dx_stderr = TRUE)
```

## Arguments

- cmd:

  Character string specifying the dx command to run (e.g., "ls",
  "upload", "find")

- ...:

  Additional arguments to pass to the dx command

- dx_stdout:

  Where to direct STDOUT. Equivalent to the \`stdout\` parameter of
  \`system2\` Defaults to TRUE, capturing output.

- dx_stderr:

  Where to direct STDOUT. Equivalent to the \`stderr\` parameter of
  \`system2\`. Defaults to TRUE, capturing output.

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
