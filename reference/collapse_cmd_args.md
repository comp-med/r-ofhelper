# Collapse Command Arguments

When submitting jobs to the Swiss Army Knife, this function is a
convenience function to collapse the function arguments into a single
call before submitting the call to \[dx_run_swiss_army_knife()\].

## Usage

``` r
collapse_cmd_args(cmd, args)
```

## Arguments

- cmd:

  Character. The command to be run, e.g. \`plink2\`

- args:

  Character. Vector of the arguments to \`cmd\`.

## Value

A single character string that can be passed to the \`-icmd\` flag of
the Swiss Army Knife

## Examples

``` r
if (FALSE) { # \dontrun{
args <- "plink2"
cmd <- c("pfile", "ofh_data", "--make-bed", "--out", "ofh_data_bed")

collapse_cmd_args(args, cmd)
} # }
```
