# Simple Logging Framework for OFH TRE (DNANexus) ----

# These functions were generated from ChatGPT due to no logger being available
# on OFH

simple_log_config <- function(
    level = "INFO",
    file  = NULL,
    json  = FALSE
) {
  levels <- c("TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL")
  level <- toupper(level)
  rlang::arg_match(level, levels)

  if (!is.null(file)) {
    fs::dir_create(fs::path_dir(file))
  }

  options(
    simple_log.level = level,
    simple_log.file  = file,
    simple_log.json  = json
  )

  invisible(TRUE)
}

simple_log <- function(
    level,
    message,
    ...,
    context = list()
) {
  level <- toupper(level)

  levels <- c(
    TRACE = 1,
    DEBUG = 2,
    INFO  = 3,
    WARN  = 4,
    ERROR = 5,
    FATAL = 6
  )

  rlang::arg_match(level, names(levels))

  threshold <- getOption("simple_log.level", "INFO")
  if (levels[[level]] < levels[[threshold]]) {
    return(invisible(FALSE))
  }

  entry <- list(
    timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
    level     = level,
    message   = glue::glue(message, ...),
    context   = context
  )

  emit_log(entry)
  invisible(TRUE)
}

emit_log <- function(entry) {
  file <- getOption("simple_log.file")
  json <- isTRUE(getOption("simple_log.json"))

  if (json) {
    line <- jsonlite::toJSON(entry, auto_unbox = TRUE, null = "null")
  } else {
    ctx <- purrr::imap_chr(
      entry$context,
      ~ glue::glue("{.y}={.x}")
    )
    ctx <- if (length(ctx)) paste(ctx, collapse = " ") else NULL

    line <- glue::glue(
      "[{entry$timestamp}] {entry$level} | {entry$message}",
      if (!is.null(ctx)) glue::glue(" | {ctx}") else ""
    )
  }

  if (is.null(file)) {
    emit_console(entry$level, line)
  } else {
    write(line, file = file, append = TRUE)
  }
}

emit_console <- function(level, line) {
  if (!interactive()) {
    cat(line, "\n")
    return(invisible())
  }

  styles <- list(
    TRACE = cli::col_grey,
    DEBUG = cli::col_blue,
    INFO  = identity,
    WARN  = cli::col_yellow,
    ERROR = cli::col_red,
    FATAL = function(x) cli::style_bold(cli::col_red(x))
  )

  cat(styles[[level]](line), "\n")
}

log_trace <- function(...) simple_log("TRACE", ...)
log_debug <- function(...) simple_log("DEBUG", ...)
log_info  <- function(...) simple_log("INFO",  ...)
log_warn  <- function(...) simple_log("WARN",  ...)
log_error <- function(...) simple_log("ERROR", ...)
log_fatal <- function(...) simple_log("FATAL", ...)
