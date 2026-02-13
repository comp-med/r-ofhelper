# Getting Started

## Initialization

After installing the package and its dependencies, you can parse your
existing `dx` session, but it is important to first initialize with the
[`dx_init()`](https://comp-med.github.io/r-ofhelper/reference/dx_init.md)
function.

``` r
library("ofhelper")

# required if not in $PATH
my_dx_binary <- "/PATH/TO/dx"

 # required for initialization. Can be changed afterwards
my_dx_project <- "project-12345"

# Required if not logged in already (outside of R)
my_dx_access_token <- "..."

# Optional, will use `/` otherwise 
my_dx_project_dir <- "/some/dnanexus/directory/"

# Some Jupyter sessions do not provide internet access, so you can disable the
# connectivity check here
do_connectivity_check = TRUE

# set up the package using this function
dx_init(
  dx_binary = my_dx_binary,
  dx_project = my_dx_project,
  dx_token = my_dx_access_token,
  dx_path = my_dx_project_dir,
  check_connectivity = do_connectivity_check 
)
```

Afterwards, you can check the status of the package by running
`get_dx_cache()`. This informs you about the status available to your R
session and this package’s functions (i.e. the package’s cache of `dx`’s
status). To directly check the status of `dx`, run
[`dx_get_env()`](https://comp-med.github.io/r-ofhelper/reference/dx_get_env.md),
which simply parses the output of `dx env`.

``` r
get_dx_cache()
#> [1] "/PATH/TO/dx"
#> 
#> $dx_project_id
#> [1] "project-12345"
#> 
#> $dx_project_name
#> [1] "YOUR_PROJECT_NAME"
#> 
#> $dx_path
#> [1] "/some/dnanexus/directory/"
#> 
#> $dx_user
#> [1] "your_user_name"
#> 
#> $dx_server_host
#> [1] "api.dnanexus.com"
#> 
#> $dx_initialized
#> [1] TRUE
```

## Launching Workstations

To launch a workstation to work in interactively, use
[`dx_launch_workstation()`](https://comp-med.github.io/r-ofhelper/reference/dx_launch_workstation.md).
You can also get the worker job URL using
[`get_workstation_worker_url()`](https://comp-med.github.io/r-ofhelper/reference/get_workstation_worker_url.md).

``` r
my_instance <- find_tre_instance_type(
  required_n_cpus = 8,
  required_gb_ram = 64, 
  required_gb_disk_storage = 256
)
my_worker_id <- dx_launch_workstation(
  session_name = "my_workstation", 
  instance_type = my_instance
)

# When the workstation is booted up, this will return the URL to use for interactive work
get_workstation_worker_url(my_worker_id)
#> https://...
```

## Submitting R Scripts

To submit an R script from your local environment, you can use the
[`dx_submit_r_job()`](https://comp-med.github.io/r-ofhelper/reference/dx_submit_r_job.md)
function. This simplifies to required workflow by not having to paste
code to an interactive session the code changes slightly.

``` r
# Create script you'd want to execute on DNAnexus
script_file <- tempfile(pattern = "r_job", fileext = ".R")
writeLines("sessionInfo()", script_file)

# Submit the script - see the function documentation for the additional parameters
dx_submit_r_job(
  script_path = script_file, 
  include_ofhelper = F, 
  tag = "test"
)
```

## Exporting Raw Data Entities

To work with the study’s data, it needs to be extracted from the SPARK
database and exported as tabular data. See
[here](https://github.com/ourfuturehealth/tre-example-notebooks/blob/main/R%20Notebooks/OFHR1_Data_Extraction_R.ipynb)
for a more detailed description of the process.

``` r
# The function requires the record ID of your project as input
export_entities(
  dataset_or_cohort_or_dashboard = "record-1234ABCD5678",
  entities = "participant_nhs_linked", work_dir = "test"
)
```

## Decoding Raw Data

Before analysing from the SPARK database, data needs to be prepared for
analysis. These steps include:

1.  Export (raw) data from the database
2.  Decode data (replace coded values with meaning) where applicable
3.  Clean and explore coded data
4.  Transform data with multiple items per participant and variable
5.  Deriving new variables for analysis & mapping terms to existing
    ontologies

For exporting raw data and decoding it, the functons
[`export_entities()`](https://comp-med.github.io/r-ofhelper/reference/export_entities.md)
and
[`decode_raw_ofh_file()`](https://comp-med.github.io/r-ofhelper/reference/decode_raw_ofh_file.md)
are provided.

``` r
# TODO
# ...
```
