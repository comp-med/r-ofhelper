# Launch a DNAnexus Workstation Session

Launch a Jupyter workstation session on DNAnexus with specified
parameters.

## Usage

``` r
dx_launch_workstation(
  priority = "normal",
  session_name = "jupyter_workstation",
  session_length_minutes = 180,
  instance_type = "azure:mem1_ssd2_v2_x2"
)
```

## Arguments

- priority:

  Character string specifying the job priority. Must be one of "low",
  "normal", or "high". Default is "normal".

- session_name:

  Character string specifying the name of the workstation session.
  Default is "jupyter_workstation".

- session_length_minutes:

  Numeric specifying the session duration in minutes. Default is 180 (3
  hours).

- instance_type:

  Character string specifying the DNAnexus instance type. Must be a
  valid instance type from the TRE rate card. Default is
  "azure:mem1_ssd2_v2_x2".

## Value

Character string with the job ID of the launched workstation session

## Examples

``` r
if (FALSE) { # \dontrun{
# Launch a workstation with default settings
# job_id <- dx_launch_workstation()

# Launch a workstation with custom settings
# job_id <- dx_launch_workstation(
#   priority = "high",
#   session_name = "my_analysis_session",
#   session_length_minutes = 300,
#   instance_type = "azure:mem2_ssd1_v2_x4"
# )
} # }
```
