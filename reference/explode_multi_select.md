# Explode Multi-Select Variables into Dummy Codes

Converts multi-select variables (where each observation can contain
multiple values separated by commas or pipes) into dummy-coded
variables. Each unique value becomes a binary column indicating presence
(TRUE) or absence (FALSE) of that value.

## Usage

``` r
explode_multi_select(x, answer_separators = "|")
```

## Arguments

- x:

  Character vector containing multi-select data. Each element may
  contain multiple answers separated by either commas (\`,\`) or pipes
  (\`\|\`).

- answer_separators:

  Character vector specifying separators to split answers. Default is
  "\|" since "," are used within the answers.

## Value

A data.table with - Wide format: one row per input element, one column
per unique value (binary)

## Examples

``` r
if (FALSE) { # \dontrun{
# Basic usage
x <- c("A,B", "B,C", "A,C", "A|B|C")
result <- explode_multi_select(x)

# With long format
result_long <- explode_multi_select(x, long_format = TRUE)

# With custom separators
x2 <- c("A;B", "B;C")
result2 <- explode_multi_select(x2, answer_separators = ";")
} # }
```
