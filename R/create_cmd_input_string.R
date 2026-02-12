#' Create Command Input String for Jupyter Workstation
#'
#' Creates a command input string for submission to a Jupyter workstation
#' using the \code{-icmd} flag. Combines user script content with ofhelper
#' package code for execution in the workstation environment.
#'
#' This function reads a user script file and optionally prepends the complete
#' ofhelper package source code to ensure all required functions are available
#' in the execution context. The resulting string can be passed to a Jupyter
#' workstation using the \code{-icmd} flag.
#'
#' @param file Character string specifying the path to the user script file
#'   to be executed
#' @param include_ofhelper Logical. If \code{TRUE} (default), prepends the
#'   complete ofhelper package source code to the user script content.
#'   If \code{FALSE}, only returns the user script content.
#'
#' @return Character string containing the combined script content ready for
#'   submission to a Jupyter workstation via the \code{-icmd} flag
#' @export
#'
#' @examples
#' \dontrun{
#' # Create command string with ofhelper included
#' # cmd_string <- create_cmd_input_string("my_analysis.R")
#'
#' # Create command string without ofhelper (not recommended)
#' # cmd_string <- create_cmd_input_string("my_analysis.R", include_ofhelper = FALSE)
#' }
create_cmd_input_string <- function(
  file,
  include_ofhelper = TRUE
) {
  if (!file.exists(file)) {
    rlang::abort("File does not exist!")
  }

  if (file.info(file)$isdir) {
    rlang::abort("Provided path must be a file, not a directory!")
  }

  script_content <- readr::read_file(file)

  if (include_ofhelper) {
    ofhelper_script_content <- create_ofhelper_string()
    script_content <- glue::glue(
      "{ofhelper_script_content}\n\n{script_content}"
    )
  }
  script_content
}
