# Clean OFH Codings Table

Cleans and standardizes an OFH codings table by handling NA
representations and standardizing meaning formats.

## Usage

``` r
clean_codings_table(codings_table)
```

## Arguments

- codings_table:

  data.table containing codings information with columns: coding_name,
  code, meaning, display_order, parent_code, entity

## Value

data.table with cleaned codings table

## Details

This function processes a codings table to: 1. Convert specific NA
representations to actual NA values 2. Standardize meaning formats by
extracting values from "value = description" patterns 3. Ensures
consistent data structure for downstream decoding operations

## Examples

``` r
if (FALSE) { # \dontrun{
# Clean a codings table
# cleaned_table <- clean_codings_table(my_codings_table)
} # }
```
