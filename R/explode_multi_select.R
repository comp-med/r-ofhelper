#' Title
#'
#' @param x Character vector. Contains the variable for each OFH participant. Each element may contain different answers, separated by either `|` or `,`
#' @param answer_separators Character vector. Which separator to look for when splitting individual elements into substrings
#' @param long_format
#' @param na_is_none_of_the_above
#'
#' @returns
#' @export
#'
#' @examples
explode_multi_select <- function(
  x,
  answer_separators = c(",", "|"),
  long_format = FALSE,
  na_is_none_of_the_above = TRUE
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

    if (!na_is_none_of_the_above) {
      data.table::set(x = res, i = which(x == "NA"), j = k, value = NA)
      data.table::set(x = res, i = which(is.na(x)), j = k, value = NA)
    }
  }
  if (long_format) {
    res <- data.table::melt.data.table(res, id.vars = c("index", "original"))
  }

  res
}
