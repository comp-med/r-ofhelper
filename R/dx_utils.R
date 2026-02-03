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

# named list!
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

dx_is_initialized <- function() {
  initialization_success <- get_dx_cache("dx_initialized")
  if (!initialization_success) {
    rlang::abort("`ofhelper` is not initialized. Run `dx_init()` first")
  }
  invisible(TRUE)
}

dx_init <- function(
  dx_binary = NULL,
  dx_token = NULL,
  dx_project = NULL,
  dx_path = NULL
) {
  dx_check_connection()
  bin_success <- dx_set_binary(dx_binary)
  auth_success <- dx_auth(dx_token)
  project_success <- FALSE
  path_success <- FALSE
  if (!is.null(dx_project)) {
    project_success <- dx_set_project(dx_project)
    if (!is.null(dx_path)) {
      path_success <- dx_set_path(dx_path)
    }
  }
  if (auth_success & bin_success) {
    .dx_cache$dx_initialized <- TRUE
  }
  if (!project_success) {
    rlang::warn(
      "Authenticated but no project set. Re-run `dx_init()` and specify a project ID or use `dx_set_project()`"
    )
  }
  if (project_success & !path_success) {
    rlang::inform(
      "Authenticated and project set but no path specified, so project root is used by default."
    )
    dx_set_path("/")
  }

  env_success <- dx_set_env()
  if (!env_success) {
    rlang::abort("Failed to query and parse `dx env`")
  }

  invisible(TRUE)
}

dx_check <- function() {
  dx_check_connection()
  dx_is_initialized()
  dx_binary <- .dx_cache$dx_binary
  dx_project <- .dx_cache$dx_project_id
  dx_path <- .dx_cache$dx_path
  dx_check_binary(dx_binary)
  dx_check_project()
  dx_check_path()

  invisible(TRUE)
}

dx_set_binary <- function(dx_binary = NULL) {
  dx_binary <- dx_binary %||% "dx"
  dx_binary_works <- dx_check_binary(dx_binary)

  if (dx_binary_works != TRUE) {
    rlang::abort(
      "`dx` utilities not found in `$PATH`. Please supply valid path to initialize"
    )
  }
  .dx_cache$dx_binary <- dx_binary
  invisible(TRUE)
}

# Returns exit code
dx_check_binary <- function(dx_binary = NULL) {
  dx_binary <- dx_binary %||% .dx_cache$dx_binary
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

dx_get_env <- function() {
  dx_binary <- .dx_cache$dx_binary
  dx_env <- system2(dx_binary, "env", stdout = TRUE)

  # return error if output is not as expected - not pretty, TODO!
  if (!grepl("API server protocol", paste(dx_env, collapse = ", "))) {
    rlang::abort("Cannot parse unexpected content")
  }

  dx_env <- gsub("\t+", "\t", dx_env)
  dx_env <- strsplit(dx_env, "\t")
  dx_env_names <- sapply(dx_env, `[[`, 1)
  dx_env <- sapply(dx_env, `[[`, 2)
  dx_env <- gsub("\"", "", dx_env)
  setNames(dx_env, dx_env_names)
}

dx_set_env <- function() {
  dx_binary <- .dx_cache$dx_binary
  dx_env <- dx_get_env()
  .dx_cache$dx_user <- dx_env[["Current user"]]
  .dx_cache$dx_path <- dx_env[["Current folder"]]
  .dx_cache$dx_project_id <- dx_env[["Current workspace"]]
  .dx_cache$dx_project_name <- gsub(
    "\"",
    "",
    dx_env[["Current workspace name"]]
  )
  .dx_cache$dx_server_host <- dx_env[["API server host"]]
  invisible(TRUE)
}

dx_clear_env <- function() {
  dx_binary <- .dx_cache$dx_binary
  system2(dx_binary, "clearenv")
  invisible(TRUE)
}

dx_auth <- function(dx_token = NULL) {
  dx_binary <- .dx_cache$dx_binary
  auth_success <- system2(
    dx_binary,
    c("login", "--token", dx_token, "--noprojects"),
    stdout = FALSE,
    stderr = FALSE
  )
  invisible(auth_success == 0)
}

dx_check_auth <- function() {
  dx_binary <- .dx_cache$dx_binary
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

dx_find_projects <- function() {
  dx_binary <- .dx_cache$dx_binary
  dx_projects <- system2(
    dx_binary,
    c("find", "projects", "--json"),
    stdout = TRUE,
    stderr = FALSE
  )
  dx_projects <- jsonlite::fromJSON(dx_projects)
  setNames(dx_projects$id, dx_projects$describe$name)
}
dx_available_projects <- dx_find_projects
dx_list_projects <- dx_find_projects

dx_set_project <- function(dx_project_id = NULL) {
  if (is.null(dx_project_id)) {
    rlang::abort("Need project ID")
  }
  dx_binary <- rlang::env_get(.dx_cache, "dx_binary")
  project_success <- system2(
    dx_binary,
    c("select", dx_project_id),
    stdout = FALSE,
    stderr = FALSE
  )
  if (project_success != 0) {
    rlang::abort("Could not set project")
  }
  dx_env <- dx_get_env()
  .dx_cache$dx_project_name <- dx_env["Current workspace name"]
  .dx_cache$dx_project_id <- dx_project_id
  .dx_cache$dx_path <- "/"
  invisible(TRUE)
}

dx_check_project <- function() {
  dx_project <- dx_get_env()[["Current workspace"]]
  dx_cached_project <- get_dx_cache("dx_project_id")

  if (dx_project != dx_current_project) {
    dx_set_project(dx_project)
    rlang::inform(
      "Cached project differs from supplied project. Switching to user-supplied project"
    )
  }
  invisible(TRUE)
}

dx_set_path <- function(dx_path = NULL) {
  if (is.null(dx_path)) {
    rlang::abort("No path specified")
  }
  dx_binary <- rlang::env_get(.dx_cache, "dx_binary")
  cd_sucess <- system2(
    dx_binary,
    c("cd", dx_path),
    stderr = FALSE,
    stdout = FALSE
  )
  if (cd_sucess != 0) {
    rlang::abort("Could not set path")
  }
  .dx_cache$dx_path <- dx_path
  invisible(TRUE)
}
dx_set_wd <- dx_set_path
dx_cd <- dx_set_path

dx_check_path <- function() {
  dx_binary <- rlang::env_get(.dx_cache, "dx_binary")
  dx_project_name <- rlang::env_get(.dx_cache, "dx_project_name")
  dx_path_cached <- rlang::env_get(.dx_cache, "dx_path")
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

dx_get_path <- function() {
  dx_check_path()
  get_dx_cache("dx_path")
}

dx_get_project <- function() {
  dx_check_project()
  get_dx_cache("dx_project_id")
}

dx_run_cmd <- function() {
  # TODO
}

dx_ls <- function() {
  dx_is_initialized()
  dx_binary <- get_dx_cache("dx_binary")
  dx_path <- get_dx_cache("dx_path")
  dx_check_path()
  system2(dx_binary, "ls", stdout = TRUE)
}

dx_launch_workstation <- function() {
  # TODO
  # return job id
}

get_workstation_worker_url <- function() {
  # TODO
  # this creates a ton of json that contains httpsApp.dns.url with the worker url
  # `dx find jobs --id job-J5jvbJV2yZ8jBKvVvPy8Yg5p --json`
  # maybe util with parse_job_json() or similar
}

dx_upload <- function(
  files, # glob or vector?
  target_dir = NULL, # use current dir when null!
  overwrite_old_files = TRUE # i.e. delete old ones
) {
  dx_is_initialized()

  cached_dx_path <- get_dx_cache("dx_path")
  dx_path <- target_dir %||% cached_dx_path
  if (dx_path != cached_dx_path) {
    dx_check_path()
    dx_set_path(dx_path)
  }
  # TODO
  #  remove files with the same name?
  # directory
  # files...
}

dx_remount_project <- function() {
  system("umount /mnt")
  system("mkdir -p /mnt")
  system(
    "/home/dnanexus/dxfuse -readOnly /mnt /home/dnanexus/.dxfuse_manifest.json"
  )
}
