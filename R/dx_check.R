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
