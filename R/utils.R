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
  if (any(fs::path_ext(files) != "gz")) {
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
    stdout = "",
    stderr = ""
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


#' Create batch ID string for genomic files
#'
#' Create formatted string for genomic file batches. Can be used to create
#' genomic file names.
#'
#' @param n_batches Integer. Number of batches for which IDs should be
#'   generated. Enumerates from 1..`n_batches`
#'
#' @returns Formatted character vector, e.g. c("b0001", "b0002") for for input
#'   `n_batches = 2`
#'
create_genomic_file_batch_ids <- function(n_batches) {
  batches <- seq_len(n_batches)
  batches <- stringr::str_pad(batches, 4, side = "left", pad = "0")
  glue::glue("b{batches}")
}

#' Create genomic file prefix
#'
#' Create a formatted string containing chromosome and batch ID that can be used to
#'
#' @param prefix Character. [glue::glue()] style string for formatting, e.g.
#'   "ofh_imputed.v5.\{chr\}-\{batch\}"
#' @param chr Character. The chromosome identifier, Ensembl style: chr1, chr2, ... chrX
#' @inheritParams create_genomic_file_batch_ids
#'
#' @returns Formatted prefixes
#' @export
#'
create_genomic_file_prefix <- function(prefix, chr, n_batches) {
  batches <- create_genomic_file_batch_ids(n_batches)
  glue::glue(prefix, chr = chr, batch = batches)
}

#' Create OFH imputed genomic file prefix
#'
#' @inheritParams create_genomic_file_prefix
#'
#' @returns Formatted character strings.
#' @export
create_imputed_file_prefix <- function(chr, n_batches) {
  create_genomic_file_prefix(
    prefix = "ofh_imputed.v5.{chr}-{batch}",
    chr,
    n_batches
  )
}

#' Create OFH imputed genomic file BGEN file names
#'
#' @inheritParams create_genomic_file_prefix
#'
#' @returns OFH imputed BGEN file names
#' @export
#'
create_bgen_file_names <- function(chr, n_batches) {
  bgen_prefix <- create_imputed_file_prefix(chr, n_batches)
  glue::glue("{bgen_prefix}.bgen")
}

#' Create OFH imputed genomic file BGEN Sample file names
#'
#' @inheritParams create_genomic_file_prefix
#'
#' @returns OFH imputed BGEN Sample file names
#' @export
#'
create_sample_file_names <- function(chr, n_batches) {
  sample_prefix <- create_imputed_file_prefix(chr, n_batches)
  glue::glue("{sample_prefix}.sample")
}
