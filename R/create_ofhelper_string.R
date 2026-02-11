create_ofhelper_string <- function() {
  pkgs_installed <- installed.packages()[, 1]
  ofhelpers_installed <- "ofhelper" %in% pkgs_installed

  if (!ofhelpers_installed) {
    stop("`ofhelper` package must be installed to be included")
  }

  pkg_base <- find.package("ofhelper")
  ofhelper_scripts <- fs::dir_ls(fs::path(pkg_base, "R"))
  ofhelper_script_content <- lapply(ofhelper_scripts, readr::read_file)
  ofhelper_script_content <- Reduce(
    \(x, y) {
      glue::glue("{x}\n\n{y}")
    },
    ofhelper_script_content
  )
  ofhelper_script_content
}
