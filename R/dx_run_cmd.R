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
#' @param fail_on_dx_error Logical, whether to panic with error message when `dx`
#'   returns an error or whether to return the result regardless
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
  fail_on_dx_error = TRUE
) {
  dx_is_initialized()
  dx_binary <- get_dx_cache("dx_binary")

  if (!is.logical(dx_stdout) || !is.logical(dx_stderr)) {
    rlang::abort("`dx_stdout` and `dx_stderr` can only be TRUE/FALSE")
  }

  args <- c(cmd, ...)
  tmp_stdout <- withr::local_tempfile()
  tmp_stderr <- withr::local_tempfile()
  exit_code <- system2(
    dx_binary,
    args,
    stdout = tmp_stdout,
    stderr = tmp_stderr
  )
  tmp_stdout <- readLines(tmp_stdout)
  tmp_stderr <- readLines(tmp_stderr)
  if (exit_code != 0 && fail_on_dx_error) {
    err_msg <- paste(tmp_stderr, collapse = ", ")
    rlang::abort(glue::glue(
      "Call to `dx` returned exit code {exit_code} with error message: ",
      "{err_msg}"
    ))
  }
  result <- list(
    "exit_code" = exit_code
  )
  if (dx_stdout) {
    result$stdout <- tmp_stdout
  }
  if (dx_stdout) {
    result$stderr <- tmp_stderr
  }
  return(result)
}
