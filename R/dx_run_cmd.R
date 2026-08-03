#' Run Arbitrary DX Commands
#'
#' A flexible wrapper for executing arbitrary DNAnexus commands through the dx
#' CLI. This function allows you to run any dx command with its arguments.
#'
#' @param cmd Character string specifying the dx command to run (e.g., "ls",
#'   "upload", "find")
#' @param ... Additional arguments to pass to the dx command
#' @param dx_stdout Logical, whether to return STDOUT. Equivalent to the
#'   `stdout` parameter of `system2` Defaults to TRUE, capturing output.
#' @param dx_stderr Logical, whether to return STDERR. Equivalent to the
#'   `stderr` parameter of `system2`. Defaults to TRUE, capturing output.
#' @param fail_on_dx_error Logical, whether to panic with error message when
#'   `dx` returns an error or whether to return the result regardless. Defaults
#'   to TRUE
#' @param .require_init Logical. Internal parameter needed for bootstrapping
#'   package while setting up cache. Defaults to TRUE and should not be modified
#'   by the user
#' @param .dx_binary Character. Path to dx_binary when running the command
#'   pre-initialization. Defaults to `NULL` and should be left untouched
#'
#' @return List containging exit code, stdout and stderr (depending on
#'   `dx_stdout` and `dx_stderr`)
#' @export
#'
#' @examples
#' \dontrun{
#' # List files in current directory
#' # dx_run_cmd("ls")
#' #
#' # Run a find command with filters
#' # dx_run_cmd("find", "projects", "--name", "MyProject")
#' }
dx_run_cmd <- function(
  cmd = NULL,
  ...,
  dx_stdout = TRUE,
  dx_stderr = TRUE,
  fail_on_dx_error = TRUE,
  .require_init = TRUE,
  .dx_binary = NULL
) {
  if (isTRUE(.require_init)) {
    dx_is_initialized()
    dx_binary <- get_dx_cache("dx_binary")
  } else {
    dx_binary <- get_dx_cache("dx_binary") %||% .dx_binary
    if (is.null(dx_binary)) {
      rlang::abort("Need path to `dx` tools to continue")
    }
  }

  if (!is.logical(dx_stdout) || !is.logical(dx_stderr)) {
    rlang::abort("`dx_stdout` and `dx_stderr` can only be TRUE/FALSE")
  }

  args <- c(cmd, ...)
  # ensure the files are created by adding a dummy line
  tmp_stdout <- withr::local_tempfile(lines = ".dummy")
  tmp_stderr <- withr::local_tempfile(lines = ".dummy")
  exit_code <- system2(
    dx_binary,
    args,
    env = remove_tre_proxy_env_var(), # NOTE: This might be a temporary fix
    stdout = tmp_stdout,
    stderr = tmp_stderr
  )
  # read the files and remove dummy line
  tmp_stdout <- readLines(tmp_stdout)
  tmp_stderr <- readLines(tmp_stderr)
  tmp_stdout <- tmp_stdout[tmp_stdout != ".dummy"]
  tmp_stderr <- tmp_stderr[tmp_stderr != ".dummy"]
  if (exit_code != 0 && fail_on_dx_error) {
    err_msg <- paste(tmp_stderr, collapse = ", ")
    rlang::abort(glue::glue(
      "Call to `dx` returned exit code {exit_code} with error message: ",
      "{err_msg}"
    ))
  }
  result <- list(
    "exit_code" = exit_code,
    "stdout" = NULL,
    "stderr" = NULL
  )
  if (dx_stdout) {
    result$stdout <- tmp_stdout
  }
  if (dx_stderr) {
    result$stderr <- tmp_stderr
  }
  return(result)
}
