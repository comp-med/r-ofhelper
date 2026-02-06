# I can create a column for each entry in a multi-select questionnaire column

explode_multi_select <- function(
  x,
  long_format = FALSE,
  na_is_none_of_the_above = TRUE
) {
  unique_entries <- unique(x)
  unique_entries <- gsub('\\[|\\]|\\"', "", unique_entries)
  unique_entries <- strsplit(unique_entries, ",|\\|")
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
    dummy <- grepl(
      paste0("(?<=^|,|\\||\\[)", k, "(?=\\||,|\\]|$)"),
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
