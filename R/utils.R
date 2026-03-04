# This is here to get rid of a check note
utils::globalVariables(".")

#' Decompress gzipped files
#'
#' Decompress gzipped files using the `gzip` utility
#'
#' @param files gzipped files to be decompressed
#'
#' @returns TRUE on success
decompress_gzip <- function(files) {
  if (!any(fs::path_ext(files) != "gz")) {
    rlang::abort("All files should end on `.gz`")
  }

  gz_bin <- Sys.which("gzip")
  if (gz_bin == "") {
    rlang::abort("`gzip` not found in $PATH")
  }

  gz_check <- system2(
    command = gz_bin,
    args = "--help",
    stdout = NULL,
    stderr = NULL
  )
  if (gz_check != 0) {
    rlang::abort("`gzip` returned non-zero exit code")
  }
  gz_success <- system2(
    command = gz_bin,
    args = c("-d", files),
    stdout = NULL,
    stderr = NULL
  )
  if (gz_success != 0) {
    rlang::abort("`gzip` failed to extract files")
  }
  decompressed_files <- fs::path_ext_remove(files)

  if (!any(fs::file_exists(decompressed_files))) {
    rlang::abort("Decompressed files not found")
  }

  rlang::inform(glue::glue(
    "Decompressed files: {paste(decompressed_files, collapse = ', ')}"
  ))

  invisible(TRUE)
}
