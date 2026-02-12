#' Clean OFH Codings Table
#'
#' Cleans and standardizes an OFH codings table by handling NA representations
#' and standardizing meaning formats.
#'
#' This function processes a codings table to:
#' 1. Convert specific NA representations to actual NA values
#' 2. Standardize meaning formats by extracting values from "value = description" patterns
#' 3. Ensures consistent data structure for downstream decoding operations
#'
#' @param codings_table data.table containing codings information with columns:
#'   coding_name, code, meaning, display_order, parent_code, entity
#'
#' @return data.table with cleaned codings table
#' @export
#'
#' @examples
#' \dontrun{
#' # Clean a codings table
#' # cleaned_table <- clean_codings_table(my_codings_table)
#' }
clean_codings_table <- function(codings_table) {
  # Validate input
  if (!data.table::is.data.table(codings_table)) {
    rlang::abort("codings_table must be a data.table")
  }

  required_cols <- c(
    "coding_name",
    "code",
    "meaning",
    "display_order",
    "parent_code",
    "entity"
  )
  if (!all(required_cols %in% names(codings_table))) {
    missing_cols <- required_cols[!required_cols %in% names(codings_table)]
    rlang::abort(glue::glue(
      "codings_table missing required columns: {paste(missing_cols, collapse = ', ')}"
    ))
  }

  # There are several strings representing NA in the DD
  # This comes from all codes in the coding table that are negative
  na_meanings <- c(
    "Suppressed",
    "Prefer not to answer",
    "Do not know my height",
    "Prefer not to provide my height",
    "Do not know my weight",
    "Prefer not to provide my weight",
    "Do not know",
    "Do not remember",
    "Not sure",
    "-999 = Suppressed",
    "1801-01-01 = invalid date submitted",
    "1800-01-01 = Null date submitted"
  )
  codings_table[meaning %in% na_meanings, meaning := NA]

  # replace reduntant `coding = meaning` format in `meaning` column
  codings_to_clean <- codings_table[grepl(" = ", meaning), unique(coding_name)]
  codings_table[
    coding_name %in% codings_to_clean,
    meaning := gsub("^.*=\\s*", "", meaning, perl = TRUE)
  ]

  return(codings_table)
}
