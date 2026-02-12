#' Check if a File Exists on DNAnexus
#'
#' Checks whether a specific file exists in the current DNAnexus project and path.
#' This function uses the dx CLI to verify file existence.
#'
#' @param file_path Character string specifying the path to the file on DNAnexus
#'   (e.g., "data/input.csv" or "project-xxxx:/file_name.txt")
#'
#' @return Logical indicating whether the file exists (TRUE/FALSE)
#' @export
#'
#' @examples
#' \dontrun{
#' # Check if a file exists
#' # file_exists <- dx_file_exists("data/input.csv")
#' #
#' # Check if a file exists with full path
#' # file_exists <- dx_file_exists("project-xxxx/data/file.txt")
#' }
dx_file_exists <- function(file_path) {
  # Validate DNAnexus initialization
  dx_is_initialized()

  # Use dx ls command which is the most reliable way to check file existence
  dx_binary <- get_dx_cache("dx_binary")

  # Build command arguments
  args <- c("ls", file_path)

  # Execute command
  result <- system2(
    dx_binary,
    args,
    stdout = NULL,
    stderr = NULL
  )

  if (result != 0) {
    return(FALSE)
  }

  return(TRUE)
}
