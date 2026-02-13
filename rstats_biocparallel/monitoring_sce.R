#   We'll request 4 cores on an interactive session at JHPCE, and monitor
#   memory usage by worker depending on which BiocParallel backend is specified

library(SingleCellExperiment)
library(BiocParallel)
library(getopt)

# Import command-line parameters
spec <- matrix(
    c(
        "param_type", "p", 1, "character",
        "Type of BiocParallel parameter to use"
    ),
    ncol = 5
)
opt <- getopt(spec)

if (opt$param_type == 'm') {
    param = MulticoreParam(4)
} else if (opt$param_type == 's') {
    param = SnowParam(4)
} else {
    stop("Invalid param_type. Use 'm' for MulticoreParam or 's' for SnowParam.")
}

sce_path = '/fastscratch/myscratch/neagles/sce_sparse.rds'
sce = readRDS(sce_path)
cell_types = unique(sce$cellType_broad_hc)

message("About to parallelize.")

result_list = BiocParallel::bplapply(
    cell_types,
    function(cell_type) {
        #   Note the largest object needed by child processes is the SCE
        temp = MatrixGenerics::rowMeans(
            assays(sce)$logcounts[, sce$cellType_broad_hc == cell_type]
        )

        #   Keep the child process alive for easier monitoring
        Sys.sleep(40)
        
        return(temp)
    },
    BPPARAM = param,
    sce = sce
)
