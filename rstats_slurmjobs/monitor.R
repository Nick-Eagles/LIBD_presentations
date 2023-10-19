remotes::install_github('LieberInstitute/slurmjobs')

library(slurmjobs)
library(dplyr)

################################################################################
#   Monitor partitions and check how busy the cluster is
################################################################################

#   Summarize how busy the cluster is for the partitions you're able to access
part_df <- partition_info(partition = NULL, all_nodes = FALSE) |>
    filter(partition %in% c('shared', 'bluejay', 'gpu')) |>
    summarize(
        prop_free_cpus = sum(free_cpus) / sum(total_cpus),
        prop_free_mem_gb = sum(free_mem_gb) / sum(total_mem_gb)
    )
print(part_df)

#   It's also possible to give a breakdown by node rather than partition. This
#   gives an output similar to the 'slurmpic' utility as JHPCE
partition_info(partition = "shared", all_nodes = TRUE)
