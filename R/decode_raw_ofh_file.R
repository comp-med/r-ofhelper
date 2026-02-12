#' Decode Raw OFH Data File
#'
#' Decodes a raw Our Future Health (OFH) data file by applying codings from
#' a data dictionary and codings table to convert coded values into meaningful
#' labels and correct data types.
#'
#' This function reads a raw OFH data file, applies appropriate decoding to
#' all coded columns according to the provided data dictionary and codings table,
#' and returns the decoded data table with proper data types.
#'
#' @param file_path Character string specifying the path to the raw OFH data file
#'   to be decoded
#' @param data_dictionary data.table containing data dictionary information
#'   with columns: name, type, coding_name, is_multi_select
#' @param codings_table data.table containing codings information with columns:
#'   coding_name, code, meaning
#' @param skip_codings Character string or NULL. Regular expression pattern to
#'   identify codings that should be skipped (not decoded). Columns matching the
#'   pattern will be excluded from decoding.
#' @param verbose Logical. If TRUE (default), prints progress messages during
#'   decoding process.
#'
#' @return data.table with decoded data and corrected data types. Returns the
#'   original raw data unchanged if no columns need decoding.
#' @export
#'
#' @examples
#' \dontrun{
#' # Decode a raw OFH file using data dictionary and codings
#' # decoded_data <- decode_raw_ofh_file(
#' #   file_path = "raw_data.csv",
#' #   data_dictionary = my_data_dict,
#' #   codings_table = my_codings,
#' #   skip_codings = "ICD|SNOMED"
#' # )
#' }
#'
#' @seealso \code{\link{decode_ofh_variable}} for the core decoding logic
#' \code{\link{correct_column_type}} for data type correction
decode_raw_ofh_file <- function(
    file_path,
    data_dictionary,
    codings_table,
    skip_codings = NULL,
    verbose = TRUE
) {
  # INPUT VALIDATION ----
  # Check file exists
  if (!file.exists(file_path)) {
    rlang::abort(glue::glue("File does not exist: {file_path}"))
  }
  
  # Check that data_dictionary is a data.table
  if (!data.table::is.data.table(data_dictionary)) {
    rlang::abort("data_dictionary must be a data.table")
  }
  
  # Check that codings_table is a data.table
  if (!data.table::is.data.table(codings_table)) {
    rlang::abort("codings_table must be a data.table")
  }
  
  # Check required columns in data_dictionary
  required_dd_cols <- c("name", "type", "coding_name", "is_multi_select")
  if (!all(required_dd_cols %in% names(data_dictionary))) {
    missing_cols <- required_dd_cols[!required_dd_cols %in% names(data_dictionary)]
    rlang::abort(glue::glue(
      "data_dictionary missing required columns: {paste(missing_cols, collapse = ', ')}"
    ))
  }
  
  # Check required columns in codings_table
  required_ct_cols <- c("coding_name", "code", "meaning")
  if (!all(required_ct_cols %in% names(codings_table))) {
    missing_cols <- required_ct_cols[!required_ct_cols %in% names(codings_table)]
    rlang::abort(glue::glue(
      "codings_table missing required columns: {paste(missing_cols, collapse = ', ')}"
    ))
  }
  
  # READ DATA ----
  if (verbose) rlang::inform(glue::glue("Decoding file: {file_path}"))
  raw_data <- data.table::fread(file_path, integer64 = "character", na.strings = "")
  if (verbose) rlang::inform(glue::glue("Finished reading file"))

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
    if (verbose) rlang::inform("No columns to decode, returning raw file")
    return(raw_data)
  }

  data_dictionary[ , index := .I]
  n_columns <- nrow(data_dictionary)
  if (verbose) rlang::inform(glue::glue("Decoding n={n_columns} columns in file"))

  # FILTER CODINGS TABLE ----
  codings_table <- codings_table[coding_name %in% data_dictionary$coding_name]

  # RECODE COLUMNS ----
  coded_cols <- tolower(data_dictionary$name)

  if (verbose) rlang::inform(glue::glue("Starting decoding"))
  for (i in data_dictionary$index) {
    # i <- 1
    variable_name <- data_dictionary[index == (i), tolower(name)]
    if (verbose) rlang::inform(glue::glue("Decoding column: {variable_name}"))
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
    data.table::set(raw_data, j = variable_name, value = recoded_variable)
    if (verbose) rlang::inform(glue::glue("Finished decoding column: {variable_name}"))

  }

  if (verbose) rlang::inform(glue::glue("Finished decoding file: {file_path}"))
  return(raw_data)
}
