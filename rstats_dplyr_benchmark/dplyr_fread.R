#   Use dplyr functions except use fread for I/O

library(here)
library(tidyverse)
library(data.table)

ficture_input_path = here(
    'rstats_dplyr_benchmark', 'data', 'normalized_joined_input.tsv.gz'
)
col_data_path = here('rstats_dplyr_benchmark', 'data', 'col_data.csv.gz')
ficture_colnames = c('sample_id', 'barcode', 'factor_K1')

num_cores = as.integer(Sys.getenv("SLURM_CPUS_PER_TASK"))

ficture_df = fread(
        ficture_input_path, select = ficture_colnames, sep = '\t',
        nThread = num_cores
    ) |>
    as_tibble() |>
    dplyr::distinct(sample_id, barcode, .keep_all = TRUE) |>
    dplyr::filter(!is.na(factor_K1)) |>
    dplyr::rename(FICTURE_k10 = factor_K1)

col_data = fread(col_data_path, nThread = num_cores) |>
    as_tibble() |>
    left_join(ficture_df, by = c('sample_id', 'barcode'))
