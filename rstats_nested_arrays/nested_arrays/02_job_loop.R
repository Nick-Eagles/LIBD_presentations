library(getopt)
library(sessioninfo)

# Import command-line parameters
spec <- matrix(
    c(
        c("k", "sample_id"),
        c("k", "s"),
        rep("1", 2),
        rep("character", 2),
        rep("Add variable description here", 2)
    ),
    ncol = 5
)
opt <- getopt(spec)

message("Using the following parameters:")
print(opt)

message("Memory usage:")
gc()

session_info()

## This script was made using slurmjobs version 1.3.0
## available from http://research.libd.org/slurmjobs/
