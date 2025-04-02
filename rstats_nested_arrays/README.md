# R Stats Club: nested array jobs and SLURM job dependencies (2025-04-04)

In this [R Stats Club](https://research.libd.org/rstatsclub/) session, I'll
cover two general topics:

1. Using **nested array jobs** with SLURM to analyze each element of a dataset
defined by potentially several categorical variables
2. Using **SLURM job dependencies** to organize an analysis workflow into a
`run_all.sh` script, a submittable shell script documenting the order and
structure of many analysis steps

## Set-up

We'll use the [`slurmjobs`](https://github.com/LieberInstitute/slurmjobs) R
package when creating some nested array jobs. It's available from GitHub:

```{r}
#   Install slurmjobs
remotes::install_github("LieberInstitute/slurmjobs")
```
