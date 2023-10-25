# R Stats Club: `slurmjobs` (2023-10-27)

We'll explore the `slurmjobs` R package, a re-make of [`sgejobs`](https://github.com/LieberInstitute/sgejobs) for SLURM. This package provides functions for working with the SLURM scheduler from R. Today, we'll use `slurmjobs` to create jobs (ordinary and array), monitor and profile jobs, and explore how busy JHPCE is.

We'll interactively run through the following scripts, roughly in order, so this README serves as an agenda for the R Stats Club presentation.

## Creating Scripts and Submitting Them to SLURM

- [TODO.R](TODO): TODO
- [loop.R](https://github.com/Nick-Eagles/LIBD_presentations/blob/main/rstats_slurmjobs/loop.R): Use `job_loop()` to create arrays that loop over pre-specified character variables. We'll also show how `array_submit()` can be used to automatically re-run failed tasks of an array job created with `slurmjobs`.

## Gathering Info About Jobs and Available Resources

- [monitor.R](https://github.com/Nick-Eagles/LIBD_presentations/blob/main/rstats_slurmjobs/monitor.R): Use `partition_info()` to explore how busy partitions are at JHPCE. Then, use `job_info()` to examine our resource usage, as well as resource usage from others at JHPCE.
