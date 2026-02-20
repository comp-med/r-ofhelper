#' Explode Multi-Select Variables into Dummy Codes
#'
#' Converts multi-select variables (where each observation can contain multiple values
#' separated by commas or pipes) into dummy-coded variables. Each unique value becomes
#' a binary column indicating presence (TRUE) or absence (FALSE) of that value.
#'
#' @param x Character vector containing multi-select data. Each element may contain
#'   multiple answers separated by either commas (`,`) or pipes (`|`).
#' @param answer_separators Character vector specifying separators to split answers.
#'   Default is "|" since "," are used within the answers.
#'
#' @return A data.table with
#'   - Wide format: one row per input element, one column per unique value (binary)
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Basic usage
#' x <- c("A,B", "B,C", "A,C", "A|B|C")
#' result <- explode_multi_select(x)
#'
#' # With long format
#' result_long <- explode_multi_select(x, long_format = TRUE)
#'
#' # With custom separators
#' x2 <- c("A;B", "B;C")
#' result2 <- explode_multi_select(x2, answer_separators = ";")
#' }
explode_multi_select <- function(
  x,
  answer_separators = "|"
) {
  # TODO this should be a separate function
  specials <- "([.|()\\^{}+$*?]|\\[|\\]|\\\\)"
  escaped_seps <- gsub(specials, "\\\\\\1", answer_separators)
  joint_seps <- paste(escaped_seps, collapse = "|")

  unique_entries <- unique(x)
  unique_entries <- gsub('\\[|\\]|\\"', "", unique_entries)
  unique_entries <- strsplit(unique_entries, joint_seps)
  unique_entries <- unique(unlist(unique_entries))

  # This should be excluded
  na_string <- "NA"
  unique_entries <- unique_entries[unique_entries != na_string]
  unique_entries <- unique_entries[!is.na(unique_entries)]
  res <- data.table::data.table()
  res[, original := x]
  res[, index := .I]

  # create a vector for each dummy-coded variable
  for (k in unique_entries) {
    search_term <- paste0(
      "(?<=^|,|\\||\\[)",
      stringr::str_escape(k),
      "(?=\\||,|\\]|$)"
    )
    dummy <- grepl(
      search_term,
      x,
      perl = TRUE
    )
    data.table::set(x = res, j = k, value = dummy)
    # Make sure we don't miss any NAs by setting both NA and "NA" from x to NA
    # in the dummy
    data.table::set(x = res, i = which(x == "NA"), j = k, value = NA)
    data.table::set(x = res, i = which(is.na(x)), j = k, value = NA)
  }

  res
}
