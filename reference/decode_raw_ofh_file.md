# Decode Raw OFH Data File

Decodes a raw Our Future Health (OFH) data file by applying codings from
a data dictionary and codings table to convert coded values into
meaningful labels and correct data types.

## Usage

``` r
decode_raw_ofh_file(
  file_path,
  data_dictionary,
  codings_table,
  skip_codings = NULL,
  verbose = TRUE
)
```

## Arguments

- file_path:

  Character string specifying the path to the raw OFH data file to be
  decoded

- data_dictionary:

  data.table containing data dictionary information with columns: name,
  type, coding_name, is_multi_select

- codings_table:

  data.table containing codings information with columns: coding_name,
  code, meaning

- skip_codings:

  Character string or NULL. Regular expression pattern to identify
  codings that should be skipped (not decoded). Columns matching the
  pattern will be excluded from decoding.

- verbose:

  Logical. If TRUE (default), prints progress messages during decoding
  process.

## Value

data.table with decoded data and corrected data types. Returns the
original raw data unchanged if no columns need decoding.

## Details

This function reads a raw OFH data file, applies appropriate decoding to
all coded columns according to the provided data dictionary and codings
table, and returns the decoded data table with proper data types.

## See also

[`decode_ofh_variable`](https://comp-med.github.io/r-ofhelper/reference/decode_ofh_variable.md)
for the core decoding logic
[`correct_column_type`](https://comp-med.github.io/r-ofhelper/reference/correct_column_type.md)
for data type correction

## Examples

``` r
if (FALSE) { # \dontrun{
# Decode a raw OFH file using data dictionary and codings
# decoded_data <- decode_raw_ofh_file(
#   file_path = "raw_data.csv",
#   data_dictionary = my_data_dict,
#   codings_table = my_codings,
#   skip_codings = "ICD|SNOMED"
# )
} # }
```
