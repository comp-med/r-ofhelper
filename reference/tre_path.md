# Create TRE-compatible path

This is a thin wrapper around \[fs::path()\] that creates a full path
consisting of the project ID and the full path by appending a colon
\`:\` to the project ID before adding the path, e.g.
\`project:/path/to/file\`

## Usage

``` r
tre_path(project, ...)
```

## Arguments

- project:

  Character. The TRE project ID where the path is located.

- ...:

  Character. Character vectors that will be passed to \[fs::path()\]
  that make up the full path.

## Value

Character. A single character string describing a path in the form
"project:/path/to/file"

## Examples

``` r
tre_path("project-12345", "path", "to", "some", "file")
#> project-12345:/path/to/some/file
```
