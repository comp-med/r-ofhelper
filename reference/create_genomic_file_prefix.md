# Create genomic file prefix

Create a formatted string containing chromosome and batch ID that can be
used to

## Usage

``` r
create_genomic_file_prefix(prefix, version, chr, n_batches)
```

## Arguments

- prefix:

  Character. \[glue::glue()\] style string for formatting, e.g.
  "ofh_imputed.{version}.{chr}-{batch}". Needs to contain \`version\`,
  \`chr\` & \`batch\`

- version:

  Character. The release version of the genomic data, e.g. \`v9\`

- chr:

  Character. The chromosome identifier, Ensembl style: chr1, chr2, ...
  chrX

- n_batches:

  Integer. Number of batches for which IDs should be generated.
  Enumerates from 1..\`n_batches\`

## Value

Formatted prefixes
