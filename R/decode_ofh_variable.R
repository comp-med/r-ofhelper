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
