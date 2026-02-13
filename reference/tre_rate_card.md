# Get TRE Rate Card

Returns a data table containing the rate card information for TRE (The
Research Environment) instance types. This includes pricing,
specifications, and availability information for various Azure virtual
machine instances.

## Usage

``` r
tre_rate_card()
```

## Value

A data.table with the following columns:

- `dnanexus_instance_type`: DNAnexus instance type identifiers

- `azure_instance_type`: Corresponding Azure instance type names

- `n_gpus`: Number of GPUs (always 0 for TRE instances)

- `n_cpus`: Number of CPU cores

- `ram_gb`: RAM in gigabytes

- `disk_storage_gb`: Disk storage in gigabytes

- `storage_type`: Storage type description

- `on_demand_rate_gpb_per_h`: On-demand pricing per hour in GBP

- `spot_rate_gpb_per_h`: Spot pricing per hour in GBP

## Examples

``` r
if (FALSE) { # \dontrun{
# Get the TRE rate card
# rate_card <- tre_rate_card()
#
# View the rate card
# head(rate_card)
#
# Find the cheapest instance type
# cheapest <- rate_card[order(on_demand_rate_gpb_per_h)][1]
} # }
```
