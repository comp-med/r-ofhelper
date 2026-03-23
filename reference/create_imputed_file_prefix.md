# Create OFH imputed genomic file prefix

Create OFH imputed genomic file prefix

## Usage

``` r
create_imputed_file_prefix(version = "v5", chr, n_batches)
```

## Arguments

- version:

  Character. File version, default is "v5". Will change depending on
  which data release is being used in each project

- chr:

  Character. The chromosome identifier, Ensembl style: chr1, chr2, ...
  chrX

- n_batches:

  Integer. Number of batches for which IDs should be generated.
  Enumerates from 1..\`n_batches\`

## Value

Formatted character strings for imputed genotype files.
