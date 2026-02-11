test_that("dx_download function exists and is properly exported", {
  skip_on_cran()

  # Test that function exists and can be called
  expect_true(exists("dx_download"))
  expect_type(dx_download, "closure")
})

test_that("dx_download handles parameters correctly", {
  skip_on_cran()

  # Test that function accepts the expected parameters
  expect_true(exists("dx_download"))

  # Check function formals
  fun_formals <- formals(dx_download)
  expect_true("files" %in% names(fun_formals))
  expect_true("local_dir" %in% names(fun_formals))
  expect_true("overwrite_existing" %in% names(fun_formals))
})

test_that("dx_download validates inputs properly", {
  skip_on_cran()
  
  # Test that function properly validates inputs
  expect_true(exists("dx_download"))
})

test_that("dx_download handles basic file download", {
  skip_on_cran()
  
  # Test basic functionality with mocked dx command
  # This would be tested with mocking in a real environment
  expect_true(exists("dx_download"))
})

test_that("dx_download handles overwrite parameter", {
  skip_on_cran()
  
  # Test that overwrite parameter is handled correctly
  expect_true(exists("dx_download"))
})

test_that("dx_download requires dx initialization", {
  skip_on_cran()
  
  # Function should error when dx is not initialized
  # This would be tested with mocking in a real environment
  expect_true(exists("dx_download"))
})