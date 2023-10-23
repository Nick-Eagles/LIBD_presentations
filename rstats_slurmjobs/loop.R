library(spatialLIBD)
library(here)
library(slurmjobs)

spe = fetch_data(type = "spatialDLPFC_Visium")

#   The names of the colData columns related to broad cell-type counts
full_cell_types = colnames(colData(spe))[
    grep('^broad_cell2location_', colnames(colData(spe)))
]
print(full_cell_types)

#   Shortened cell-type names that are more helpful for logging
short_cell_types = str_extract(full_cell_types, '_([a-z]+)$', group = 1)
print(short_cell_types)

#   Suppose we want to plot just the anterior position in the DLPFC
sample_ids = unique(spe$sample_id)[grep('_ant$', unique(spe$sample_id))]
print(sample_ids)

#   Let's run job_loop with create_shell = FALSE, to take a quick peek at the
#   shell and R scripts that would be created
script_pair = job_loop(
    loops = list(
        cell_type = short_cell_types,
        sample_id = sample_ids
    ),
    name = "deconvo_plots",
    partition = "shared",
    memory = "5G",
    cores = 1,
    tc = 10,
    logdir = "logs",
    create_shell = FALSE
)

cat(script_pair[["shell"]], sep = "\n")
cat(script_pair[["R"]], sep = "\n")

#   Though in practice, you'll likely just write the scripts directly with the
#   'job_loop' function, using create_shell = TRUE
script_pair = job_loop(
    loops = list(
        cell_type = short_cell_types,
        sample_id = sample_ids
    ),
    name = "deconvo_plots",
    partition = "shared",
    memory = "5G",
    cores = 1,
    tc = 10,
    logdir = "logs",
    create_shell = TRUE
)

#   To resubmit failed tasks from the above array, run with submit = TRUE. Here,
#   we'll just examine which tasks failed and how that was determined
array_submit(
    'deconvo_plots.sh',
    submit = FALSE,
    verbose = TRUE
)
