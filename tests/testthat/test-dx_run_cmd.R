test_that("dx_run_cmd executes commands correctly with mocking", {
  skip_on_cran()

  # This is a mock initialization to avoid failure
  init_dx_cache()
  set_dx_cache("dx_initialized" = TRUE)
  local_mocked_bindings(
    system2 = function(
      dx_binary,
      args,
      env,
      stdout,
      stderr
    ) {
      0
    }
  )
  # Test the function
  result <- dx_run_cmd("ls")

  # Verify the result structure and content
  expect_type(result, "list")
  expect_equal(result$exit_code, 0)
})

test_that("dx_run_cmd handles command failures gracefully", {
  skip_on_cran()
  .dx_cache <- init_dx_cache()
  set_dx_cache("dx_initialized" = TRUE)

  # Mock system2 to simulate command failure
  local_mocked_bindings(
    system2 = function(binary, args, env, stdout = TRUE, stderr = TRUE) {
      # Return non-zero exit code to simulate failure
      1
    }
  )
  expect_error(
    dx_run_cmd("nonexistent-command"),
    "Call to `dx` returned exit code 1 with error message:"
  )
})

test_that("dx_run_cmd returns output correctly", {
  skip_on_cran()
  .dx_cache <- init_dx_cache()
  set_dx_cache("dx_initialized" = TRUE)

  # Mock system2 to simulate command failure
  local_mocked_bindings(
    system2 = function(
      dx_binary,
      args,
      env,
      stdout,
      stderr
    ) {
      0
    },
    readLines = mock_output_sequence(
      c(".dummy", "stdout", "content"),
      c(".dummy", "stderr", "content"),
    )
  )
  res <- dx_run_cmd("ls", dx_stdout = TRUE, dx_stderr = TRUE)
  expect_type(res, "list")
  expect_snapshot(res)
})

test_that("dx_run_cmd returns errors correctly if set", {
  skip_on_cran()
  .dx_cache <- init_dx_cache()
  set_dx_cache("dx_initialized" = TRUE)

  # Mock system2 to simulate command failure
  local_mocked_bindings(
    system2 = function(
      dx_binary,
      args,
      env,
      stdout,
      stderr
    ) {
      1
    },
    readLines = mock_output_sequence(
      ".dummy",
      c(".dummy", "some", "error", "output"),
    )
  )
  res <- dx_run_cmd(
    "nonexistent-command",
    dx_stdout = TRUE,
    dx_stderr = TRUE,
    fail_on_dx_error = FALSE
  )
  expect_type(res, "list")
  expect_snapshot(res)
  expect_equal(res$exit_code, 1)
})
