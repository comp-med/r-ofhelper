testthat::test_that("dx_init creates cache if missing", {
  .dx_cache <- init_dx_cache()
  remove_dx_cache()
  rm(.dx_cache)
})
