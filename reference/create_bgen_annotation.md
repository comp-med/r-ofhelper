# Create BGEN File Annotation

This function tries to parse an OFH directory for BGEN files and creates
an annotation table that makes processing the data simpler.

## Usage

``` r
create_bgen_annotation(project_id, bgen_dir)
```

## Arguments

- project_id:

  Character. An DNAnexus project ID where the data was dispensed.

- bgen_dir:

  Character. The path to the raw BGEN files. Should be either
  \`/snv_bgen/\` or \`/imputed_bgen/\`

## Value

A data.table with the full paths to the BGEN files and some parsed
information
