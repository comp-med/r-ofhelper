#' Submit a Swiss Army Knife DNAnexus Job
#'
#' Submits a job using the Swiss Army Knife to DNAnexus for execution. This
#' function is a wrapper to submit a single job using a list of input files and
#' a single command string to be executed with the job. Uses the function
#' [dx_run_cmd()] to submit the job.
#'
#' @param input_files Character. A character vector of all required input files,
#'   ideally with the full path in the form `project:/path/to/file`. Content
#'   will be passed to the `-iin` flag.
#' @param cmd Character. A single string of the command to be executed within the app.
#'   Content will be passed to the `-icmd` flag.
#' @param mount_inputs Logical. Default is `FALSE`. Whether to download the files into
#'   the app (if `FALSE`) or mount them within the app (if `TRUE`)
#' @param destination_project Character. The project ID of the project the result
#'   files will be saved in. If `NULL`, default to the project that `ofhelper`
#'   was initialized in.
#' @param destination_path Character. The directory of the project the result files
#'   will be saved in. If `NULL`, default to the current directory that
#'   `ofhelper` has cached.
#' @param app_id Character. App ID of the Swiss Army Knife app. If `NULL`
#'   (Default), it will use the latest version by just passing
#'   `swiss-army-knife`
#' @inheritParams dx_submit_r_job
#'
#' @return Job ID of the submitted DNAnexus job
#' @export
dx_run_swiss_army_knife <- function(
  input_files,
  cmd,
  mount_inputs = FALSE,
  destination_project = NULL,
  destination_path = NULL,
  instance_type = NULL,
  priority = "normal",
  session_name = NULL,
  tag = NULL,
  app_id = NULL
) {
  app_id <- app_id %||% "swiss-army-knife"

  # TODO - create function
  # Validate priority
  valid_priorities <- c("low", "normal", "high")
  if (!(priority %in% valid_priorities)) {
    rlang::abort(glue::glue(
      "Invalid priority. Must be one of: {paste(valid_priorities, collapse = ', ')}"
    ))
  }

  # TODO - create function
  # Set default session name if not provided
  if (is.null(session_name)) {
    session_name <- glue::glue(
      "r_job_{format(Sys.time(), '%Y-%m-%d_%H-%M-%S')}"
    )
  }

  # TODO - create function
  # Set default tag if not provided
  if (is.null(tag)) {
    tag <- format(Sys.time(), "%Y-%m-%d/%H:%M:%S")
  }

  # TODO - create function
  # Get instance type - use lowest from rate card if not specified
  if (is.null(instance_type)) {
    rate_card <- tre_rate_card()
    instance_type <- rate_card[order(n_cpus, ram_gb)][
      1,
      "dnanexus_instance_type"
    ]
  }

  # TODO - create function
  # Validate instance type against TRE rate card
  rate_card <- tre_rate_card()
  valid_instance_types <- rate_card$dnanexus_instance_type
  if (!(instance_type %in% valid_instance_types)) {
    rlang::abort(glue::glue(
      "Invalid instance type. Check `tre_rate_card() for valid instances.`"
    ))
  }

  # the destination arg sets the result output directory
  destination_project <- destination_project %||% dx_get_project()
  destination_path <- destination_path %||% dx_get_path()
  destination <- glue::glue("{destination_project}:{destination_path}")

  # Build dx run arguments
  dx_args <- c(
    "run",
    app_id,
    "--brief",
    "-y",
    "--name",
    session_name,
    "--priority",
    priority,
    "--instance-type",
    instance_type,
    "--tag",
    tag,
    "--destination",
    destination
  )

  # create `iin`
  iin_arg <- shQuote(input_files)
  iin_arg <- glue::glue("-iin={iin_arg}")

  # prepare the command to be executed via `-icmd`
  cmd <- shQuote(cmd)
  icmd_args <- glue::glue("-icmd={cmd}")

  # See whether files should be downloaded or simply mounted
  imount_inputs <- ifelse(mount_inputs, "true", "false")
  imount_inputs <- glue::glue("-imount_inputs={imount_inputs}")

  swiss_army_knife_args <- c(
    iin_arg,
    icmd_args,
    imount_inputs
  )

  args <- c(dx_args, swiss_army_knife_args)
  result <- dx_run_cmd(args, fail_on_dx_error = TRUE)$stdout

  # Parse job ID from result
  job_id_regex <- "^job-[a-zA-Z0-9]{24}$"
  job_ids <- grep(job_id_regex, result, value = TRUE)

  if (length(job_ids) > 0) {
    rlang::inform(glue::glue(
      "Job submitted successfully with ID: {job_ids[1]}"
    ))
    return(job_ids[1])
  } else {
    rlang::abort("Failed to submit job - no job ID returned")
  }
}
