## code to prepare `rate_card` dataset goes here
rate_card <- data.table::data.table(
  dnanexus_instance_type = c(
    "azure:mem1_ssd2_v2_x2", "azure:mem1_ssd2_v2_x4", "azure:mem1_ssd2_v2_x8",
    "azure:mem1_ssd2_v2_x16", "azure:mem1_ssd2_v2_x32", "azure:mem1_ssd2_v2_x48",
    "azure:mem1_ssd2_v2_x64", "azure:mem1_ssd2_v2_x72", "azure:mem2_ssd1_v2_x2",
    "azure:mem2_ssd1_v2_x4", "azure:mem2_ssd1_v2_x8", "azure:mem2_ssd1_v2_x16",
    "azure:mem2_ssd1_v2_x32", "azure:mem2_ssd1_v2_x48", "azure:mem2_ssd1_v2_x64",
    "azure:mem2_ssd1_v2_x96", "azure:mem2_ssd2_x2", "azure:mem2_ssd2_x4",
    "azure:mem2_ssd2_x8", "azure:mem2_ssd2_x16", "azure:mem2_ssd2_x32",
    "azure:mem2_ssd2_x48", "azure:mem2_ssd2_x64", "azure:mem2_ssd2_x96",
    "azure:mem3_ssd1_v2_x2", "azure:mem3_ssd1_v2_x4", "azure:mem3_ssd1_v2_x8",
    "azure:mem3_ssd1_v2_x16", "azure:mem3_ssd1_v2_x32", "azure:mem3_ssd1_v2_x48",
    "azure:mem3_ssd1_v2_x64", "azure:mem3_ssd1_x96", "azure:mem3_ssd2_x2",
    "azure:mem3_ssd2_x4", "azure:mem3_ssd2_x8", "azure:mem3_ssd2_x16",
    "azure:mem3_ssd2_x32", "azure:mem3_ssd2_x48", "azure:mem3_ssd2_x64",
    "azure:mem3_ssd2_x96", "azure:mem3_ssd3_x2", "azure:mem3_ssd3_x4",
    "azure:mem3_ssd3_x8", "azure:mem3_ssd3_x16", "azure:mem3_ssd3_x32",
    "azure:mem3_ssd3_x48", "azure:mem3_ssd3_x64", "azure:mem3_ssd3_x96"
  ),
  azure_instance_type = c(
    "Standard_F2s_v2", "Standard_F4s_v2", "Standard_F8s_v2", "Standard_F16s_v2",
    "Standard_F32s_v2", "Standard_F48s_v2", "Standard_F64s_v2",
    "Standard_F72s_v2", "Standard_D2s_v5", "Standard_D4s_v5", "Standard_D8s_v5",
    "Standard_D16s_v5", "Standard_D32s_v5", "Standard_D48s_v5",
    "Standard_D64s_v5", "Standard_D96s_v5", "Standard_D2s_v5", "Standard_D4s_v5",
    "Standard_D8s_v5", "Standard_D16s_v5", "Standard_D32s_v5", "Standard_D48s_v5",
    "Standard_D64s_v5", "Standard_D96s_v5", "Standard_E2s_v5", "Standard_E4s_v5",
    "Standard_E8s_v5", "Standard_E16s_v5", "Standard_E32s_v5", "Standard_E48s_v5",
    "Standard_E64s_v5", "Standard_E96s_v5", "Standard_E2s_v5", "Standard_E4s_v5",
    "Standard_E8s_v5", "Standard_E16s_v5", "Standard_E32s_v5", "Standard_E48s_v5",
    "Standard_E64s_v5", "Standard_E96s_v5", "Standard_E2s_v5", "Standard_E4s_v5",
    "Standard_E8s_v5", "Standard_E16s_v5", "Standard_E32s_v5", "Standard_E48s_v5",
    "Standard_E64s_v5", "Standard_E96s_v5"
  ),
  n_gpus = 0L,
  n_cpus = c(
    2L, 4L, 8L, 16L, 32L, 48L, 64L, 72L, 2L, 4L, 8L, 16L, 32L, 48L, 64L, 96L, 2L,
    4L, 8L, 16L, 32L, 48L, 64L, 96L, 2L, 4L, 8L, 16L, 32L, 48L, 64L, 96L, 2L, 4L,
    8L, 16L, 32L, 48L, 64L, 96L, 2L, 4L, 8L, 16L, 32L, 48L, 64L, 96L
  ),
  ram_gb = c(
    4L, 8L, 16L, 32L, 64L, 96L, 128L, 144L, 8L, 16L, 32L, 64L, 128L, 192L, 256L,
    384L, 8L, 16L, 32L, 64L, 128L, 192L, 256L, 384L, 16L, 32L, 64L, 128L, 256L,
    384L, 512L, 672L, 16L, 32L, 64L, 128L, 256L, 384L, 512L, 672L, 16L, 32L, 64L,
    128L, 256L, 384L, 512L, 672L
  ),
  disk_storage_gb = c(
    160L, 320L, 640L, 1280L, 2560L, 3840L, 5120L, 5760L, 32L, 64L, 128L, 256L,
    512L, 768L, 1024L, 1536L, 160L, 320L, 640L, 1280L, 2560L, 3840L, 5120L, 7680L,
    32L, 64L, 128L, 256L, 512L, 768L, 1024L, 1536L, 160L, 320L, 640L, 1280L,
    2560L, 3840L, 5120L, 7680L, 1280L, 2560L, 5120L, 10240L, 20480L, 30720L,
    40960L, 61440L
  ),
  storage_type = "Premium SSD",
  on_demand_rate_gpb_per_h = c(
    0.0878, 0.1728, 0.3424, 0.672, 1.3312, 2.0016, 2.624, 2.9664, 0.076, 0.1488,
    0.2944, 0.5856, 1.1648, 1.7472, 2.3168, 3.4752, 0.0962, 0.188, 0.3696, 0.7232,
    1.4304, 2.1504, 2.8224, 4.2528, 0.0984, 0.194, 0.3848, 0.7664, 1.5264, 2.2896,
    3.04, 4.56, 0.1188, 0.2332, 0.46, 0.9056, 1.792, 2.6928, 3.5456, 5.3376,
    0.2708, 0.5248, 1.012, 1.9648, 3.8112, 5.7696, 7.5712, 11.376
  ),
  spot_rate_gpb_per_h = c(
    0.0485, 0.0951, 0.1866, 0.3601, 0.7056, 1.0656, 1.3765, 1.563, 0.0323, 0.0616,
    0.12, 0.2359, 0.4663, 0.6996, 0.9184, 1.3821, 0.0525, 0.1007, 0.1951, 0.3747,
    0.7323, 1.1043, 1.4272, 2.1569, 0.0395, 0.0759, 0.1486, 0.2931, 0.5808,
    0.8713, 1.1474, 1.7256, 0.0597, 0.115, 0.2238, 0.4319, 0.8468, 1.2761, 1.6562,
    2.5004, 0.2118, 0.4066, 0.776, 1.4915, 2.8647, 4.3536, 5.6806, 8.5428
  )
)
usethis::use_data(rate_card, overwrite = TRUE)
