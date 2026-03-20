# Create batch ID string for genomic files

Create formatted string for genomic file batches. Can be used to create
genomic file names.

## Usage

``` r
create_genomic_file_batch_ids(n_batches)
```

## Arguments

- n_batches:

  Integer. Number of batches for which IDs should be generated.
  Enumerates from 1..\`n_batches\`

## Value

Formatted character vector, e.g. c("b0001", "b0002") for for input
\`n_batches = 2\`
