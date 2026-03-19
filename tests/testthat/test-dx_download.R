test_that("dx_download function exists and is properly exported", {
  skip_on_cran()

  # Test that function exists and can be called
  expect_true(exists("dx_download"))
  expect_type(dx_download, "closure")
})

test_that("dx_download tries to extract gzipped files", {
  local_mocked_bindings(
    dx_is_initialized = function() invisible(TRUE),
    dx_run_cmd = function(args, dx_stdout, dx_stderr, fail_on_dx_error) 0,
    decompress_gzip = function(files) {
      fs::file_move(files, fs::path_ext_remove(files))
      invisible(TRUE)
    }
  )

  tmpfile <- withr::local_tempfile(pattern = "tmpfile_", fileext = ".csv.gz")
  decompressed_tmpfile <- fs::path_ext_remove(tmpfile)
  fs::file_create(tmpfile)
  dx_download(
    files = tmpfile,
    unzip_files = TRUE,
    local_dir = fs::path_dir(tmpfile)
  )
  expect_true(fs::file_exists(decompressed_tmpfile))
})
