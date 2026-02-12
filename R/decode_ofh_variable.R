#' Decode OFH Variable
#'
#' Generic decoder function that routes variable decoding to either single-select
#' or multi-select decoding based on the \code{is_multi_select} parameter.
#'
#' This function serves as a dispatcher that calls the appropriate decoding
#' function (\code{\link{decode_single_select}} or \code{\link{decode_multi_select}})
#' based on whether the variable represents single or multiple selections.
#'
#' @param variable A vector of coded values to be decoded
#' @param is_multi_select Logical. If \code{TRUE}, treats the variable as
#'   multi-select (multiple values per observation). If \code{FALSE}, treats
#'   as single-select (one value per observation).
#' @param code Character vector of coded values to be matched
#' @param meaning Character vector of corresponding decoded meanings
#'
#' @return Character vector with decoded values. For multi-select variables,
#'   returns character strings with bracketed comma-separated values.
#'   For single-select variables, returns character vector of decoded meanings.
#' @export
#'
#' @examples
#' \dontrun{
#' # Decode a single-select variable
#' # codes <- c("A1", "B2", "C3")
#' # meanings <- c("Option A", "Option B", "Option C")
#' # decoded <- decode_ofh_variable(
#' #   variable = c("A1", "B2", "A1"),
#' #   is_multi_select = FALSE,
#' #   code = codes,
#' #   meaning = meanings
#' # )
#'
#' # Decode a multi-select variable
#' # decoded_multi <- decode_ofh_variable(
#' #   variable = c("[A1,B2]", "[C3]"),
#' #   is_multi_select = TRUE,
#' #   code = codes,
#' #   meaning = meanings
#' # )
#' }
#'
#' @seealso \code{\link{decode_single_select}} for single-select decoding
#' \code{\link{decode_multi_select}} for multi-select decoding
decode_ofh_variable <- function(
    variable,
    is_multi_select = logical(),
    code = character(),
    meaning = character()
) {

  if (typeof(variable) != "character") {
    variable <- as.character(variable)
  }

  if (is_multi_select) {

    decoded_variable <- decode_multi_select(
      variable,
      code,
      meaning
    )
  } else {

    decoded_variable <- decode_single_select(
      variable,
      code,
      meaning
    )

  }

  return(decoded_variable)
}
