library(tidyverse)
library(here)
library(slurmjobs)

job_id_path = here('rstats_dplyr_benchmark', 'results', 'job_ids.txt')
out_path = here('rstats_dplyr_benchmark', 'results', 'benchmark_results.csv')
plot_dir = here('rstats_dplyr_benchmark', 'results')

job_df = job_id_path |>
    readLines() |>
    lapply(job_report) |>
    bind_rows() |>
    select(
        name, cpus, requested_mem_gb, max_rss_gb, max_vmem_gb, wallclock_time
    ) |>
    mutate(wallclock_time = as.numeric(wallclock_time))

write_csv(job_df, out_path)

mean_df = job_df |>
    group_by(name, cpus) |>
    summarize(
        RSS = mean(max_rss_gb),
        VMem = mean(max_vmem_gb),
        wallclock_time = mean(wallclock_time)
    )

p = mean_df |>
    pivot_longer(
        cols = c(RSS, VMem), names_to = 'metric', values_to = 'value_gb'
    ) |>
    ggplot(aes(x = cpus, y = value_gb, color = name, group = name)) +
        geom_line() +
        geom_point() +
        facet_wrap(~metric, scales = 'free_y') +
        theme_bw(base_size = 20) +
        labs(
            x = 'Number of cores', y = 'Memory Usage (GB)', color = 'Libraries'
        )
pdf(file.path(plot_dir, 'memory_usage.pdf'), width = 10, height = 6)
print(p)
dev.off()
