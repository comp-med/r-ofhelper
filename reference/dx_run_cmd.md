# Run Arbitrary DX Commands

A flexible wrapper for executing arbitrary DNAnexus commands through the
dx CLI. This function allows you to run any dx command with its
arguments.

## Usage

``` r
dx_run_cmd(
  cmd = NULL,
  ...,
  dx_stdout = TRUE,
  dx_stderr = TRUE,
  fail_on_dx_error = TRUE
)
```

## Arguments

- cmd:

  Character string specifying the dx command to run (e.g., "ls",
  "upload", "find")

- ...:

  Additional arguments to pass to the dx command

- dx_stdout:

  Logical, whether to return STDOUT. Equivalent to the \`stdout\`
  parameter of \`system2\` Defaults to TRUE, capturing output.

- dx_stderr:

  Logical, whether to return STDERR. Equivalent to the \`stderr\`
  parameter of \`system2\`. Defaults to TRUE, capturing output.

- fail_on_dx_error:

  Logical, whether to panic with error message when \`dx\` returns an
  error or whether to return the result regardless

## Value

List containging exit code, stdout and stderr (depending on
\`dx_stdout\` and \`dx_stderr\`)

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
