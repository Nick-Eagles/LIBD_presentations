library(getopt)
library(bench)
library(sessioninfo)
library(tidyverse)
library(here)
library(qs2)

# Import command-line parameters
spec <- matrix(
    c(
        c("compr_level", "dataset"),
        c("c", "d"),
        rep("1", 2),
        c('integer', 'character'),
        c("Compression level", "Name of the dataset")
    ),
    ncol = 5
)
opt <- getopt(spec)

message("Using the following parameters:")
print(opt)

if (opt$dataset == 'smaller') {
    sce_in_path = here('rstats_qs2', 'data', 'smaller_sce.rds')
} else {
    sce_in_path = here('rstats_qs2', 'data', 'huge_multiome_sce.rds')
}
out_dir = '/fastscratch/myscratch/neagles'
result_dir = here('rstats_qs2', 'results')
num_iterations = 5

dir.create(result_dir, showWarnings = FALSE)

################################################################################
#   Functions
################################################################################

my_write_rds = function() {
    saveRDS(sce, file.path(out_dir, 'sce.rds'))
}

my_write_qs2 = function() {
    qs_save(
        sce, file.path(out_dir, 'sce.qs2'), compress_level = opt$compr_level
    )
}

my_read_rds = function() {
    sce = readRDS(file.path(out_dir, 'sce.rds'))
}

my_read_qs2 = function() {
    sce = qs_read(file.path(out_dir, 'sce.qs2'))
}

export_df = function(the_df, filename) {
    the_df |>
        mutate(
            dataset = opt$dataset,
            mem_alloc_gb = as.numeric(mem_alloc) / 1e9
        ) |>
        dplyr::rename(median_time = median) |>
        select(
            ser_method, dataset, compr_level, action, median_time, mem_alloc_gb
        ) |>
        write_csv(file.path(result_dir, filename))
}

run_benchmark = function(rds_fun, qs2_fun, action) {
    if (opt$compr_level == 1) {
        bench_df = bench::mark(
                rds_fun(),
                qs2_fun(),
                iterations = num_iterations,
                check = FALSE
            ) |>
            mutate(
                ser_method = c('rds', 'qs2'),
                action = action,
                compr_level = c(NA, opt$compr_level)
            )
    } else {
        bench_df = bench::mark(
                qs2_fun(),
                iterations = num_iterations,
                check = FALSE
            ) |>
            mutate(
                ser_method = 'qs2',
                action = action,
                compr_level = opt$compr_level
            )
    }
    return(bench_df)
}

################################################################################
#   Run benchmark
################################################################################

sce = readRDS(sce_in_path)

#   First benchmark writing a few times, then reading a few times
write_df = run_benchmark(my_write_rds, my_write_qs2, 'write')
read_df = run_benchmark(my_read_rds, my_read_qs2, 'read')

#   Merge and export
rbind(write_df, read_df) |>
    export_df(sprintf('%s_%s.csv', opt$dataset, opt$compr_level))

message("Memory usage:")
gc()

session_info()

## This script was made using slurmjobs version 1.3.0
## available from http://research.libd.org/slurmjobs/
