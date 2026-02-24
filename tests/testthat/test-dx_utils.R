testthat::test_that("dx_init creates cache if missing", {
  testthat::local_mocked_bindings({
    # ...
  })

  dx_init(
    dx_binary = "mock-dx",
    dx_token = "token-123",
    check_connectivity = FALSE,
    dx_project = "proj-123"
  )
  dx_get_env()
})
