# Submit R Script as DNAnexus Job

Submits a custom R script as a job to DNAnexus for execution. This
function prepares and executes R scripts in the DNAnexus environment
using the Jupyter workstation app.

## Usage

``` r
dx_submit_r_job(
  script_path,
  instance_type = NULL,
  priority = "normal",
  session_name = NULL,
  tag = NULL,
  include_ofhelper = TRUE,
  remote_inputs = NULL
)
```

## Arguments

- script_path:

  Character string specifying the path to the R script to be executed

- instance_type:

  Character string specifying the DNAnexus instance type. If NULL
  (default), uses the lowest instance from the rate card.

- priority:

  Character string specifying job priority ("low", "normal", "high").
  Default is "normal".

- session_name:

  Character string specifying the job name. Default is
  'r_job\_\<timestamp\>'.

- tag:

  Character string for tagging the job. Default uses timestamp.

- include_ofhelper:

  Logical. If TRUE (default), includes the complete ofhelper package
  source code to ensure all required functions are available.

- remote_inputs:

  Character vector of DNAnexus file paths to be downloaded into the
  worker. Default is NULL.

## Value

Job ID of the submitted DNAnexus job

## Examples

``` r
if (FALSE) { # \dontrun{
# Submit an R script with default settings
# job_id <- submit_r_job("path/to/my_script.R")

# Submit with custom parameters
# job_id <- submit_r_job(
#   script_path = "analysis.R",
#   instance_type = "azure:mem2_ssd1_v2_x4",
#   priority = "high",
#   session_name = "my_analysis_job"
# )

# Submit with remote input files
# job_id <- submit_r_job(
#   script_path = "analysis.R",
#   remote_inputs = c("file-xxxxx", "file-yyyyy")
# )
} # }
```
