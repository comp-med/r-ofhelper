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
#' \dontrun{
#' # Upload a single file
#' # dx_upload("local_file.csv")
#' #
#' # Upload multiple files to a specific directory
#' # dx_upload(c("file1.csv", "file2.csv"), target_dir = "/my_folder")
#' #
#' # Upload with overwrite disabled
#' # dx_upload("data.csv", overwrite_old_files = FALSE)
#' #
#' # Upload files using glob patterns
#' # dx_upload("data_*.csv")
#' }
dx_upload <- function(
  files,
  target_dir = NULL,
  overwrite_old_files = TRUE
) {
  dx_is_initialized()

  # Expand file paths to handle glob patterns
  if (inherits(files, "character")) {
    file_paths <- files
  } else {
    file_paths <- as.character(files)
  }

  # Add target path if specified
  if (is.null(target_dir)) {
    target_dir <- "./"
  }

  # Expand glob patterns to actual file paths
  expanded_files <- c()
  for (file_path in file_paths) {
    # Handle glob patterns
    if (grepl("[*?[]", file_path)) {
      # Use system glob expansion
      glob_files <- Sys.glob(file_path)
      expanded_files <- c(expanded_files, glob_files)
    } else {
      # If it's a single file path, add it directly
      expanded_files <- c(expanded_files, file_path)
    }
  }

  # Validate that files exist
  existing_files <- expanded_files[file.exists(expanded_files)]
  if (length(existing_files) == 0) {
    rlang::abort("No valid files to upload")
  }

  # Handle overwrite logic for each file
  if (overwrite_old_files) {
    # Check for existing files and remove them if they exist
    for (file_path in existing_files) {
      file_name <- basename(file_path)

      # Find existing files with the same name
      find_result <- tryCatch(
        {
          dx_run_cmd(
            c(
              "find",
              "data",
              "--name",
              file_name,
              "--class",
              "file",
              "--brief",
              "--path",
              target_dir,
              "--norecurse"
            ),
            fail_on_dx_error = TRUE,
            dx_stderr = FALSE
          )$stdout
        },
        error = function(e) {
          # If find command fails, proceed with upload anyway
          NULL
        }
      )

      # If we found existing files with the same name, delete them
      if (!is.null(find_result) && length(find_result) > 0) {
        # Delete the existing file(s)
        res <- dx_run_cmd(
          "rm",
          "-f",
          fs::path(target_dir, file_name),
          fail_on_dx_error = TRUE
        )
      }
    }
  }

  # Build arguments for dx upload
  args <- c("upload", "--path", paste0(target_dir, "/"), existing_files)

  # Execute dx upload command
  dx_run_cmd(
    args,
    fail_on_dx_error = TRUE,
    dx_stdout = FALSE,
    dx_stderr = FALSE
  )
}
