# OFHelper

This is a collection of helper functions and utilities to make working
on the DNAnexus-based [Our Future Health
TRE](https://ourfuturehealth.dnanexus.com/) more convenient. It provides
wrapper functions around the [`dx`
utility](https://github.com/dnanexus/dx-toolkit) and should therefore
not be exclusively useful for working with the specific TRE it was
designed for, but general work on DNAnexus from within an interactive R
session.

This project is in no way affiliated with DNAnexus. In fact, the author
does not particularly enjoy working on their platform, hence this
package.

Main use-cases are:

- Interact with the `dx` toolkit from within your R session, both
  locally and in a OFH TRE Jupyter session using convenience functions
  wrapping common calls to `dx`
- Submit R commands to a worker job without the need to interact with
  with the web interface of DNAnexus
- Where relevant, the functions work exclusively with dependencies
  available on the [OFH TRE JupyterLab
  workstation](https://documentation.dnanexus.com/user/jupyter-notebooks)

## Key Features

Function documentation is also available at
[`https://comp-med.github.io/r-ofhelper/`](https://comp-med.github.io/r-ofhelper/).

- **Launch a JupyterLab Session from your R command line**
  - [`dx_launch_workstation()`](https://comp-med.github.io/r-ofhelper/reference/dx_launch_workstation.md)
- **Submit R jobs with custom scripts**
  - [`dx_submit_r_job()`](https://comp-med.github.io/r-ofhelper/reference/dx_submit_r_job.md)
- **DNAnexus Operations**:
  - Functions starting with: `dx_*`
  - [`dx_run_cmd()`](https://comp-med.github.io/r-ofhelper/reference/dx_run_cmd.md)
    can be used to execute arbitrary `dx` commands slightly cleaner than
    by using [`system2()`](https://rdrr.io/r/base/system2.html) or
    similar
  - `dx_upload` can be used to upload result files from a worker to the
    project space with the option to overwrite files with the same name
- **Decoding Workflows for raw OFH data**
  - [`decode_single_select()`](https://comp-med.github.io/r-ofhelper/reference/decode_single_select.md)
  - [`decode_multi_select()`](https://comp-med.github.io/r-ofhelper/reference/decode_multi_select.md)
  - [`decode_raw_ofh_file()`](https://comp-med.github.io/r-ofhelper/reference/decode_raw_ofh_file.md)
- **Logging**: `simple_logger()` due to none being available on OFH
- **Instance-Type Selection**:
  - [`find_tre_instance_type()`](https://comp-med.github.io/r-ofhelper/reference/find_tre_instance_type.md)
    so you don’t have to check the rate card manually

## Portability

The package relies on the external python executable `dx`, so using this
package on Windows will probably only work from within WSL. The package
should work without issues on Unix-based operating system.

## Installation

### Installing `dxpy`

The external dependency this package provides wrappers for must be
installed separately. Package managers like `uv` or `conda` can be used
for this purpose. The location of the required binary can then be
queried and passed to the initialization function.

``` bash
# Using conda
conda create -n dxpy python=3.10
conda activate dxpy
pip install dxpy

# Using uv
uv venv
uv pip install dxpy
```

After activating the environment, check the path of the executable
(requires the `whereis` utility).

``` bash
whereis dx
```

### Installing `ofhelper`

Locally, you can install the packacke using:

``` r
install.packages("remotes")
remotes::install_github("comp-med/r-ofhelper")
```

On the OFH TRE, you can upload the package using the [Airlock
system](https://dnanexus.gitbook.io/ofh/airlock/importing-files-into-a-restricted-project),
since no external packages can be installed and all development must
take place in a vanilla Jupyter Notebook environment.

For this, a convenience function is provided (after installing the
package locally) to create a single input string that can be then be
written to a file to be submitted to the `Airlock` system. This is more
convenient for the auditing process.

Locally, run the following command to create a string containing all
functions. Write that to a file and upload it to the TRE.

``` r
# `ofhelper_string` contains all functions of this package. Submit those to the airlock.
ofhelper_string <- create_ofhelper_string()
writeLines(ofhelper_string, "upload_this_via_the_airlock.txt")
```

## Getting Started

Please check the [Getting
Started](https://comp-med.github.io/r-ofhelper/docs/articles/getting-started.html)
Vignette.

## Dependencies

Dependencies of functions that can be used are restricted to the
packages available on the OFH TRE. Some functions are designed to be run
for your local environment and might include additional dependencies.

- `data.table`
- `fs`
- `rlang`
- `glue`

## TODOs

- Look for TODO tags in the functions!
- Tests are mostly mock-tests right now
- Integration tests with `dx` are not present yet
- Due to the straight forward nature of the package, most function
  documentation was generated using an LLM, so expect errors
