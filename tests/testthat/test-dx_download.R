test_that("dx_download function exists and is properly exported", {
  skip_on_cran()

  # Test that function exists and can be called
  expect_true(exists("dx_download"))
  expect_type(dx_download, "closure")
})
