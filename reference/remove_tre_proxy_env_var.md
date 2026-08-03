# Remove proxy environment variable on OFH TRE

This is a convenience function that removes the environmental for the
https proxy when a shell command is run within an R session on the OFH
DNAnexus TRE. This is done to mitigate an error when running \`dx\`
commands that seems to be caused by this variable.

## Usage

``` r
remove_tre_proxy_env_var()
```

## Value

Character vector containing relevant variables formatted as
\`VARIABLE=VALUE\`
