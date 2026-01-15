library(here)
library(tidyverse)

ficture_input_path = here(
    'rstats_dplyr_benchmark', 'data', 'normalized_joined_input.tsv.gz'
)
col_data_path = here('rstats_dplyr_benchmark', 'data', 'col_data.csv.gz')
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
