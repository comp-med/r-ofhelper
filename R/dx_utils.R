# rlang::env_print(.pkg_env)
.pkg_env <- rlang::env(
  dx_binary = NULL,
  dx_project = NULL,
  dx_path = NULL,
  dx_user = NULL,
  dx_workspace = NULL,
  dx_server_host = NULL,
  dx_initialized = FALSE
)


dx_check_connection <- function() {
  dx_url <- "https://api.dnanexus.com"
  tryCatch(
    url_result <- curlGetHeaders(dx_url, timeout = 2L),
    error = function(e) {
      rlang::abort("Connection to https://api.dnanexus.com could not be established")
    }
  )
  url_result <- attr(url_result, "status")
  if (url_result != 200L) {
    rlang::abort(glue::glue("Server returned status code {url_result}, not 200"))
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
  bin_success <- dx_binary <- dx_binary %||% dx_set_binary()
  auth_success <- dx_auth(dx_token)
  if (is.null(dx_project)) {
    project_success <- FALSE
    path_success <- FALSE
  } else {
    project_success <- dx_set_project(dx_project)
    if (is.null(dx_path)) {
      path_success <- FALSE
    } else {
      path_success <- dx_set_path(dx_path)
    }
  }
  if (auth_success & bin_success) {
    .pkg_env$dx_initialized <- TRUE
  }
  if (!project_success) {
    rlang::warn("Authenticated but no project set. Re-run `dx_init()` and specify a project ID or use `dx_set_project()`")
  }
  if (project_success & !path_success) {
    rlang::inform("Authenticated and project set but no path specified, so project root is used by default.")
    dx_set_path("/")
  }
}

dx_check <- function(
) {

  dx_initialized <- .pkg_env$dx_initialized
  if (!dx_initialized) {
    rlang::abort("Please run `dx_init()` first")
  }


  dx_binary <- .pkg_env$dx_binary
  dx_project <- .pkg_env$dx_project
  dx_path <- .pkg_env$dx_path


  dx_check_connection()
  dx_check_binary(dx_binary)
  dx_check_project(dx_project)
  dx_check_path(dx_path)


  # check binary
  # check project
  # check wd
}

dx_set_binary(dx_binary = NULL) {
  dx_binary <- dx_binary %||% "dx"
  dx_binary_works <- dx_check_binary(dx_binary)

  if (dx_binary_works != 0) {
    rlang::abort("`dx` utilities not found in `$PATH`. Please supply valid path to initialize")
  }
  .pkg_env$binary <- dx_binary
  invisible(TRUE)
}

# Returns exit code
dx_check_binary <- function(dx_binary = NULL) {

  if(is.null(dx_binary)) {
    rlang::abort("Use `dx_set_binary` ")
  }
  dx_exit <- suppressWarnings(system2(
    dx_binary,
    "--version",
    stdout = NULL,
    stderr = NULL
  ))

  invisible(dx_exit != 0)
}


# also get username and stuff from dx env!
dx_get_env <- function() {
  dx_binary <- .pkg_env$dx_binary
  dx_env <- system2(dx_binary, "env", stdout = TRUE)
  # return error if output is not as expected
  if (!grepl("API server protocol", dx_env[1])) {
    rlang::abort("Cannot parse unexpected content")
  }
  dx_env <- gsub("\t+", "\t", dx_env)
  dx_env <- strsplit(dx_env, "\t")
  dx_env <- setNames(lapply(dx_env, `[[`, 2), lapply(dx_env, `[[`, 1))
  .pkg_env$dx_user <- dx_env$`Current user`
  .pkg_env$dx_path <- dx_env$`Current folder`
  .pkg_env$dx_workspace <- dx_env$`Current workspace`
  .pkg_env$dx_server_host <- dx_env$`API server host`
  invisible(TRUE)
}

dx_clear_env <- function() {
  dx_binary <- .pkg_env$binary
  system2(dx_binary, "clearenv")
  invisible(TRUE)
}

dx_auth <- function(dx_token = NULL) {
  dx_binary <- .pkg_env$binary
  system2(
    dx_binary,
    c("login", "--token", dx_token, "--noprojects"),
    stdout = NULL,
    stderr = NULL
  )
  invisible(dx_get_env())
}
dx_check_auth <- function(){

  dx_binary <- .pkg_env$binary
  dx_status <- suppressWarnings(system2(dx_binary, "whoami", stdout = TRUE, stderr = TRUE))
  dx_not_logged_in <- "You are not logged in; run \"dx login\" to obtain a token."
  if (dx_status == dx_not_logged_in) {
    rlang::abort("Not logged it. Run `dx_init()` with your auth token")
  }
  invisible(TRUE)
}

dx_set_project <- function() {
  # list projects
  # dx select
  # set project
  # dx select <project>
} # TODO

dx_check_project <- function() {} # TODO
dx_available_projects <- function() {} # TODO

dx_set_path <- function() {} #TODO
dx_set_wd <- dx_set_path()
dx_check_path <- function() {} #TODO

dx_reset <- function() {
 # TODO
  # dx clearenv & maybe logout, but that invalidates token!
}

dx_run_cmd <- function() {
 # TODO
}


dx_ls <- function() {
  # TODO
  # current dir by default, otherwise, what was entered
}

dx_extract_metadata <- function() {
  # TODO
  # return the dd, codings and entity objectsa
}

dx_launch_workstation <- function() {
  # TODO
}

get_workstation_worker_url <- function() {
  # TODO
  # this creates a ton of json that contains httpsApp.dns.url with the worker url
  # dx find jobs --id job-J5jvbJV2yZ8jBKvVvPy8Yg5p --json
  # maybe util with parse_job_json() or similar
}

dx_upload <- function(
    files, # glob or vector?
    target_dir,
    overwrite_old_files = TRUE # i.e. delete old ones
) {
  # TODO
  #  remove files with the same name?
  # directory
  # files...
}

dx_remount_project <- function() {
  system("umount /mnt")
  system("mkdir -p /mnt")
  system("/home/dnanexus/dxfuse -readOnly /mnt /home/dnanexus/.dxfuse_manifest.json")
}
