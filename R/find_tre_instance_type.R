find_tre_instance_type <- function(
    required_n_cpus,
    required_gb_ram,
    required_gb_disk_storage,
    return_all_matching = FALSE # return closest fit if else
) {

  # required_n_cpus = 8; required_gb_ram = 12; required_gb_disk_storage = 125; return_all_matching = FALSE
  rate_card <- tre_rate_card()
  rate_card <- rate_card[
    n_cpus >= required_n_cpus &
      ram_gb >= required_gb_ram &
      disk_storage_gb >= required_gb_disk_storage,
  ]

  if (nrow(rate_card) == 0) {
    stop("No instance type found matching specifications")
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
