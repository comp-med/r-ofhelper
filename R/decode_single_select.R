
#' Decode Single-Select Variables
#'
#' Decodes single-select coded variables by mapping coded values to their
#' corresponding meanings.
#'
#' This function performs exact matching of coded values against a lookup table
#' and replaces coded values with their decoded meanings. Values that don't
#' match any code are preserved as-is.
#'
#' @param variable Character vector of coded values to be decoded
#' @param code Character vector of coded values for mapping
#' @param meaning Character vector of corresponding decoded meanings
#'
#' @return Character vector with decoded values. Mapped values are replaced
#'   with their meanings, unmapped values are preserved as-is.
#' @export
#'
#' @examples
#' \dontrun{
#' # Create mapping
#' codes <- c("A1", "B2", "C3")
#' meanings <- c("Option A", "Option B", "Option C")
#'
#' # Decode single-select variables
#' # decoded <- decode_single_select(
#' #   variable = c("A1", "B2", "A1", "UNKNOWN"),
#' #   code = codes,
#' #   meaning = meanings
#' # )
#' # Result: c("Option A", "Option B", "Option A", "UNKNOWN")
#' }
#'
#' @seealso \code{\link{decode_multi_select}} for multi-select decoding
#' \code{\link{decode_ofh_variable}} for the generic decoder
decode_single_select <- function(variable, code, meaning) {
  stopifnot(length(code) == length(meaning))
  stopifnot(!anyDuplicated(code))

  idx <- match(variable, code)
  out <- meaning[idx]

  # preserve original values if unmapped by only replacing mapped values
  out[is.na(idx)] <- variable[is.na(idx)]
  out
}
