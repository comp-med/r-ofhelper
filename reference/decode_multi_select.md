# Decode Multi-Select Variables

Decodes multi-select coded variables by mapping coded values to their
corresponding meanings within bracketed strings.

## Usage

``` r
decode_multi_select(x, code, meaning)
```

## Arguments

- x:

  Character vector of multi-select coded values. Each element should be
  in the format "\[CODE1,CODE2\]" or "\[CODE1\|CODE2\]"

- code:

  Character vector of coded values for mapping

- meaning:

  Character vector of corresponding decoded meanings

## Value

Character vector with decoded values. Multi-select values maintain
bracketed format with decoded meanings separated by pipes.

## Details

This function processes multi-select data where each observation may
contain multiple coded values separated by commas or pipes within
brackets. It replaces coded values with their decoded meanings while
preserving the multi-select structure. All separators are normalized to
pipes for downstream uniformity.

## See also

[`decode_single_select`](https://comp-med.github.io/r-ofhelper/reference/decode_single_select.md)
for single-select decoding
[`decode_ofh_variable`](https://comp-med.github.io/r-ofhelper/reference/decode_ofh_variable.md)
for the generic decoder

## Examples

``` r
if (FALSE) { # \dontrun{
# Create mapping
codes <- c("A1", "B2", "C3")
meanings <- c("Option A", "Option B", "Option C")

# Decode multi-select variables
# decoded <- decode_multi_select(
#   x = c("[A1,B2]", "[C3]", "[A1|B2|C3]"),
#   code = codes,
#   meaning = meanings
# )
# Result: c("[Option A|Option B]", "[Option C]", "[Option A|Option B|Option C]")
} # }
```
