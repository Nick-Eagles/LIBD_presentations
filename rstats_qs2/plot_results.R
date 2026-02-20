#   Ran interactively

library(tidyverse)
library(here)

result_dir = here('rstats_qs2', 'results')
compr_levels = c(1, 3, 22)
datasets = c('smaller', 'large_multiome')

result_df_list = list()
for (dataset in datasets) {
    for (compr_level in compr_levels) {
        result_df_list[[length(result_df_list) + 1]] = read_csv(
            file.path(result_dir, sprintf('%s_%d.csv', dataset, compr_level)),
            show_col_types = FALSE
        )
    }
}
p = bind_rows(result_df_list) |>
    mutate(
        compr_level = factor(
            as.character(compr_level), levels = as.character(compr_levels)
        )
    ) |>
    ggplot(
        aes(
            x = compr_level, y = median_time, color = ser_method,
            group = ser_method
        )
    ) +
    geom_point() +
    geom_line() +
    facet_grid(dataset ~ action, scales = 'free_y') +
    labs(
        x = 'Compression level', y = 'Median time (seconds)',
        color = 'Serialization method'
    ) +
    theme_bw(base_size = 20)
pdf(file.path(result_dir, 'results.pdf'))
print(p)
dev.off()
