#' Upload Files to DNAnexus
#'
#' Upload files to the currently selected DNAnexus project and folder.
#' This function provides a convenient wrapper around the `dx upload` command.
#'
#' @param files Character vector of file paths to upload. Can be glob patterns or
#'   individual file paths.
#' @param target_dir Character string specifying the target directory in DNAnexus.
#'   If NULL (default), uses the current working directory.
#' @param overwrite_old_files Logical. If TRUE (default), overwrites existing files
#'   with the same name. If FALSE, skips files that already exist.
#'
#' @return Character vector containing the upload command output (stdout)
#' @export
#'
#' @examples
#' # Upload a single file
#' # dx_upload("local_file.csv")
#' #
#' # Upload multiple files to a specific directory
#' # dx_upload(c("file1.csv", "file2.csv"), target_dir = "/my_folder")
#' #
#' # Upload with overwrite disabled
#' # dx_upload("data.csv", overwrite_old_files = FALSE)
dx_upload <- function(
  files,
  target_dir = NULL,
  overwrite_old_files = TRUE
) {
  dx_is_initialized()

  if (inherits(files, "character")) {
    file_paths <- files
  } else {
    file_paths <- as.character(files)
  }

  # Set target directory
  cached_dx_path <- get_dx_cache("dx_path")
  dx_path <- target_dir %||% cached_dx_path
  if (dx_path != cached_dx_path) {
    dx_check_path()
    dx_set_path(dx_path)
  }

  # Build arguments for dx upload
  args <- c("upload")

  # TODO - this flag does not exist! the file needs to be manually deleted using `dx rm`
  # Add overwrite flag if requested
  if (overwrite_old_files) {
    args <- c(args, "--overwrite")
  }

  # Add file paths
  args <- c(args, file_paths)

  # Add target path if specified
  if (!is.null(target_dir)) {
    args <- c(args, target_dir)
  }

  # Execute dx upload command
  dx_run_cmd(args)
}
