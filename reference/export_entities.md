# Export Entities from DNAnexus

Submits table-exporter jobs to export OFH data entities from the
DNAnexus project. This function exports multiple entities in parallel
using the DNAnexus table-exporter app with customizable parameters.

## Usage

``` r
export_entities(
  dataset_or_cohort_or_dashboard = NULL,
  output_prefix = "ofh_raw_phenotype_data",
  output_format = "CSV",
  coding_option = "RAW",
  header_style = "FIELD-NAME",
  priority = "low",
  instance_type = "azure:mem2_ssd1_v2_x4",
  project_id = NULL,
  work_dir = "/",
  entities = NULL
)
```

## Arguments

- dataset_or_cohort_or_dashboard:

  Character string specifying the dataset, cohort, or dashboard to
  export data from

- output_prefix:

  Character string specifying the prefix for output files

- output_format:

  Character string specifying the output format (default "CSV")

- coding_option:

  Character string specifying the coding option (default "RAW")

- header_style:

  Character string specifying the header style (default "FIELD-NAME")

- priority:

  Character string specifying job priority ("low", "normal", "high")
  (default "low")

- instance_type:

  Character string specifying the DNAnexus instance type (default
  "azure:mem2_ssd1_v2_x4")

- project_id:

  Character string specifying the DNAnexus project ID

- work_dir:

  Character string specifying the working directory in DNAnexus,
  defaults to project root

- entities:

  Character vector of entity names to export. If NULL (default), tries
  exports all possible OFH entities - entities not available will result
  in a failed job.

## Value

NULL (side effect: submits DNAnexus jobs)

## Examples

``` r
if (FALSE) { # \dontrun{
# Export all standard entities
# export_entities(
#   dataset_or_cohort_or_dashboard = "project-XXXXX:/my_dataset",
#   project_id = "project-XXXXX",
#   work_dir = "/exports"
# )
} # }
```
