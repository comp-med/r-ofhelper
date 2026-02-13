# Decode OFH Variable

Generic decoder function that routes variable decoding to either
single-select or multi-select decoding based on the `is_multi_select`
parameter.

## Usage

``` r
decode_ofh_variable(
  variable,
  is_multi_select = logical(),
  code = character(),
  meaning = character()
)
```

## Arguments

- variable:

  A vector of coded values to be decoded

- is_multi_select:

  Logical. If `TRUE`, treats the variable as multi-select (multiple
  values per observation). If `FALSE`, treats as single-select (one
  value per observation).

- code:

  Character vector of coded values to be matched

- meaning:

  Character vector of corresponding decoded meanings

## Value

Character vector with decoded values. For multi-select variables,
returns character strings with bracketed comma-separated values. For
single-select variables, returns character vector of decoded meanings.

## Details

This function serves as a dispatcher that calls the appropriate decoding
function
([`decode_single_select`](https://comp-med.github.io/r-ofhelper/reference/decode_single_select.md)
or
[`decode_multi_select`](https://comp-med.github.io/r-ofhelper/reference/decode_multi_select.md))
based on whether the variable represents single or multiple selections.

## See also

[`decode_single_select`](https://comp-med.github.io/r-ofhelper/reference/decode_single_select.md)
for single-select decoding
[`decode_multi_select`](https://comp-med.github.io/r-ofhelper/reference/decode_multi_select.md)
for multi-select decoding

## Examples

``` r
if (FALSE) { # \dontrun{
# Decode a single-select variable
# codes <- c("A1", "B2", "C3")
# meanings <- c("Option A", "Option B", "Option C")
# decoded <- decode_ofh_variable(
#   variable = c("A1", "B2", "A1"),
#   is_multi_select = FALSE,
#   code = codes,
#   meaning = meanings
# )

# Decode a multi-select variable
# decoded_multi <- decode_ofh_variable(
#   variable = c("[A1,B2]", "[C3]"),
#   is_multi_select = TRUE,
#   code = codes,
#   meaning = meanings
# )
} # }
```
