# Create genomic file prefix

Create a formatted string containing chromosome and batch ID that can be
used to

## Usage

``` r
create_genomic_file_prefix(prefix, chr, n_batches)
```

## Arguments

- prefix:

  Character. \[glue::glue()\] style string for formatting, e.g.
  "ofh_imputed.v5.{chr}-{batch}"

- chr:

  Character. The chromosome identifier, Ensembl style: chr1, chr2, ...
  chrX

- n_batches:

  Integer. Number of batches for which IDs should be generated.
  Enumerates from 1..\`n_batches\`

## Value

Formatted prefixes
