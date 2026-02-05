# Simulate simple variable: c(1,2,3,4)
create_single_select_vec <- function(
  vec_length,
  sample_from
) {
  sample(
    sample_from,
    size = vec_length,
    replace = TRUE
  )
}

# Simulate variable with multiple selections per row: c([1,2,3], [1], [1,2])
create_multi_select_vec <- function(
  vec_length,
  sample_from,
  max_answers = 10,
  fraction_missing = 0.1
) {
  vec_length <- vec_length / max_answers
  ten_lists <- vector(mode = "list", vec_length)
  for (j in seq_len(vec_length)) {
    ten_vals <- vector(mode = "character", max_answers)
    for (i in seq_len(max_answers)) {
      ten_vals[i] <- paste(
        sample(sample_from, i, replace = TRUE),
        collapse = ","
      )
    }
    ten_lists[[j]] <- ten_vals
    rm(ten_vals)
  }
  multi_var <- unlist(ten_lists)
  multi_var <- glue::glue("[{multi_var}]")
  multi_var[sample(seq_along(multi_var), vec_length * fraction_missing)] <- "NA"
  multi_var
}
