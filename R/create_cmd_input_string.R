create_cmd_input_string <- function(
    file,
    include_ofhelper = TRUE
) {

  if (!file.exists(file)) {
    stop("File does not exist!")
  }

  script_content <- readr::read_file(script_location)

  if (include_ofhelper) {

    pkgs_installed <- installed.packages()[,1]
    ofhelpers_installed <- "ofhelper" %in% pkgs_installed

    if (!ofhelpers_installed) {
      stop("`ofhelper` package must be installed to be included")
    }

    pkg_base <- find.package("ofhelper")
    ofhelper_scripts <- fs::dir_ls(fs::path(pkg_base, "R"))
    ofhelper_script_content <- lapply(ofhelper_scripts, readr::read_file)
    ofhelper_script_content <- Reduce(\(x, y) {
      paste(x, y, collapse = "\n")
    }, ofhelper_script_content)
  }
  script_content
}
