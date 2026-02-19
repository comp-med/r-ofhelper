test_that("find_tre_instance_type function exists and is properly exported", {
  # Test that function exists and can be called
  expect_true(exists("find_tre_instance_type"))
  expect_type(find_tre_instance_type, "closure")
})

test_that("find_tre_instance_type handles parameters correctly", {
  # Test that function accepts the expected parameters
  expect_true(exists("find_tre_instance_type"))

  # Check function formals
  fun_formals <- formals(find_tre_instance_type)
  expect_true("required_n_cpus" %in% names(fun_formals))
  expect_true("required_gb_ram" %in% names(fun_formals))
  expect_true("required_gb_disk_storage" %in% names(fun_formals))
  expect_true("return_all_matching" %in% names(fun_formals))
})
