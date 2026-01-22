
correct_column_type <- function(
    x,
    annotated_type
){

  # mapping table for data dictionary type annotation
  # This is based on all types listed in the data dictionary and should be const
  map <- c("string", "integer", "date", "float", "datetime", "numeric")
  annotated_type <- match.arg(annotated_type, map)
  map <- setNames(
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
    "date" = as.IDate(x),
    "float" = as.numeric(x),
    "datetime" = as.POSIXct(x),
    "numeric" = as.numeric(x),
    x
  )

  return(x)
}
