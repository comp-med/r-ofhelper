#' Launch a DNAnexus Workstation Session
#'
#' Launch a Jupyter workstation session on DNAnexus with specified parameters.
#'
#' @param priority Character string specifying the job priority. Must be one of
#'   "low", "normal", or "high". Default is "normal".
#' @param session_name Character string specifying the name of the workstation
#'   session. Default is "jupyter_workstation".
#' @param session_length_minutes Numeric specifying the session duration in minutes.
#'   Default is 180 (3 hours).
#' @param instance_type Character string specifying the DNAnexus instance type.
#'   Must be a valid instance type from the TRE rate card. Default is
#'   "azure:mem1_ssd2_v2_x2".
#'
#' @return Character string with the job ID of the launched workstation session
#' @export
#'
#' @examples
#' # Launch a workstation with default settings
#' # job_id <- dx_launch_workstation()
#'
#' # Launch a workstation with custom settings
#' # job_id <- dx_launch_workstation(
#' #   priority = "high",
#' #   session_name = "my_analysis_session",
#' #   session_length_minutes = 300,
#' #   instance_type = "azure:mem2_ssd1_v2_x4"
#' # )
dx_launch_workstation <- function(
  priority = "normal",
  session_name = "jupyter_workstation",
  session_length_minutes = 180,
  instance_type = "azure:mem1_ssd2_v2_x2"
) {
  dx_is_initialized()

  # Validate priority
  valid_priorities <- c("low", "normal", "high")
  if (!(priority %in% valid_priorities)) {
    rlang::abort(glue::glue(
      "Invalid priority. Must be one of: {paste(valid_priorities, collapse = ', ')}"
    ))
  }

  # Validate instance type against TRE rate card
  # TODO This is currently restricted to azure instances of Our Future Health
  rate_card <- tre_rate_card()
  valid_instance_types <- rate_card$dnanexus_instance_type
  if (!(instance_type %in% valid_instance_types)) {
    rlang::abort(glue::glue(
      "Invalid instance type. Check `tre_rate_card() for valid instances.`"
    ))
  }

  # Hard-coded app_id since it will not change
  app_id <- "app-J3BZ4xQ0ZGP6kqbXB9G89BFz"

  # Build the command arguments
  app_args <- c(
    "run",
    app_id,
    glue::glue("-iduration={session_length_minutes}"),
    "--brief",
    "-y",
    "--name",
    session_name,
    "--priority",
    priority,
    "--instance-type",
    instance_type
  )

  # Execute the dx run command
  result <- dx_run_cmd(app_args)

  # parse job ID
  job_id_regex <- "^job-[a-zA-Z0-9]{24}$"
  result <- grep(job_id_regex, result, value = TRUE)

  # Return the job ID (first line of output)
  if (length(result) > 0) {
    return(result[1])
  } else {
    rlang::abort("Failed to launch workstation - no job ID returned")
  }
}

#' Get Workstation Worker URL
#'
#' Retrieve the worker URL for a running DNAnexus workstation session.
#'
#' @param job_id Character string with the job ID of the workstation session
#'
#' @return Character string with the worker URL for the workstation session
#' @export
#'
#' @examples
#' # Get URL for a specific job
#' # url <- get_workstation_worker_url("job-1234567890abcdef12345678")
get_workstation_worker_url <- function(job_id) {
  dx_is_initialized()

  # Get job information in JSON format
  job_info <- tryCatch(
    {
      dx_run_cmd("find", "jobs", "--id", job_id, "--json")
    },
    error = function(e) {
      rlang::abort(glue::glue(
        "Failed to retrieve job information for job {job_id}: {e$message}"
      ))
    }
  )

  # remove the header about proxy variables
  proxy_msg <- "^Using env variable HTTPS_PROXY"
  job_info <- job_info[!grepl(proxy_msg, job_info)]

  # Parse the JSON
  job_data <- tryCatch(
    {
      jsonlite::fromJSON(job_info)
    },
    error = function(e) {
      rlang::abort(glue::glue(
        "Failed to parse JSON from job {job_id}: {e$message}"
      ))
    }
  )

  # Extract and return the worker URL from httpsApp.dns.url
  if (
    "httpsApp" %in%
      names(job_data) &&
      "dns" %in% names(job_data$httpsApp) &&
      "url" %in% names(job_data$httpsApp$dns)
  ) {
    return(job_data$httpsApp$dns$url)
  } else {
    rlang::abort(glue::glue(
      "Could not find worker URL in job information for job {job_id}"
    ))
  }
}
