# Correct Data Column Type

Corrects data column types after decoding to match annotated types.

## Usage

``` r
correct_column_type(x, annotated_type)
```

## Arguments

- x:

  Vector of decoded data values

- annotated_type:

  Character string specifying the expected data type (one of "string",
  "integer", "date", "float", "datetime", "numeric")

## Value

Vector with corrected data type

## Details

This internal function is used to convert decoded data to appropriate
data types based on annotations from the data dictionary. It is called
after decoding operations to ensure proper data types are maintained for
downstream analysis.
