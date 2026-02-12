#' Check DNAnexus Environment Status
#'
#' Performs comprehensive checks on the DNAnexus environment to ensure it's properly
#' configured and accessible. This function verifies connectivity, initialization,
#' binary, authentication, project, and path settings.
#'
#' @param check_connectivity Logical. If TRUE (default), checks internet connectivity
#'   to DNAnexus API before performing other checks.
#'
#' @return Invisible TRUE if all checks pass, aborts on failure
#' @export
#'
#' @examples
#' \dontrun{
#' # Perform comprehensive environment check
#' # dx_check()
#' #
#' # Skip connectivity check
#' # dx_check(check_connectivity = FALSE)
#' }
dx_check <- function(check_connectivity = TRUE) {
  if (check_connectivity) {
    dx_check_connection()
  }

  dx_is_initialized()
  dx_binary <- get_dx_cache("dx_binary")
  dx_project <- get_dx_cache("dx_project_id")
  dx_path <- get_dx_cache("dx_path")
  dx_check_binary(dx_binary)
  dx_check_project()
  dx_check_path()

  invisible(TRUE)
}

#' Check DNAnexus API Connectivity
#'
#' Verifies that the DNAnexus API server is reachable and responding correctly.
#' This function performs a basic HTTP connection test to the DNAnexus API endpoint.
#'
#' @return Invisible TRUE if connectivity is successful, aborts on failure
#' @export
#'
#' @examples
#' \dontrun{
#' # Check API connectivity
#' # dx_check_connection()
#' }
dx_check_connection <- function() {
  dx_url <- "https://api.dnanexus.com"
  tryCatch(
    url_result <- curlGetHeaders(dx_url, timeout = 2L),
    error = function(e) {
      rlang::abort(
        "Connection to https://api.dnanexus.com could not be established"
      )
    }
  )
  url_result <- attr(url_result, "status")
  if (url_result != 200L) {
    rlang::abort(glue::glue(
      "Server returned status code {url_result}, not 200"
    ))
  }

  invisible(TRUE)
}

#' Check DNAnexus Binary
#'
#' Verifies that the DNAnexus dx binary is properly installed and accessible.
#' This function checks that the dx command-line tool is executable and functional.
#'
#' @param dx_binary Character string specifying the path to the dx binary.
#'   If NULL (default), uses the cached binary path.
#'
#' @return Invisible TRUE if binary is valid, aborts on failure
#' @export
#'
#' @examples
#' \dontrun{
#' # Check default dx binary
#' # dx_check_binary()
#' #
#' # Check specific binary path
#' # dx_check_binary("/usr/local/bin/dx")
#' }
dx_check_binary <- function(dx_binary = NULL) {
  dx_binary <- dx_binary %||% get_dx_cache("dx_binary")
  if (is.null(dx_binary)) {
    rlang::abort("Use `dx_set_binary` fist")
  }
  dx_exit <- suppressWarnings(system2(
    dx_binary,
    "--version",
    stdout = NULL,
    stderr = NULL
  ))
  invisible(dx_exit == 0)
}

#' Check DNAnexus Authentication
#'
#' Verifies that the DNAnexus environment is properly authenticated.
#' This function checks if a valid authentication token is available.
#'
#' @return Invisible TRUE if authenticated, aborts if not
#' @export
#'
#' @examples
#' \dontrun{
#' # Check authentication status
#' # dx_check_auth()
#' }
dx_check_auth <- function() {
  dx_binary <- get_dx_cache("dx_binary")
  dx_status <- suppressWarnings(system2(
    dx_binary,
    "whoami",
    stdout = FALSE,
    stderr = FALSE
  ))
  dx_not_logged_in <- "You are not logged in; run \"dx login\" to obtain a token."
  if (dx_status == dx_not_logged_in) {
    rlang::abort("Not logged it. Run `dx_init()` with your auth token")
  }
  invisible(TRUE)
}


#' Check DNAnexus Project
#'
#' Verifies that the currently selected DNAnexus project is valid and accessible.
#' This function compares the cached project ID with the current environment project.
#'
#' @return Invisible TRUE if project is valid, aborts on failure
#' @export
#'
#' @examples
#' \dontrun{
#' # Check current project
#' # dx_check_project()
#' }
dx_check_project <- function() {
  dx_project <- dx_get_env()[["Current workspace"]]
  dx_cached_project <- get_dx_cache("dx_project_id")

  if (dx_project != dx_cached_project) {
    dx_set_project(dx_project)
    rlang::inform(
      "Cached project differs from supplied project. Switching to user-supplied project"
    )
  }
  invisible(TRUE)
}

#' Check DNAnexus Path
#'
#' Verifies that the current working directory path in DNAnexus is valid and accessible.
#' This function ensures that the cached path matches the current environment path.
#'
#' @return Invisible TRUE if path is valid, aborts on failure
#' @export
#'
#' @examples
#' \dontrun{
#' # Check current path
#' # dx_check_path()
#' }
dx_check_path <- function() {
  dx_binary <- get_dx_cache("dx_binary")
  dx_project_name <- get_dx_cache("dx_project_name")
  dx_path_cached <- get_dx_cache("dx_path")
  dx_path_current <- system2(dx_binary, "pwd", stdout = TRUE)
  dx_path_current <- gsub(
    paste0(dx_project_name, ":"),
    "",
    dx_path_current,
    fixed = TRUE
  )
  if (dx_path_cached != dx_path_current) {
    .dx_cache$dx_path <- dx_path_current
  }
  invisible(TRUE)
}
