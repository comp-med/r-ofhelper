testthat::test_that("dx_init creates cache if missing", {
  testthat::local_mocked_bindings(
    dx_check_connection = function() TRUE,
    dx_set_binary = function(...) TRUE,
    dx_auth = function(...) TRUE,
    dx_set_project = function(...) TRUE,
    dx_set_path = function(...) TRUE,
    dx_set_env = function(...) TRUE
  )

  suppressMessages(
    dx_init(
      dx_binary = "mock-dx",
      dx_token = "token-123",
      check_connectivity = FALSE,
      dx_project = "proj-123"
    )
  )
  testthat::expect_snapshot(get_dx_cache())
})
