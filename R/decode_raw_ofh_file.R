decode_raw_ofh_file <- function(
    file_path,
    data_dictionary,
    codings_table,
    skip_codings = NULL,
    verbose = TRUE
) {

  # READ DATA ----
  if (verbose) message(glue::glue("Decoding file: {file_path}"))
  raw_data <- fread(file_path, integer64 = "character", na.strings = "")
  if (verbose) message(glue::glue("Finished reading file"))

  # FILTER DD -----
  file_cols <- toupper(names(raw_data))

  # Do not recode ID/PID!
  file_cols <- file_cols[!(file_cols %in% c("ID", "PID"))]

  data_dictionary <- data_dictionary[toupper(name) %in% file_cols, ]
  data_dictionary <- data_dictionary[
    !is.na(coding_name),
    .(name, type, coding_name, is_multi_select)
  ]

  # Remove columns that should not be recoded (e.g. ICD & SNOMED codes)
  if (!is.null(skip_codings)) {
    data_dictionary <- data_dictionary[!grepl(skip_codings, coding_name)]
  }

  if (nrow(data_dictionary) == 0) {
    if (verbose) message("No columns to decode, returning raw file")
    return(raw_data)
  }

  data_dictionary[ , index := .I]
  n_columns <- nrow(data_dictionary)
  if (verbose) message(glue::glue("Decoding n={n_columns} columns in file"))

  # FILTER CODINGS TABLE ----
  codings_table <- codings_table[coding_name %in% data_dictionary$coding_name]

  # RECODE COLUMNS ----
  coded_cols <- tolower(data_dictionary$name)

  if (verbose) message(glue::glue("Starting decoding"))
  for (i in data_dictionary$index) {
    # i <- 1
    variable_name <- data_dictionary[index == (i), tolower(name)]
    if (verbose) message(glue::glue("Decoding column: {variable_name}"))
    is_multi_select <- data_dictionary[index == (i), is_multi_select]
    variable_coding_name <- data_dictionary[index == (i), coding_name]
    variable_type <- data_dictionary[index == (i), type]
    code <- codings_table[coding_name == (variable_coding_name), code]
    meaning <- codings_table[coding_name == (variable_coding_name), meaning]

    # Main function decoding the variable!
    recoded_variable <- decode_ofh_variable(
      variable = raw_data[[variable_name]],
      is_multi_select = is_multi_select,
      code = code,
      meaning = meaning
    )

    # Correct the type of the data
    # Multi-select always stays string in the file, therefore no need to cast
    if (!is_multi_select) {
      recoded_variable <- correct_column_type(
        x = recoded_variable,
        annotated_type = variable_type
      )
    }
    set(raw_data, j = variable_name, value = recoded_variable)
    if (verbose) message(glue::glue("Finished decoding column: {variable_name}"))

  }

  if (verbose) message(glue::glue("Finished decoding file: {file_path}"))
  return(raw_data)
}
