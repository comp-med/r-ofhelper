get_meta_data <- function(
  project_id = NULL,
  record_id
) {
  dx_binary <- get_dx_cache("dx_binary")
  project_id <- project_id %||% get_dx_cache("dx_project_id")

  dataset_path = paste(project_id, record_id, sep = ":")
  cmd <- paste("dx extract_dataset", dataset_path, "-ddd --delimiter ','")
  system(cmd, intern = TRUE)

  codings_file <- fs::dir_ls(glob = "*.codings.csv")[1]
  data_dict_file <- fs::dir_ls(glob = "*.data_dictionary.csv")[1]
  entity_dict_file <- fs::dir_ls(glob = "*.entity_dictionary.csv")[1]

  list(
    "data_dictionary" = data_dict_file,
    "data_codings" = codings_file,
    "entity_dictionary" = entity_dict_file
  )
}
