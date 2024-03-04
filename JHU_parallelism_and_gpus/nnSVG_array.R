library(tidyverse)
library(SpatialExperiment)
library(nnSVG)

message(Sys.time(), " | Loading SpatialExperiment")
spe <- loadHDF5SummarizedExperiment(spe_dir)

#   Subset the full dataset to one donor (sample ID), using the array task to
#   uniquely choose the donor
sample_id <- unique(spe$sample_id)[
    as.integer(Sys.getenv("SLURM_ARRAY_TASK_ID"))
]
message(sprintf("Using sample ID %s.", sample_id))

spe <- spe[, spe$sample_id == sample_id]
out_path <- paste0(sample_id, ".csv")

#-------------------------------------------------------------------------------
#   Filter lowly expressed and mitochondrial genes, and take spots with at
#   least some nonzero counts
#-------------------------------------------------------------------------------

message(Sys.time(), " | Filtering genes and spots")
spe <- filter_genes(
    spe,
    filter_genes_ncounts = 3,
    filter_genes_pcspots = 0.5,
    filter_mito = TRUE
)
spe <- spe[rowSums(assays(spe)$counts) > 0, colSums(assays(spe)$counts) > 0]
message("Dimensions of spe after filtering:")
print(dim(spe))

#-------------------------------------------------------------------------------
#   Recompute logcounts (library-size normalization as recommended in
#   https://bioconductor.org/packages/release/bioc/vignettes/nnSVG/inst/doc/nnSVG.html)
#-------------------------------------------------------------------------------

message(Sys.time(), " | Re-computing logcounts")
spe <- computeLibraryFactors(spe)
spe <- logNormCounts(spe)

#-------------------------------------------------------------------------------
#   Run nnSVG and export results
#-------------------------------------------------------------------------------

spe <- nnSVG(spe)

message(Sys.time(), " | Exporting results")
write.csv(rowData(spe), out_path, row.names = FALSE, quote = FALSE)
