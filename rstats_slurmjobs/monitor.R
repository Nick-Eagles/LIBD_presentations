library(slurmjobs)
library(dplyr)

#   Given a tibble and vector 'var_names' giving a subset of its colnames,
#   anonymize the specified columns and return a copy of the tibble
anonymize = function(job_df, var_names) {
    for (this_var in var_names) {
        var_map <- paste0(this_var, 1:length(unique(job_df[[this_var]])))
        names(var_map) <- unique(job_df[[this_var]])
        job_df[[this_var]] = var_map[job_df[[this_var]]]
    }

    return(job_df)
}

################################################################################
#   Monitor partitions and check how busy the cluster is
################################################################################

#   Check how busy the cluster is for the partitions you're able to access
part_df = partition_info(partition = NULL, all_nodes = FALSE) |>
    filter(partition %in% c('shared', 'bluejay', 'gpu'))
print(part_df)

#   Summarize the proportion of free resources across all 3 partitions
part_df = part_df |>
    summarize(
        prop_free_cpus = sum(free_cpus) / sum(total_cpus),
        prop_free_mem_gb = sum(free_mem_gb) / sum(total_mem_gb)
    )
print(part_df)

#   It's also possible to give a breakdown by node rather than partition. This
#   gives an output similar to the 'slurmpic' utility as JHPCE
partition_info(partition = "shared", all_nodes = TRUE)

################################################################################
#   Monitor running jobs and cluster usage by user
################################################################################

#   Show info for jobs from all users and partitions
job_info(user = NULL, partition = NULL) |>
    anonymize(c("user", "partition", "name")) |>
    print()

#   How many CPUs and how much memory am I using total right now?
job_info(partition = NULL) |>
    summarize(
        total_mem_req = sum(requested_mem_gb),
        total_cpus = sum(cpus)
    ) |>
    print()

#   How many CPUs and how much memory are others using on the shared partition
#   right now?
job_df = job_info(user = NULL) |>
    anonymize("user") |>
    group_by(user) |> 
    summarize(total_cpus = sum(cpus), total_mem_gb = sum(requested_mem_gb))

#   Top users by memory usage
job_df |>
    arrange(desc(total_mem_gb)) |>
    print()

#   Top users by number of CPUs
job_df |>
    arrange(desc(total_cpus)) |>
    print()
