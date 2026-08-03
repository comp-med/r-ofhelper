# This is here to get rid of a check note
utils::globalVariables(".")



#' Remove proxy environment variable on OFH TRE
#'
#' This is a convenience function that removes the environmental for the https
#' proxy when a shell command is run within an R session on the OFH DNAnexus TRE.
#' This is done to mitigate an error when running `dx` commands that seems to be
#' caused by this variable.
#'
#'
#' @returns Character vector containing relevant variables formatted as `VARIABLE=VALUE`
#'
remove_tre_proxy_env_var <- function() {

  tre_proxy <- "http://10.0.3.1:8000"
  proxy_vars <- c("HTTPS_PROXY", "https_proxy")
  proxy_vars <- Sys.getenv(proxy_vars)
  on_tre <- tre_proxy %in% proxy_vars

  if (on_tre) {
    return("https_proxy=")
  }
  c()
}

#' Create TRE-compatible path
#'
#' This is a thin wrapper around [fs::path()] that creates a full path
#' consisting of the project ID and the full path by appending a colon `:` to
#' the project ID before adding the path, e.g. `project:/path/to/file`
#'
#' @param project Character. The TRE project ID where the path is located.
#' @param ... Character. Character vectors that will be passed to [fs::path()]
#'   that make up the full path.
#'
#' @returns Character. A single character string describing a path in the form
#'   "project:/path/to/file"
#' @export
#'
#' @examples
#' tre_path("project-12345", "path", "to", "some", "file")
#'
tre_path <- function(
    project,
    ...
) {
  fs::path(glue::glue("{project}:"), ...)
}

#' Collapse Command Arguments
#'
#' When submitting jobs to the Swiss Army Knife, this function is a convenience
#' function to collapse the function arguments into a single call before
#' submitting the call to [dx_run_swiss_army_knife()].
#'
#' @param cmd Character. The command to be run, e.g. `plink2`
#' @param args Character. Vector of the arguments to `cmd`.
#'
#' @returns A single character string that can be passed to the `-icmd` flag of
#'   the Swiss Army Knife
#' @export
#'
#' @examples
#' \dontrun{
#' args <- "plink2"
#' cmd <- c("pfile", "ofh_data", "--make-bed", "--out", "ofh_data_bed")
#'
#' collapse_cmd_args(args, cmd)
#' }
collapse_cmd_args <- function(cmd, args) {
  args <- paste(args, collapse = " ")
  paste(cmd, args, collapse = " ")
}

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

#' Create BGEN File Annotation
#'
#' This function tries to parse an OFH directory for BGEN files and creates an
#' annotation table that makes processing the data simpler.
#'
#' @param project_id Character. An DNAnexus project ID where the data was
#'   dispensed.
#' @param bgen_dir Character. The path to the raw BGEN files. Should be either
#'   `/snv_bgen/` or `/imputed_bgen/`
#'
#' @returns A data.table with the full paths to the BGEN files and some parsed
#'   information
#' @export
#'
create_bgen_annotation <- function(
    project_id,
    bgen_dir
) {
  data_path <- fs::path(glue::glue("{project_id}:"), bgen_dir)
  all_files <- dx_ls(data_path)

  annot <- stringr::str_split_fixed(
    string = all_files,
    pattern = "\\.|\\-",
    n = 6
  )
  annot <- data.table::as.data.table(annot)
  data.table::setnames(
    annot,
    c("prefix", "version", "chr", "batch", "ext_1", "ext_2")
  )
  annot[,
        ext := data.table::fifelse(
          ext_2 == "",
          ext_1,
          paste(ext_1, ext_2, sep = ".")
        )
  ]
  annot$ext_1 <- NULL
  annot$ext_2 <- NULL
  annot[, file_name := all_files]

  if (data.table::uniqueN(annot$prefix) != 1) {
    rlang::abort("Expected single unique file prefix")
  }

  annot <- data.table::dcast(
    annot,
    "prefix + version + chr + batch ~ ext",
    value.var = "file_name"
  )

  annot[, `:=`(
    file_project = project_id,
    bgen_dir = bgen_dir
  )]

  annot[, `:=`(
    full_bgen_file_path = fs::path(
      paste0(file_project, ":"),
      bgen_dir,
      bgen
    ),
    full_sample_file_path = fs::path(
      paste0(file_project, ":"),
      bgen_dir,
      sample
    )
  )]

  annot
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
#'   "ofh_imputed.\{version\}.\{chr\}-\{batch\}". Needs to contain `version`,
#'   `chr` & `batch`
#' @param version Character. The release version of the genomic data, e.g. `v9`
#' @param chr Character. The chromosome identifier, Ensembl style: chr1, chr2, ... chrX
#' @inheritParams create_genomic_file_batch_ids
#'
#' @returns Formatted prefixes
#' @export
#'
create_genomic_file_prefix <- function(prefix, version, chr, n_batches) {
  batches <- create_genomic_file_batch_ids(n_batches)
  glue::glue(prefix, version = version, chr = chr, batch = batches)
}

#' Create OFH imputed genomic file prefix
#'
#' @param version Character. File version, default is "v5". Will change
#'   depending on which data release is being used in each project
#' @inheritParams create_genomic_file_prefix
#'
#' @returns Formatted character strings for imputed genotype files.
#' @export
create_imputed_file_prefix <- function(version = "v5", chr, n_batches) {
  create_genomic_file_prefix(
    # TODO: Version is updated and should not be hard-coded
    prefix = "ofh_imputed.{version}.{chr}-{batch}",
    version,
    chr,
    n_batches
  )
}

#' Create OFH called genotype file prefix
#'
#' @param version Character. File version, default is "v9". Will change
#'   depending on which data release is being used in each project
#' @inheritParams create_genomic_file_prefix
#'
#' @returns Formatted character strings for SNV files
#' @export
#'
create_snv_file_prefix <- function(version = "v9", chr, n_batches) {
  create_genomic_file_prefix(
    # TODO: Version is updated and should not be hard-coded
    prefix = "ofh_snv.{version}.{chr}-{batch}",
    version,
    chr,
    n_batches
  )
}

#' Create OFH genomic file BGEN file names
#'
#' This function simply adds the `.bgen` ending to the supplied file prefix
#'
#' @param file_prefix Character. Vector of file prefixes that the `.bgen` ending
#'   will be applied to.
#'
#' @returns BGEN file names
#' @export
#'
create_bgen_file_names <- function(file_prefix) {
  glue::glue("{file_prefix}.bgen")
}

#' Create OFH imputed genomic file BGEN Sample file names
#'
#' @param file_prefix Character. Vector of file prefixes that the `.sample`
#'   ending will be applied to.
#'
#' @returns BGEN Sample file names
#' @export
#'
create_sample_file_names <- function(file_prefix) {
  glue::glue("{file_prefix}.sample")
}
