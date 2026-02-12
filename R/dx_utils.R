#' Initialize DNAnexus Environment
#'
#' Initializes the DNAnexus environment by setting up the binary, authentication,
#' project, and path. This function must be called before other DNAnexus functions
#' can be used.
#'
#' @param dx_binary Character string specifying the path to the dx binary.
#'   If NULL (default), assumes "dx" is in PATH.
#' @param dx_token Character string specifying the DNAnexus authentication token.
#'   If NULL (default), tries to use existing authentication.
#' @param dx_project Character string specifying the DNAnexus project ID.
#'   If NULL (default), no project is selected.
#' @param dx_path Character string specifying the DNAnexus project path.
#'   If NULL (default), uses project root.
#' @param check_connectivity Logical. If TRUE (default), checks connectivity before
#'   initialization.
#'
#' @return Invisible TRUE if successful, aborts on failure
#' @export
#'
#' @examples
#' \dontrun{
#' # Initialize with default settings
#' # dx_init()
#' #
#' # Initialize with specific settings
#' # dx_init(
#' #   dx_binary = "/path/to/dx",
#' #   dx_token = "your-token-here",
#' #   dx_project = "project-xxxxx",
#' #   dx_path = "/data"
#' # )
#' }
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

#' Check if DNAnexus is Initialized
#'
#' Verifies that the DNAnexus environment has been properly initialized.
#' This function should be called before performing any DNAnexus operations.
#'
#' @return Invisible TRUE if initialized, aborts if not
#' @export
#'
#' @examples
#' \dontrun{
#' # Check initialization status
#' # dx_is_initialized()
#' }
dx_is_initialized <- function() {
  initialization_success <- get_dx_cache("dx_initialized")
  if (!initialization_success) {
    rlang::abort("`ofhelper` is not initialized. Run `dx_init()` first")
  }
  invisible(TRUE)
}


#' Set DNAnexus Binary Path
#'
#' Sets the path to the DNAnexus dx binary. This is typically called internally
#' by dx_init().
#'
#' @param dx_binary Character string specifying the path to the dx binary.
#'   If NULL (default), assumes "dx" is in PATH.
#'
#' @return Invisible TRUE if successful
#' @export
#'
#' @examples
#' \dontrun{
#' # Set dx binary path
#' # dx_set_binary("/usr/local/bin/dx")
#' }
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

#' Get DNAnexus Environment Information
#'
#' Retrieves current DNAnexus environment information including user, project,
#' path, and server details.
#'
#' @return Named character vector with environment information
#' @export
#'
#' @examples
#' \dontrun{
#' # Get environment info
#' # dx_get_env()
#' }
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

#' Set DNAnexus Environment Cache
#'
#' Sets the internal cache with current DNAnexus environment information.
#' This is typically called internally by dx_init().
#'
#' @return Invisible TRUE if successful
#' @export
#'
#' @examples
#' \dontrun{
#' # Set environment cache
#' # dx_set_env()
#' }
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

#' Clear DNAnexus Environment
#'
#' Clears the current DNAnexus environment settings.
#'
#' @return Invisible TRUE if successful
#' @export
#'
#' @examples
#' \dontrun{
#' # Clear environment
#' # dx_clear_env()
#' }
dx_clear_env <- function() {
  dx_binary <- get_dx_cache("dx_binary")
  system2(dx_binary, "clearenv")
  invisible(TRUE)
}

#' Authenticate with DNAnexus
#'
#' Authenticates with DNAnexus using a provided token.
#'
#' @param dx_token Character string specifying the DNAnexus authentication token.
#'
#' @return Invisible TRUE if successful, FALSE otherwise
#' @export
#'
#' @examples
#' \dontrun{
#' # Authenticate with token
#' # dx_auth("your-auth-token")
#' }
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

#' Find DNAnexus Projects
#'
#' Finds all accessible DNAnexus projects and returns them with names and IDs.
#'
#' @return Named character vector mapping project names to IDs
#' @export
#'
#' @examples
#' \dontrun{
#' # Find projects
#' # dx_find_projects()
#' }
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

#' Set DNAnexus Project
#'
#' Selects a DNAnexus project to work with.
#'
#' @param dx_project_id Character string specifying the DNAnexus project ID.
#'
#' @return Invisible TRUE if successful, aborts on failure
#' @export
#'
#' @examples
#' \dontrun{
#' # Set project
#' # dx_set_project("project-xxxxx")
#' }
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

#' Set DNAnexus Path
#'
#' Sets the working directory within the DNAnexus project.
#'
#' @param dx_path Character string specifying the DNAnexus project path.
#'
#' @return Invisible TRUE if successful, aborts on failure
#' @export
#'
#' @examples
#' \dontrun{
#' # Set path
#' # dx_set_path("/data/subfolder")
#' }
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


#' List Contents of DNAnexus Directory
#'
#' Lists the contents of a DNAnexus directory.
#'
#' @param directory Character string specifying the directory path to list.
#'   If NULL (default), lists current directory.
#'
#' @return Character vector with directory contents
#' @export
#'
#' @examples
#' \dontrun{
#' # List current directory
#' # dx_ls()
#' #
#' # List specific directory
#' # dx_ls("/data")
#' }
dx_ls <- function(directory = NULL) {
  dx_is_initialized()
  if (is.null(directory)) {
    dx_check_path()
    return(dx_run_cmd("ls"))
  } else {
    return(dx_run_cmd("ls", directory))
  }
}


#' Remount DNAnexus Project
#'
#' Remounts the DNAnexus project file system.
#'
#' @return Invisible TRUE if successful
#' @export
#'
#' @examples
#' \dontrun{
#' # Remount project
#' # dx_remount_project()
#' }
dx_remount_project <- function() {
  system("umount /mnt")
  system("mkdir -p /mnt")
  system(
    "/home/dnanexus/dxfuse -readOnly /mnt /home/dnanexus/.dxfuse_manifest.json"
  )
}
