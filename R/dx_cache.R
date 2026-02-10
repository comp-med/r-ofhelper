init_dx_cache <- function() {
  rlang::env(
    dx_binary = NULL,
    dx_project_id = NULL,
    dx_project_name = NULL,
    dx_path = NULL,
    dx_user = NULL,
    dx_server_host = NULL,
    dx_initialized = FALSE
  )
}
.dx_cache <- init_dx_cache()


reset_dx_cache <- function() {
  .dx_cache$dx_binary = NULL
  .dx_cache$dx_project_id = NULL
  .dx_cache$dx_project_name = NULL
  .dx_cache$dx_path = NULL
  .dx_cache$dx_user = NULL
  .dx_cache$dx_server_host = NULL
  .dx_cache$dx_initialized = FALSE
}

# named list, simply `"option" = value`
set_dx_cache <- function(...) {
  rlang::env_bind(.dx_cache, ...)
}

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
    (cache_result)
  }
}

remove_dx_cache <- function() {
  rlang::env_unbind(.dx_cache, rlang::env_names(.dx_cache))
}

dx_get_path <- function() {
  dx_check_path()
  get_dx_cache("dx_path")
}

dx_get_project <- function() {
  dx_check_project()
  get_dx_cache("dx_project_id")
}
