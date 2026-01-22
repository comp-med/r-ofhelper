
dx_set_wd <- function() {
  # TODO
  # set wd for dx file upload etc.
}

dx_ls <- function() {
  # TODO
  # current dir by default, otherwise, what was entered
}

dx_extract_metadata <- function() {
  # TODO
  # return the dd, codings and entity objectsa
}

dx_launch_workstation <- function() {
  # TODO
}

get_workstation_worker_url <- function() {
  # TODO
  # this creates a ton of json that contains httpsApp.dns.url with the worker url
  # dx find jobs --id job-J5jvbJV2yZ8jBKvVvPy8Yg5p --json
  # maybe util with parse_job_json() or similar
}

dx_upload <- function(
    files, # glob or vector?
    target_dir,
    overwrite_old_files = TRUE # i.e. delete old ones
) {
  # TODO
  #  remove files with the same name?
  # directory
  # files...
}

remount_project <- function() {
  system("umount /mnt")
  system("mkdir -p /mnt")
  system("/home/dnanexus/dxfuse -readOnly /mnt /home/dnanexus/.dxfuse_manifest.json")
}

create_single_select_vec <- function(
    vec_length,
    sample_from
) {
  sample(
    sample_from,
    size = vec_length,
    replace = TRUE
  )
}

create_multi_select_vec <- function(
    vec_length,
    sample_from
) {

  vec_length <- vec_length / 10
  ten_lists <- vector(mode = "list", vec_length)
  for (j in seq_len(vec_length) ) {
    ten_vals <- vector(mode = "character", 10)
    for (i in 1:10) {
      ten_vals[i] <- paste(
        sample(sample_from, i, replace = TRUE),
        collapse = ","
      )
    }
    ten_lists[[j]] <- ten_vals
    rm(ten_vals)
  }
  multi_var <- unlist(ten_lists)
  multi_var <- glue("[{multi_var}]")
  multi_var[sample(seq_along(multi_var), vec_length/100)] <- NA
  multi_var
}
