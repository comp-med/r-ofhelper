test_that("dx_upload function exists and is properly exported", {
  skip_on_cran()

  # Test that function exists and can be called
  expect_true(exists("dx_upload"))
  expect_type(dx_upload, "closure")
})
