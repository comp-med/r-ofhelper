#' Export Entities from DNAnexus
#'
#' Submits table-exporter jobs to export OFH data entities from the DNAnexus project.
#' This function exports multiple entities in parallel using the DNAnexus table-exporter
#' app with customizable parameters.
#'
#' @param dataset_or_cohort_or_dashboard Character string specifying the dataset,
#'   cohort, or dashboard to export data from
#' @param output_prefix Character string specifying the prefix for output files
#' @param output_format Character string specifying the output format (default "CSV")
#' @param coding_option Character string specifying the coding option (default "RAW")
#' @param header_style Character string specifying the header style (default "FIELD-NAME")
#' @param priority Character string specifying job priority ("low", "normal", "high")
#'   (default "low")
#' @param instance_type Character string specifying the DNAnexus instance type
#'   (default "azure:mem2_ssd1_v2_x4")
#' @param project_id Character string specifying the DNAnexus project ID
#' @param work_dir Character string specifying the working directory in
#'   DNAnexus, defaults to project root
#' @param entities Character vector of entity names to export. If NULL
#'   (default), tries exports all possible OFH entities - entities not available
#'   will result in a failed job.
#'
#' @return NULL (side effect: submits DNAnexus jobs)
#' @export
#'
#' @examples
#' \dontrun{
#' # Export all standard entities
#' # export_entities(
#' #   dataset_or_cohort_or_dashboard = "project-XXXXX:/my_dataset",
#' #   project_id = "project-XXXXX",
#' #   work_dir = "/exports"
#' # )
#' }
export_entities <- function(
  dataset_or_cohort_or_dashboard = NULL,
  output_prefix = "ofh_raw_phenotype_data",
  output_format = "CSV",
  coding_option = "RAW",
  header_style = "FIELD-NAME",
  priority = "low",
  instance_type = "azure:mem2_ssd1_v2_x4",
  project_id = NULL,
  work_dir = "/",
  entities = NULL
) {
  # Validate DNAnexus initialization
  dx_is_initialized()

  # Get project ID from cache if not provided
  if (is.null(project_id)) {
    project_id <- get_dx_cache("dx_project_id")
  }

  # If no dataset path provided, try to get it from cache
  if (is.null(dataset_or_cohort_or_dashboard)) {
    dataset_or_cohort_or_dashboard <- get_dx_cache("dx_path")
  }

  # Validate required parameters
  if (is.null(dataset_or_cohort_or_dashboard)) {
    rlang::abort("dataset_or_cohort_or_dashboard must be provided")
  }

  if (is.null(project_id)) {
    rlang::abort("project_id must be provided or set in dx cache")
  }

  # Define default entities if none provided
  if (is.null(entities)) {
    all_entities <- c(
      "participant",
      "questionnaire",
      "clinic_measurements",
      "nhse_eng_canpat",
      "nhse_eng_canreg_pattumour",
      "nhse_eng_canreg_treat",
      "nhse_eng_ecds",
      "nhse_eng_ed",
      "nhse_eng_inpat",
      "nhse_eng_outpat",
      "nhse_eng_primcare_meds",
      "nhse_engwal_deaths",
      "participant_nhs_linked",
      "country_region",
      "msoa",
      "lsoa",
      "intermediate_zones",
      "sample_qc_metrics",
      "snv_pvcf"
    )
  } else {
    all_entities <- entities
  }

  # Construct destination path
  destination <- paste(project_id, work_dir, sep = ":")

  # Submit jobs for each entity
  for (entity in all_entities) {
    output_file_name <- paste(output_prefix, entity, sep = "_")
    job_name <- paste0("export_main_data_entity_", entity)

    # Build dx run arguments
    dx_args <- c(
      "run",
      "table-exporter",
      glue::glue(
        "-idataset_or_cohort_or_dashboard='{dataset_or_cohort_or_dashboard}'"
      ),
      glue::glue("-ioutput='{output_file_name}'"),
      glue::glue("-ioutput_format='{output_format}'"),
      glue::glue("-icoding_option='{coding_option}'"),
      glue::glue("-iheader_style='{header_style}'"),
      glue::glue("-ientity='{entity}'"),
      "--priority",
      shQuote(priority),
      "--destination",
      destination,
      "--name",
      job_name,
      "--instance-type",
      shQuote(instance_type),
      "--brief",
      "--yes"
    )

    # Submit the job
    message(glue::glue("Submitting export job for entity: {entity}"))
    dx_run_cmd(dx_args)
  }

  message("All export jobs submitted successfully")
}
