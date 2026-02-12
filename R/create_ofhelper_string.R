#' Create Complete ofhelper Package Source String
#'
#' Creates a complete concatenated string of all ofhelper package R script files.
#' This function is specifically designed for environments like the Our Future Health
#' TRE where external packages cannot be installed, allowing the complete package
#' source to be embedded directly into command executions.
#'
#' The function reads all R scripts from the ofhelper package and combines them
#' into a single string that can be included in command inputs, eliminating the
#' need for package installation in restricted environments.
#'
#' @return Character string containing the complete source code of all ofhelper
#'   R scripts concatenated together
#' @export
#'
#' @examples
#' \dontrun{
#' # Create the complete ofhelper package source
#' # ofhelper_code <- create_ofhelper_string()
#' }
#'
#' @seealso \code{\link{create_cmd_input_string}} for usage in Jupyter workstation contexts
create_ofhelper_string <- function() {
  pkgs_installed <- utils::installed.packages()[, 1]
  pkg <- "ofhelper"
  ofhelpers_installed <- pkg %in% pkgs_installed

  if (!ofhelpers_installed) {
    rlang::abort("`ofhelper` package must be installed to be included")
  }

  pkg <- "ofhelper"
  ns <- asNamespace(pkg)

  objs <- lapply(ls(ns), function(nm) get(nm, envir = ns))
  names(objs) <- ls(ns)

  # keep only functions
  objs <- objs[sapply(objs, is.function)]

  # skip primitives
  objs <- objs[!sapply(objs, is.primitive)]

  # deparse safely
  code <- lapply(seq_along(objs), function(i) {
    nm <- names(objs)[i]
    body <- paste(deparse(objs[[i]], width.cutoff = 500L), collapse = "\n")
    paste0("`", nm, "` <- ", body)
  })

  script <- paste(code, collapse = "\n\n")
  cat(script)
}
