library(here)
library(tidyverse)

ficture_input_path = here(
    'processed-data', '10_HD_bin_level', 'new_samples2', 'ficture_harmony',
    'ficture_outputs', 'normalized', 'k_10', 'analysis', 'nF10.d_12',
    'normalized_joined_input.tsv.gz'
)
col_data_path = here(
    'processed-data', '10_HD_bin_level', 'new_samples2', 'ficture_harmony',
    'rstats_duckplyr', 'col_data.csv.gz'
)
ficture_colnames = c('sample_id', 'barcode', 'factor_K1')

ficture_df = read_tsv(
        ficture_input_path, col_select = all_of(ficture_colnames),
        show_col_types = FALSE
    ) |>
    distinct(sample_id, barcode, .keep_all = TRUE) |>
    filter(!is.na(factor_K1)) |>
    rename(FICTURE_k10 = factor_K1)

col_data = read_csv(col_data_path, show_col_types = FALSE) |>
    left_join(ficture_df, by = c('sample_id', 'barcode'))
