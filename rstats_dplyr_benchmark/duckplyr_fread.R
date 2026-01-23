library(here)
library(tidyverse)
library(data.table)
library(duckplyr)

ficture_input_path = here(
    'rstats_dplyr_benchmark', 'data', 'smaller_ficture_output.tsv.gz'
)
col_data_path = here(
    'rstats_dplyr_benchmark', 'data', 'smaller_col_data.csv.gz'
)
ficture_colnames = c('sample_id', 'barcode', 'factor_K1')

#   Configure use of all cores, up to 80% of requested memory, and verbose
#   fallback info
num_cores = as.integer(Sys.getenv("SLURM_CPUS_PER_TASK"))
mem_request = as.integer(
    0.8 * as.integer(Sys.getenv("SLURM_MEM_PER_NODE")) / 1e3
)
cpu_command = sprintf("SET threads = %d", num_cores)
mem_command = sprintf("SET memory_limit = '%dGB'", mem_request)
fallback_config(info = TRUE)
message(sprintf("Running '%s'...", cpu_command))
message(sprintf("Running '%s'...", mem_command))
db_exec(cpu_command)
db_exec(mem_command)

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
