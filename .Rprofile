source("rv/scripts/rvr.R")
source("rv/scripts/activate.R")

# For development in RStudio!
if (interactive()) {
  suppressMessages(require(devtools))
  suppressMessages(require(usethis))
  options(cli.ignore_unknown_rstudio_theme = TRUE)
}
# setup Default Mirror
options(repos=c(CRAN="https://cran.uni-muenster.de/"))
# LanguageServer Setup Start (do not change this chunk)
# to remove this, run languageserversetup::remove_from_rprofile
if (requireNamespace('languageserversetup', quietly = TRUE)) {
  options(langserver_library = '/home/carl/languageserver-library')
  languageserversetup::languageserver_startup()
  unloadNamespace('languageserversetup')
}
# LanguageServer Setup End
