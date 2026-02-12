dx_init <- function(
  dx_binary = NULL,
  dx_token = NULL,
  dx_project = NULL,
  dx_path = NULL,
  check_connectivity = TRUE
) {
  if (check_connectivity) {
    dx_check_connection()
  }
  bin_success <- dx_set_binary(dx_binary)
  auth_success <- dx_auth(dx_token)

  # If no token is supplied, check if already logged in
  if (isFALSE(auth_success)) {
    auth_present <- dx_check_auth()
    if (auth_present) {
      auth_success <- TRUE
    }
  }

  project_success <- FALSE
  path_success <- FALSE
  if (!is.null(dx_project)) {
    project_success <- dx_set_project(dx_project)
    if (!is.null(dx_path)) {
      path_success <- dx_set_path(dx_path)
    }
  }
  if (auth_success & bin_success) {
    set_dx_cache("dx_initialized" = TRUE)
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

dx_is_initialized <- function() {
  initialization_success <- get_dx_cache("dx_initialized")
  if (!initialization_success) {
    rlang::abort("`ofhelper` is not initialized. Run `dx_init()` first")
  }
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
  set_dx_cache(dx_binary = dx_binary)
  invisible(TRUE)
}

dx_get_env <- function() {
  dx_binary <- get_dx_cache("dx_binary")
  dx_env <- system2(dx_binary, "env", stdout = TRUE)

  # return error if output is not as expected - not pretty, TODO!
  if (!grepl("API server protocol", paste(dx_env, collapse = ", "))) {
    rlang::abort("Cannot parse unexpected content")
  }

  dx_env <- gsub("\t+", "\t", dx_env)
  dx_env <- strsplit(dx_env, "\t")
  dx_env_names <- sapply(dx_env, `[[`, 1)

  # add empty dummy in case no value is received for an option
  dx_env <- lapply(dx_env, function(x) {
    if (length(x) == 1) {
      x <- c(x, "")
    }
    x
  })
  dx_env <- sapply(dx_env, `[[`, 2)
  dx_env <- gsub("\"", "", dx_env)
  stats::setNames(dx_env, dx_env_names)
}

dx_set_env <- function() {
  dx_binary <- get_dx_cache("dx_binary")
  dx_env <- dx_get_env()
  set_dx_cache(
    dx_user = dx_env[["Current user"]],
    dx_path = dx_env[["Current folder"]],
    dx_project_id = dx_env[["Current workspace"]],
    dx_project_name = gsub(
      "\"",
      "",
      dx_env[["Current workspace name"]]
    ),
    dx_server_host = dx_env[["API server host"]]
  )
  invisible(TRUE)
}

dx_clear_env <- function() {
  dx_binary <- get_dx_cache("dx_binary")
  system2(dx_binary, "clearenv")
  invisible(TRUE)
}

dx_auth <- function(dx_token = NULL) {
  dx_binary <- get_dx_cache("dx_binary")
  auth_success <- system2(
    dx_binary,
    c("login", "--token", dx_token, "--noprojects"),
    stdout = FALSE,
    stderr = FALSE
  )
  invisible(auth_success == 0)
}

dx_find_projects <- function() {
  dx_binary <- get_dx_cache("dx_binary")
  dx_projects <- system2(
    dx_binary,
    c("find", "projects", "--json"),
    stdout = TRUE,
    stderr = FALSE
  )
  dx_projects <- jsonlite::fromJSON(dx_projects)
  stats::setNames(dx_projects$id, dx_projects$describe$name)
}
dx_available_projects <- dx_find_projects
dx_list_projects <- dx_find_projects

dx_set_project <- function(dx_project_id = NULL) {
  if (is.null(dx_project_id)) {
    rlang::abort("Need project ID")
  }
  dx_binary <- get_dx_cache("dx_binary")
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
  set_dx_cache(
    dx_project_name = dx_env[["Current workspace name"]],
    dx_project_id = dx_project_id,
    dx_path = "/"
  )
  invisible(TRUE)
}

dx_set_path <- function(dx_path = NULL) {
  if (is.null(dx_path)) {
    rlang::abort("No path specified")
  }
  dx_binary <- get_dx_cache("dx_binary")
  cd_sucess <- system2(
    dx_binary,
    c("cd", dx_path),
    stderr = FALSE,
    stdout = FALSE
  )
  if (cd_sucess != 0) {
    rlang::abort("Could not set path")
  }
  set_dx_cache(dx_path = dx_path)
  invisible(TRUE)
}
dx_set_wd <- dx_set_path
dx_cd <- dx_set_path


dx_ls <- function(directory = NULL) {
  dx_is_initialized()
  if (is.null(directory)) {
    dx_check_path()
    return(dx_run_cmd("ls"))
  } else {
    return(dx_run_cmd("ls", directory))
  }
}


dx_remount_project <- function() {
  system("umount /mnt")
  system("mkdir -p /mnt")
  system(
    "/home/dnanexus/dxfuse -readOnly /mnt /home/dnanexus/.dxfuse_manifest.json"
  )
}
