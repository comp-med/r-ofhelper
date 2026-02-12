#' Decode Multi-Select Variables
#'
#' Decodes multi-select coded variables by mapping coded values to their
#' corresponding meanings within bracketed strings.
#'
#' This function processes multi-select data where each observation may contain
#' multiple coded values separated by commas or pipes within brackets. It
#' replaces coded values with their decoded meanings while preserving the
#' multi-select structure. All separators are normalized to pipes for downstream
#' uniformity.
#'
#' @param x Character vector of multi-select coded values. Each element should
#'   be in the format "[CODE1,CODE2]" or "[CODE1|CODE2]"
#' @param code Character vector of coded values for mapping
#' @param meaning Character vector of corresponding decoded meanings
#'
#' @return Character vector with decoded values. Multi-select values maintain
#'   bracketed format with decoded meanings separated by pipes.
#' @export
#'
#' @examples
#' \dontrun{
#' # Create mapping
#' codes <- c("A1", "B2", "C3")
#' meanings <- c("Option A", "Option B", "Option C")
#'
#' # Decode multi-select variables
#' # decoded <- decode_multi_select(
#' #   x = c("[A1,B2]", "[C3]", "[A1|B2|C3]"),
#' #   code = codes,
#' #   meaning = meanings
#' # )
#' # Result: c("[Option A|Option B]", "[Option C]", "[Option A|Option B|Option C]")
#' }
#'
#' @seealso \code{\link{decode_single_select}} for single-select decoding
#' \code{\link{decode_ofh_variable}} for the generic decoder
decode_multi_select <- function(x, code, meaning) {

  # Normalize separators to pipe for downstream uniformity
  x <- gsub(",", "|", x, fixed = TRUE)
  
  map <- stats::setNames(meaning, code)

  # Remove brackets
  x <- gsub('\\[|\\]|\\"', "", x)

  # Replace values using regex word boundaries -> gsub() is great!
  for (k in names(map)) {
    x <- gsub(
      # Check for single values ^VALUE$ or values separated by `,` or `|` e.g.
      # VAL1,VAL2 or VAL1|VAL2
      # Uses non-consuming look-ahead and look-behind to make sure values are
      # either separated or single
      paste0("(?<=^|,|\\|)", k, "(?=\\||,|$)"),
      paste0("\\1", map[[k]]),
      x, perl = TRUE
    )
  }

  # This assumes `,` is only used to separate values
  multi_val_index <- grepl(",|\\|", x)
  x[multi_val_index] <- paste0("[", x[multi_val_index], "]")
  x
}
