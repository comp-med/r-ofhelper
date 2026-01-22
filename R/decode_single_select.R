
decode_single_select <- function(variable, code, meaning) {
  stopifnot(length(code) == length(meaning))
  stopifnot(!anyDuplicated(code))

  idx <- match(variable, code)
  out <- meaning[idx]

  # preserve original values if unmapped by only replacing mapped values
  out[is.na(idx)] <- variable[is.na(idx)]
  out
}
