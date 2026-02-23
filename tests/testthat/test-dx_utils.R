testthat::test_that("dx_init creates cache if missing", {
  if (exists(.dx_cache)) {
    rm(.dx_cache)
  }
})
