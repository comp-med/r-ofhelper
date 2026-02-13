# Decode Single-Select Variables

Decodes single-select coded variables by mapping coded values to their
corresponding meanings.

## Usage

``` r
decode_single_select(variable, code, meaning)
```

## Arguments

- variable:

  Character vector of coded values to be decoded

- code:

  Character vector of coded values for mapping

- meaning:

  Character vector of corresponding decoded meanings

## Value

Character vector with decoded values. Mapped values are replaced with
their meanings, unmapped values are preserved as-is.

## Details

This function performs exact matching of coded values against a lookup
table and replaces coded values with their decoded meanings. Values that
don't match any code are preserved as-is.

## See also

[`decode_multi_select`](https://comp-med.github.io/r-ofhelper/reference/decode_multi_select.md)
for multi-select decoding
[`decode_ofh_variable`](https://comp-med.github.io/r-ofhelper/reference/decode_ofh_variable.md)
for the generic decoder

## Examples

``` r
if (FALSE) { # \dontrun{
# Create mapping
codes <- c("A1", "B2", "C3")
meanings <- c("Option A", "Option B", "Option C")

# Decode single-select variables
# decoded <- decode_single_select(
#   variable = c("A1", "B2", "A1", "UNKNOWN"),
#   code = codes,
#   meaning = meanings
# )
# Result: c("Option A", "Option B", "Option A", "UNKNOWN")
} # }
```
