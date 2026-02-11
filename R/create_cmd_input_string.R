create_cmd_input_string <- function(
  file,
  include_ofhelper = TRUE
) {
  if (!file.exists(file)) {
    stop("File does not exist!")
  }

  script_content <- readr::read_file(file)

  if (include_ofhelper) {
    ofhelper_script_content <- create_ofhelper_string()
    script_content <- script_contentglue::glue(
      "{ofhelper_script_content}\n{script_content}"
    )
  }
  script_content
}
