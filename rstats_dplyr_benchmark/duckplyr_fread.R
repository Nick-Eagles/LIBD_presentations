library(here)
library(tidyverse)
library(data.table)
library(duckplyr)

ficture_input_path = here(
    'rstats_dplyr_benchmark', 'data', 'normalized_joined_input.tsv.gz'
)
col_data_path = here('rstats_dplyr_benchmark', 'data', 'col_data.csv.gz')
ficture_colnames = c('sample_id', 'barcode', 'factor_K1')

#   Configure use of all cores and verbose fallback info
num_cores = as.integer(Sys.getenv("SLURM_CPUS_PER_TASK"))
db_exec(sprintf("SET threads = %d", num_cores))
fallback_config(info = TRUE)

ficture_df = fread(
        ficture_input_path, select = ficture_colnames, sep = '\t',
        nThread = num_cores
    ) |>
    as_duckdb_tibble() |>
    dplyr::select(all_of(ficture_colnames)) |>
    dplyr::distinct(sample_id, barcode, .keep_all = TRUE) |>
    dplyr::filter(!is.na(factor_K1)) |>
    dplyr::rename(FICTURE_k10 = factor_K1)

col_data = fread(col_data_path, nThread = num_cores) |>
    as_duckdb_tibble() |>
    left_join(ficture_df, by = c('sample_id', 'barcode')) |>
    collect()
