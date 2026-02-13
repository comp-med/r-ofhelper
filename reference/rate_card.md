# Our Future Health TRE rate card

The rate card for cloud computing instances used when working on the
DNAnexus cloud environment, specifically for the Our Future Health
study, which differs from default instances.

## Usage

``` r
rate_card
```

## Format

\## \`rate_card\` A data frame with 48 rows and 9 columns:

- dnanexus_instance_type:

  Character string with the DNAnexus instance type identifier

- azure_instance_type:

  Character string with the Azure VM instance type

- n_gpus:

  Integer number of GPUs

- n_cpus:

  Integer number of CPU cores

- ram_gb:

  Integer RAM in gigabytes

- disk_storage_gb:

  Integer disk storage in gigabytes

- storage_type:

  Character string describing storage type

- on_demand_rate_gpb_per_h:

  Numeric on-demand rate in GBP per hour

- spot_rate_gpb_per_h:

  Numeric spot rate in GBP per hour

## Source

\<https://a.storyblok.com/f/228028/x/bf1f0d1c41/our_future_health_trusted_research_environment_rate_card.pdf\>
