#' Find Suitable DNAnexus Instance Type
#'
#' Find the most suitable DNAnexus instance type based on resource requirements.
#' This function queries the TRE rate card and returns the best matching instance type.
#'
#' @param required_n_cpus Numeric. Minimum number of CPU cores required.
#' @param required_gb_ram Numeric. Minimum RAM in gigabytes required.
#' @param required_gb_disk_storage Numeric. Minimum disk storage in gigabytes required.
#' @param return_all_matching Logical. If TRUE, returns all matching instance types.
#'   If FALSE (default), returns only the closest matching instance.
#'
#' @return Character string with DNAnexus instance type identifier when
#'   \code{return_all_matching = FALSE}, or data.table with all matching instances
#'   when \code{return_all_matching = TRUE}.
#' @export
#'
#' @examples
#' \dontrun{
#' # Find instance with at least 8 CPUs, 12GB RAM, and 125GB disk
#' # find_tre_instance_type(8, 12, 125)
#'
#' # Find all instances that meet requirements
#' # find_tre_instance_type(8, 12, 125, return_all_matching = TRUE)
#' }
find_tre_instance_type <- function(
  required_n_cpus,
  required_gb_ram,
  required_gb_disk_storage,
  return_all_matching = FALSE
) {
  rate_card <- tre_rate_card()
  rate_card <- rate_card[
    n_cpus >= required_n_cpus &
      ram_gb >= required_gb_ram &
      disk_storage_gb >= required_gb_disk_storage,
  ]

  if (nrow(rate_card) == 0) {
    rlang::abort("No instance type found matching specifications")
  }

  if (return_all_matching) {
    return(rate_card)
  }

  data.table::setkey(
    rate_card,
    "n_cpus",
    "ram_gb",
    "disk_storage_gb",
    "spot_rate_gpb_per_h"
  )
  closest_instance <- unlist(
    rate_card[
      1,
      .(
        dnanexus_instance_type,
        n_cpus,
        ram_gb,
        disk_storage_gb,
        on_demand_rate_gpb_per_h
      )
    ]
  )

  instance_properties <- paste(
    names(closest_instance),
    closest_instance,
    sep = " = ",
    collapse = " | "
  )
  message(glue::glue("Instance properties: {instance_properties}"))
  closest_instance[["dnanexus_instance_type"]]
}
