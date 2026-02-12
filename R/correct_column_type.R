#' Correct Data Column Type
#'
#' Corrects data column types after decoding to match annotated types.
#'
#' This internal function is used to convert decoded data to appropriate data types
#' based on annotations from the data dictionary. It is called after decoding
#' operations to ensure proper data types are maintained for downstream analysis.
#'
#' @param x Vector of decoded data values
#' @param annotated_type Character string specifying the expected data type
#'   (one of "string", "integer", "date", "float", "datetime", "numeric")
#'
#' @return Vector with corrected data type
correct_column_type <- function(
  x,
  annotated_type
) {
  # mapping table for data dictionary type annotation
  # This is based on all types listed in the data dictionary and should be const
  map <- c("string", "integer", "date", "float", "datetime", "numeric")
  annotated_type <- match.arg(annotated_type, map)
  map <- stats::setNames(
    map,
    c("character", "integer", "IDate", "numeric", "POSIXct", "numeric")
  )

  map <- map[map == annotated_type]
  type_is_correct <- names(map) %in% class(x)

  # check if type is correct and if so, return data unchanged

  if (type_is_correct) {
    return(x)
  }

  x <- switch(
    map,
    "string" = as.character(x),
    "integer" = as.integer(x),
    "date" = data.table::as.IDate(x),
    "float" = as.numeric(x),
    "datetime" = as.POSIXct(x),
    "numeric" = as.numeric(x),
    x
  )

  return(x)
}
