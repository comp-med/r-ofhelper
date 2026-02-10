#' Run Arbitrary DX Commands
#'
#' A flexible wrapper for executing arbitrary DNAnexus commands through the dx CLI.
#' This function allows you to run any dx command with its arguments.
#'
#' @param cmd Character string specifying the dx command to run (e.g., "ls", "upload", "find")
#' @param ... Additional arguments to pass to the dx command
#'
#' @return Character vector containing the command output (stdout)
#' @export
#'
#' @examples
#' # List files in current directory
#' # dx_run_cmd("ls")
#' # 
#' # Run a find command with filters
#' # dx_run_cmd("find", "projects", "--name", "MyProject")
dx_run_cmd <- function(
  cmd = NULL,
  ...) {
  dx_is_initialized()
  dx_binary <- get_dx_cache("dx_binary")
  
  # Build command arguments
  args <- c(cmd, ...)
  
  # Execute command
  result <- system2(
    dx_binary,
    args,
    stdout = TRUE,
    stderr = TRUE
  )
  
  # Return result
  result
}