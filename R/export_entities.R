export_entities <- function() {

  # TODO
  # based on this!
  # dataset_or_cohort_or_dashboard <- dataset_path
  # output_prefix <- "ofh_raw_phenotype_data"
  # output_format  <- "CSV"
  # coding_option <- "RAW"
  # header_style <- "FIELD-NAME"
  # priority <- "low"
  # instance_type <- "azure:mem2_ssd1_v2_x4"
  # project_id <- "project-J4FYxBV2yZ8z9gXb4Qv9xyZq"
  # work_dir <- "/00_people/Carl/01_ofh_data_overview/raw"
  # destination <- paste(project_id, work_dir, sep = ":")
  #
  # all_entities <- entities$entity

  # for (entity in all_entities) {
  #
  #   output_file_name <- paste(output_prefix, entity, sep = "_")
  #   job_name <- paste0("export_main_data_entity_", entity)
  #   dx_args <-  c(
  #     "run",
  #     "table-exporter",
  #     glue("-idataset_or_cohort_or_dashboard='{dataset_or_cohort_or_dashboard}'"),
  #     glue("-ioutput='{output_file_name}'"),
  #     glue("-ioutput_format='{output_format}'"),
  #     glue("-icoding_option='{coding_option}'"),
  #     glue("-iheader_style='{header_style}'"),
  #     glue("-ientity='{entity}'"),
  #     "--priority",
  #     shQuote(priority),
  #     "--destination",
  #     destination,
  #     "--name",
  #     job_name,
  #     "--instance-type",
  #     shQuote(instance_type),
  #     "--brief",
  #     "--yes"
  #   )
  #   system2(
  #     dx_bin,
  #     dx_args
  #   )
  # }
}
