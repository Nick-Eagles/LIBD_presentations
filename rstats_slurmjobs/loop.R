library(spatialLIBD)
library(here)
library(slurmjobs)
library(stringr)
library(withr)

script_name = "deconvo_plots"

spe = fetch_data(type = "spatialDLPFC_Visium")

#   Neuronal cell-type-count predictions from cell2location, shortened from the
#   full column names in colData(spe)
cell_types = c("inhib", "excit")
stopifnot(
    all(paste0('broad_cell2location_', cell_types) %in% colnames(colData(spe)))
)

#   Suppose we want to plot just the anterior position in the DLPFC
sample_ids = unique(spe$sample_id)[grep('_ant$', unique(spe$sample_id))]
print(sample_ids)

#   Let's run job_loop with create_shell = FALSE, to take a quick peek at the
#   shell and R scripts that would be created
with_dir(
    here("rstats_slurmjobs"),
    {
        script_pair = job_loop(
            loops = list(cell_type = cell_types, sample_id = sample_ids),
            name = script_name,
            partition = "shared",
            memory = "5G",
            cores = 1,
            tc = 10,
            logdir = "logs",
            create_shell = FALSE
        )
    }
)

cat(script_pair[["shell"]], sep = "\n")
cat(script_pair[["R"]], sep = "\n")

#   Though in practice, you'll likely just write the scripts directly with the
#   'job_loop' function, using create_shell = TRUE
with_dir(
    here("rstats_slurmjobs"),
    {
        script_pair = job_loop(
            loops = list(cell_type = cell_types, sample_id = sample_ids),
            name = script_name,
            partition = "shared",
            memory = "5G",
            cores = 1,
            tc = 10,
            logdir = "logs",
            create_shell = TRUE
        )
    }
)

#   To resubmit failed tasks from the above array, run with submit = TRUE. Here,
#   we'll just examine which tasks failed and how that was determined
array_submit(
    name = script_name,
    submit = FALSE,
    verbose = TRUE
)
