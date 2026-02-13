# Clean OFH Data Dictionary

Cleans and standardizes an OFH data dictionary table by validating
structure, fixing data types, and ensuring consistent formatting.

## Usage

``` r
clean_data_dictionary(data_dictionary)
```

## Arguments

- data_dictionary:

  data.table containing data dictionary information with columns:
  entity, name, type, primary_key_type, coding_name, is_sparse_coding,
  is_multi_select, referenced_entity_field, relationship, folder_path,
  title, units, description, category, file, file_name, level,
  field_type, vcf_field, values

## Value

data.table with cleaned data dictionary

## Details

This function processes a data dictionary to: 1. Validate required
column structure 2. Fix is_multi_select column to use TRUE/FALSE instead
of TRUE/NA 3. Correct column type documentation (columns documented as
integer are actually strings)

## Examples

``` r
if (FALSE) { # \dontrun{
# Clean a data dictionary
# cleaned_dict <- clean_data_dictionary(my_data_dictionary)
} # }
```
