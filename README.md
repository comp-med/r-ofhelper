# OFHelper

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/comp-med/r-ofhelper/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/comp-med/r-ofhelper/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

This is a collection of helper functions and utilities to make working on the
DNAneux-based [Our Future Health TRE](https://ourfuturehealth.dnanexus.com/)
more convenient. It provides wrapper functions around the [`dx`
utility](https://github.com/dnanexus/dx-toolkit) and should therefore not be
exclusively useful for working with the specific TRE it was designed for, but
general work on DNAnexus from within an interactive R session.

Main use-cases are:

* Interact with the `dx` toolkit from within your R session, both locally and
  in a OFH TRE Jupyter session using convenience functions wrapping common calls
  to `dx`
* Submit R scripts to a worker job without the need to interact with with the
  web interface of DNAnexus
* Where relevant, the functions work exclusively with dependencies available on
  the [OFH TRE JupyterLab
  workstation](https://documentation.dnanexus.com/user/jupyter-notebooks)

## Key Features

- **Launch a JupyterLab Session from your R command line**
  - `dx_launch_workstation()`
- **Submit R jobs with custom scripts**
  - `dx_submit_r_job()`
- **Interact with `dx` toolkit from within your R session**
  - Various functions starting with `dx_`
- **Decoding Workflows for raw OFH data**:
  - `decode_single_select()`
  - `decode_multi_select()`
  - `decode_raw_ofh_file()`
- **DNAnexus Operations**:
  - Functions starting with: `dx_`
- **Logging**: `simple_logger()` due to none being available on OFH
- **Instance-Type Selection**: 
  - `find_tre_instance_type()` so you don't have to check the rate card manually

## Portability

The package relies on an external binary, so using this package on Windows will
probably only work from within WSL. The package should work without issues on
any Unix-based operating system.

## Installation

Install from GitHub from within R using

```R
remotes::install_github("comp-med/r-ofhelper")
```

To use the package within the OFH TRE environment, a convenience function is
provided (after installing the package locally) to create a single input string
that can be then be sourced in an JupyterLab session.

Locally, run the following command to create a string containing all functions.
Either write that to a file and upload it in the TRE or just copy-paste it from
your local terminal to the remote terminal.

```R
# `ofhelper_string` contains all functions
ofhelper_string <- create_ofhelper_string()
```

## Example Usage

Within R, you can parse your existing `dx` session, but it is important to first
initialize with the `dx_init()` function.

```R
library("ofhelper")

# required if not in $PATH
my_dx_binary <- "/PATH/TO/dx"

 # required for initialization. Can be changed afterwards
my_dx_project <- "project-12345"

# Required if not logged in already (outside of R)
my_dx_access_token <- "..."

# Optional, will use `/` otherwise 
my_dx_project_dir = <- "/some/dnanexus/directory/"

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

Afterwards, you can check the status of the package by running `get_dx_cache()`.
This informs you about the status available to your R session and this package's
functions. To directly check the status of `dx`, run `dx_get_env()`

```R
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

To launch a workstation to work in interactively, use `dx_launch_workstation()`.
You can also get the worker job URL using `get_workstation_worker_url()`.

```R
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

To submit an R script from your local environment, you can use the
`dx_submit_r_job()` function. This simplifies to required workflow by not having
to paste code to an interactive session the code changes slightly.

```R
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

## Dependencies

Dependencies of functions that can be used are restricted to the packages
available on the OFH TRE. Some functions are designed to be run for your local
environment and might include additional dependencies.

- `data.table`
- `fs`
- `rlang`
- `glue`

## TODOs

* Look for TODO tags in the functions!
* Tests are mostly mock-tests right now
* Integration tests with `dx` are not present yet
* Due to the straight forward nature of the package, most documentation was generated using an LLM, so expect errors

