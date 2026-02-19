#' Run Arbitrary DX Commands
#'
#' A flexible wrapper for executing arbitrary DNAnexus commands through the dx CLI.
#' This function allows you to run any dx command with its arguments.
#'
#' @param cmd Character string specifying the dx command to run (e.g., "ls", "upload", "find")
#' @param ... Additional arguments to pass to the dx command
#' @param dx_stdout Where to direct STDOUT. Equivalent to the `stdout` parameter
#'   of `system2` Defaults to TRUE, capturing output.
#' @param dx_stderr Where to direct STDOUT. Equivalent to the `stderr` parameter
#'   of `system2`. Defaults to TRUE, capturing output.
#'
#' @return Character vector containing the command with output (depending on
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
  dx_stderr = FALSE
) {
  dx_is_initialized()
  dx_binary <- get_dx_cache("dx_binary")

  # Build command arguments
  args <- c(cmd, ...)

  # Execute command
  result <- system2(
    dx_binary,
    args,
    stdout = dx_stdout,
    stderr = dx_stderr
  )

  # Return result
  result
}
