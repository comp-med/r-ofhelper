# Find Suitable DNAnexus Instance Type

Find the most suitable DNAnexus instance type based on resource
requirements. This function queries the TRE rate card and returns the
best matching instance type.

## Usage

``` r
find_tre_instance_type(
  required_n_cpus,
  required_gb_ram,
  required_gb_disk_storage,
  return_all_matching = FALSE
)
```

## Arguments

- required_n_cpus:

  Numeric. Minimum number of CPU cores required.

- required_gb_ram:

  Numeric. Minimum RAM in gigabytes required.

- required_gb_disk_storage:

  Numeric. Minimum disk storage in gigabytes required.

- return_all_matching:

  Logical. If TRUE, returns all matching instance types. If FALSE
  (default), returns only the closest matching instance.

## Value

Character string with DNAnexus instance type identifier when
`return_all_matching = FALSE`, or data.table with all matching instances
when `return_all_matching = TRUE`.

## Examples

``` r
if (FALSE) { # \dontrun{
# Find instance with at least 8 CPUs, 12GB RAM, and 125GB disk
# find_tre_instance_type(8, 12, 125)

# Find all instances that meet requirements
# find_tre_instance_type(8, 12, 125, return_all_matching = TRUE)
} # }
```
