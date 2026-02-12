decode_multi_select <- function(x, code, meaning) {

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
