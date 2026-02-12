#' Submit R Script as DNAnexus Job
#'
#' Submits a custom R script as a job to DNAnexus for execution. This function
#' prepares and executes R scripts in the DNAnexus environment using the Jupyter
#' workstation app.
#'
#' @param script_path Character string specifying the path to the R script to be executed
#' @param instance_type Character string specifying the DNAnexus instance type.
#'   If NULL (default), uses the lowest instance from the rate card.
#' @param priority Character string specifying job priority ("low", "normal", "high").
#'   Default is "normal".
#' @param session_name Character string specifying the job name. Default is
#'   'r_job_<timestamp>'.
#' @param tag Character string for tagging the job. Default uses timestamp.
#' @param include_ofhelper Logical. If TRUE (default), includes the complete
#'   ofhelper package source code to ensure all required functions are available.
#' @param remote_inputs Character vector of DNAnexus file paths to be downloaded
#'   into the worker. Default is NULL.
#'
#' @return Job ID of the submitted DNAnexus job
#' @export
#'
#' @examples
#' \dontrun{
#' # Submit an R script with default settings
#' # job_id <- submit_r_job("path/to/my_script.R")
#'
#' # Submit with custom parameters
#' # job_id <- submit_r_job(
#' #   script_path = "analysis.R",
#' #   instance_type = "azure:mem2_ssd1_v2_x4",
#' #   priority = "high",
#' #   session_name = "my_analysis_job"
#' # )
#'
#' # Submit with remote input files
#' # job_id <- submit_r_job(
#' #   script_path = "analysis.R",
#' #   remote_inputs = c("file-xxxxx", "file-yyyyy")
#' # )
#' }
dx_submit_r_job <- function(
  script_path,
  instance_type = NULL,
  priority = "normal",
  session_name = NULL,
  tag = NULL,
  include_ofhelper = TRUE,
  remote_inputs = NULL
) {
  # Validate DNAnexus initialization
  dx_is_initialized()

  # Validate script exists
  if (!file.exists(script_path)) {
    rlang::abort(glue::glue("Script file does not exist: {script_path}"))
  }

  # Validate priority
  valid_priorities <- c("low", "normal", "high")
  if (!(priority %in% valid_priorities)) {
    rlang::abort(glue::glue(
      "Invalid priority. Must be one of: {paste(valid_priorities, collapse = ', ')}"
    ))
  }

  # Set default session name if not provided
  if (is.null(session_name)) {
    session_name <- glue::glue(
      "r_job_{format(Sys.time(), '%Y-%m-%d_%H-%M-%S')}"
    )
  }

  # Set default tag if not provided
  if (is.null(tag)) {
    tag <- format(Sys.time(), "%Y-%m-%d/%H:%M:%S")
  }

  # Get instance type - use lowest from rate card if not specified
  if (is.null(instance_type)) {
    rate_card <- tre_rate_card()
    instance_type <- rate_card[order(n_cpus, ram_gb)][
      1,
      "dnanexus_instance_type"
    ]
  }

  # Validate instance type against TRE rate card
  rate_card <- tre_rate_card()
  valid_instance_types <- rate_card$dnanexus_instance_type
  if (!(instance_type %in% valid_instance_types)) {
    rlang::abort(glue::glue(
      "Invalid instance type. Check `tre_rate_card() for valid instances.`"
    ))
  }

  script_content <- create_cmd_input_string(script_path, include_ofhelper)

  # Create execution command
  script_cmd <- glue::glue(
    "echo {shQuote(script_content, type = 'csh')} | Rscript - "
  )

  # Build dx run arguments
  app_args <- c(
    "run",
    "app-J3BZ4xQ0ZGP6kqbXB9G89BFz", # Jupyter workstation app ID
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
    glue::glue("-icmd={shQuote(script_cmd)}")
  )

  # Add remote input files if provided
  if (!is.null(remote_inputs)) {
    for (file in remote_inputs) {
      if (!dx_file_exists(file)) {
        rlang::abort(glue::glue("Input file does not exist: {file}"))
      }
      app_args <- c(app_args, glue::glue("-iin={shQuote(file)}"))
    }
  }

  # Submit the job
  rlang::inform(glue::glue("Submitting R job: {session_name}"))
  result <- dx_run_cmd(app_args)

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
