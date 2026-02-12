#' Download Files from DNAnexus
#'
#' Download files from the currently selected DNAnexus project and folder.
#' This function provides a convenient wrapper around the `dx download` command.
#'
#' @param files Character vector of DNAnexus file identifiers or paths to download.
#' @param local_dir Character string specifying the local directory to download files to.
#'   If NULL (default), uses the current working directory.
#' @param overwrite_existing Logical. If TRUE (default), overwrites existing local files
#'   with the same name. If FALSE, skips files that already exist.
#'
#' @return Character vector containing the download command output (stdout)
#' @export
#'
#' @examples
#' \dontrun{
#' # Download a single file
#' # dx_download("file_id_123")
#' #
#' # Download multiple files to a specific directory
#' # dx_download(c("file_id_1", "file_id_2"), local_dir = "./downloads")
#' #
#' # Download with overwrite disabled
#' # dx_download("file_id_123", overwrite_existing = FALSE)
#' }
dx_download <- function(
  files,
  local_dir = ".",
  overwrite_existing = TRUE
) {
  dx_is_initialized()

  # Validate files parameter
  if (length(files) == 0) {
    rlang::abort("No files specified for download")
  }

  # Validate local directory exists
  if (!dir.exists(local_dir)) {
    dir.create(local_dir, recursive = TRUE)
  }

  # Build arguments for dx download
  args <- c("download")

  # Add file identifiers
  args <- c(args, files)

  # Add local directory if specified
  if (!is.null(local_dir) && local_dir != ".") {
    args <- c(args, local_dir)
  }

  # Execute dx download command
  dx_run_cmd(args)
}
