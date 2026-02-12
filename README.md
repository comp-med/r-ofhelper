# OFHelper

This is a collection of helper functions and utilities to make working on the
DNAneux-based [Our Future Health TRE](https://ourfuturehealth.dnanexus.com/)
more convenient.

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

- **Decoding Workflows**:
  - `decode_single_select()`
  - `decode_multi_select()`
  - `decode_raw_ofh_file()`
- **DNAnexus Operations**:
  - `dx_upload()` - Upload files to DNAnexus
  - `dx_download()` - Download files from DNAnexus
- **Logging**: `simple_logger()`
- **Instance-Type Selection**: `find_tre_instance_type()`

## Installation

## TODOs

* Look for TODO tags in the functions! Some are simply place-holders for now
* Tests are mostly mock-tests right now. Integration tests with `dx` are not present yet

- `export_entities.R`
- `clean_data_dictionary.R`

## Dependencies

- `data.table`
- `fs`
- `rlang`
- `glue`

## Example Usage

```R
# It is important to first initialize the package by
dx_init()
```
