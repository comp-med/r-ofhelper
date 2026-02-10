test_that("explode_multi_select works with basic comma-separated values", {
  # Test basic functionality
  x <- c("A,B", "B,C", "A,C", "A|B|C")
  result <- explode_multi_select(x)
  
  # Should return data.table with correct structure
  expect_s3_class(result, "data.table")
  expect_equal(nrow(result), 4)
  expect_true("A" %in% names(result))
  expect_true("B" %in% names(result))
  expect_true("C" %in% names(result))
})

test_that("explode_multi_select handles long format correctly", {
  x <- c("A,B", "B,C")
  result <- explode_multi_select(x, long_format = TRUE)
  
  # Should return long format with 3 columns plus index/original
  expect_s3_class(result, "data.table")
  expect_equal(ncol(result), 4)  # index, original, variable, value
})

test_that("explode_multi_select handles NA values appropriately", {
  x <- c("A,B", "NA", "B,C")
  result <- explode_multi_select(x)
  
  # Should handle NA values properly
  expect_s3_class(result, "data.table")
  expect_equal(nrow(result), 3)
})

test_that("explode_multi_select works with custom separators", {
  x <- c("A;B", "B;C")
  result <- explode_multi_select(x, answer_separators = ";")
  
  # Should work with semicolon separator
  expect_s3_class(result, "data.table")
  expect_true("A" %in% names(result))
  expect_true("B" %in% names(result))
  expect_true("C" %in% names(result))
})