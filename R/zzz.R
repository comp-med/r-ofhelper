# Pre-define variables to avoid "no visible global function definition" warnings
# This addresses data.table variable references in the package

# Variables used in find_tre_instance_type function
n_cpus <- NULL
ram_gb <- NULL
disk_storage_gb <- NULL
dnanexus_instance_type <- NULL
on_demand_rate_gpb_per_h <- NULL

# Variables used in other functions
index <- NULL
original <- NULL
name <- NULL
coding_name <- NULL
is_multi_select <- NULL
meaning <- NULL
type <- NULL
