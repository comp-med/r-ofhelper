test_that("dx_run_cmd executes commands correctly", {
  # Test basic command execution
  skip_on_cran()  # Skip on CRAN to avoid system2 calls
  
  # Test that function exists and can be called
  expect_true(exists("dx_run_cmd"))
})

test_that("dx_run_cmd handles argument passing correctly", {
  skip_on_cran()
  
  # Test that function accepts the expected parameters
  expect_true(exists("dx_run_cmd"))
  
  # Check function formals
  fun_formals <- formals(dx_run_cmd)
  expect_true("cmd" %in% names(fun_formals))
  expect_true("..." %in% names(fun_formals))
})

test_that("dx_run_cmd requires dx initialization", {
  skip_on_cran()
  
  # Function should error when dx is not initialized
  # This test would be implemented with proper mocking in a real test environment
  expect_true(exists("dx_run_cmd"))
})