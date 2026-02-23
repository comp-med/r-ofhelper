#' Initialize the DNAnexus cache environment
#'
#' Creates a new environment to store DNAnexus configuration values.
#'
#' @return An environment with slots for storing DNAnexus configuration
init_dx_cache <- function() {
  rlang::new_environment(
    list(
      dx_binary = NULL,
      dx_project_id = NULL,
      dx_project_name = NULL,
      dx_path = NULL,
      dx_user = NULL,
      dx_server_host = NULL,
      dx_initialized = FALSE
    ),
    parent = rlang::global_env()
  )
}

# TODO: I don't know if this is idiomatic. Might be OK to remove
.dx_cache <- init_dx_cache()

#' Reset the DNAnexus cache
#'
#' Clears all stored DNAnexus configuration values, setting them to NULL
#' except for the initialized flag which is set to FALSE.
reset_dx_cache <- function() {
  set_dx_cache(
    dx_binary = NULL,
    dx_project_id = NULL,
    dx_project_name = NULL,
    dx_path = NULL,
    dx_user = NULL,
    dx_server_host = NULL,
    dx_initialized = FALSE
  )
}

#' Set values in the DNAnexus cache
#'
#' Assigns one or more values to the DNAnexus cache environment.
#'
#' @param ... Named arguments to set in the cache
#' @return Invisible NULL
set_dx_cache <- function(...) {
  rlang::env_bind(.dx_cache, ...)
}

#' Get values from the DNAnexus cache
#'
#' Retrieves one or more values from the DNAnexus cache environment.
#'
#' @param dx_property Character string specifying which property to retrieve.
#'   Use "all" to retrieve all properties. Default is "all".
#' @return Value(s) from the cache environment
get_dx_cache <- function(dx_property = "all") {
  dx_properties <- c(
    "dx_binary",
    "dx_project_id",
    "dx_project_name",
    "dx_path",
    "dx_user",
    "dx_server_host",
    "dx_initialized"
  )

  dx_property <- match.arg(
    dx_property,
    c("all", dx_properties),
    several.ok = TRUE
  )
  if (dx_property == "all") {
    dx_property <- dx_properties
  }

  cache_result <- rlang::env_get_list(.dx_cache, dx_property)
  if (length(cache_result) == 1) {
    unlist(cache_result, use.names = FALSE)
  } else {
    cache_result
  }
}

#' Remove all entries from the DNAnexus cache
#'
#' Removes all named entries from the DNAnexus cache environment.
#' @return Invisible NULL
remove_dx_cache <- function() {
  rlang::env_unbind(.dx_cache, rlang::env_names(.dx_cache))
}

#' Get the DNAnexus path
#'
#' Retrieves the currently set DNAnexus path from the cache after validating
#' that a path is set.
#'
#' @return Character string containing the DNAnexus path
dx_get_path <- function() {
  dx_check_path()
  get_dx_cache("dx_path")
}

#' Get the DNAnexus project ID
#'
#' Retrieves the currently set DNAnexus project ID from the cache after validating
#' that a project is set.
#'
#' @return Character string containing the DNAnexus project ID
dx_get_project <- function() {
  dx_check_project()
  get_dx_cache("dx_project_id")
}
