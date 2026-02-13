# Explode Multi-Select Variables into Dummy Codes

Converts multi-select variables (where each observation can contain
multiple values separated by commas or pipes) into dummy-coded
variables. Each unique value becomes a binary column indicating presence
(TRUE) or absence (FALSE) of that value.

## Usage

``` r
explode_multi_select(
  x,
  answer_separators = c(",", "|"),
  long_format = FALSE,
  na_is_none_of_the_above = TRUE
)
```

## Arguments

- x:

  Character vector containing multi-select data. Each element may
  contain multiple answers separated by either commas (\`,\`) or pipes
  (\`\|\`).

- answer_separators:

  Character vector specifying separators to split answers. Default is
  c(",", "\|").

- long_format:

  Logical. If `TRUE`, returns data in long format with three columns:
  `index`, `original`, and `variable` (name of the dummy-coded variable)
  and `value` (binary indicator). If `FALSE`, returns wide format with
  one column per unique value.

- na_is_none_of_the_above:

  Logical. If `TRUE`, treats "NA" values as "none of the above" (all
  dummy variables FALSE). If `FALSE`, treats "NA" values as missing (all
  dummy variables NA).

## Value

A data.table with either: - Wide format: one row per input element, one
column per unique value (binary) - Long format: three columns (`index`,
`original`, `variable`, `value`) - Additional columns: `original`
(original input) and `index` (row index)

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
