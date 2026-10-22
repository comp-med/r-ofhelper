# Access DNAnexus persistent user cache

Read the current user's DNAnexus configuration saved in their user
home's environment.json file.

## Usage

``` r
read_dx_env(file = "~/.dnanexus_config/environment.json", return_token = FALSE)
```

## Arguments

- file:

  Path to the environment.json file. Default value gives the expected
  location.

- return_token:

  Logical. Whether or not to include the secret access token in the
  output. Omits the token by default.

## Value

A named list with the DNAnexus session state data
