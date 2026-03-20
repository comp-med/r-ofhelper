# Submit a Swiss Army Knife DNAnexus Job

Submits a job using the Swiss Army Knife to DNAnexus for execution. This
function is a wrapper to submit a single job using a list of input files
and a single command string to be executed with the job. Uses the
function \[dx_run_cmd()\] to submit the job.

## Usage

``` r
dx_run_swiss_army_knife(
  input_files,
  cmd,
  mount_inputs = FALSE,
  destination_project = NULL,
  destination_path = NULL,
  instance_type = NULL,
  priority = "normal",
  session_name = NULL,
  tag = NULL,
  app_id = NULL
)
```

## Arguments

- input_files:

  Character. A character vector of all required input files, ideally
  with the full path in the form \`project:/path/to/file\`. Content will
  be passed to the \`-iin\` flag.

- cmd:

  Character. A single string of the command to be executed within the
  app. Content will be passed to the \`-icmd\` flag.

- mount_inputs:

  Logical. Default is \`FALSE\`. Whether to download the files into the
  app (if \`FALSE\`) or mount them within the app (if \`TRUE\`)

- destination_project:

  Character. The project ID of the project the result files will be
  saved in. If \`NULL\`, default to the project that \`ofhelper\` was
  initialized in.

- destination_path:

  Character. The directory of the project the result files will be saved
  in. If \`NULL\`, default to the current directory that \`ofhelper\`
  has cached.

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

- app_id:

  Character. App ID of the Swiss Army Knife app. If \`NULL\` (Default),
  it will use the latest version by just passing \`swiss-army-knife\`

## Value

Job ID of the submitted DNAnexus job
