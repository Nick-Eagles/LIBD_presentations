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

## Nested array jobs

### Basic array jobs

First, we'll introduce the concept of an [array job with the SLURM job scheduler](https://slurm.schedmd.com/job_array.html).
In my opinion, array jobs are one of the most natural ways you can express a
data analysis task when multiple elements of data must undergo the same
processing. In genomics, one example would be finding spatially variable genes
for each tissue sample. With SLURM, a 3-sample dataset would turn into a 3-task
array job, with each sample being processed in parallel. To turn an ordinary
shell script into an array job, just add `#SBATCH --array=1-3%3` like
in [this example](https://github.com/LieberInstitute/visiumStitched_brain/blob/7cef43fe3894c532b39cace2fd2b84011f0c0044/code/03_stitching/03_nnSVG_unstitched.sh#L7).
In this case, the shell script executes 3 tasks in parallel. The only difference
between these tasks is the `SLURM_ARRAY_TASK_ID` environment variable, which
holds a value of either `1`, `2`, or `3`, depending on the task. Continuing this
3-sample example, we can leverage this environment variable to
[subset samples of our dataset](https://github.com/LieberInstitute/visiumStitched_brain/blob/7cef43fe3894c532b39cace2fd2b84011f0c0044/code/03_stitching/03_nnSVG_unstitched.R#L13-L15)
in R so that each sample gets processed through the workflow.

### Nesting

The above example (3-sample dataset with same processing) is the simplest case,
where we're looping over one categorical variable. *Nesting* occurs when we want
to loop over multiple categorical variables. For example, we may have a
workflow where we wish to perform k-means clustering of each tissue sample at
several values of k. I'll introduce two approaches to using array jobs for this
scenario.

#### Nested `sbatch` call

One approach is to use an array job that submits another array job via `sbatch`.
This concept is implemented in the `nested_arrays/01_main*` scripts. In an
[outer loop]([here](https://github.com/Nick-Eagles/LIBD_presentations/blob/main/rstats_nested_arrays/nested_arrays/01_main_wrapper.sh)),
we'll [loop through values of k](https://github.com/Nick-Eagles/LIBD_presentations/blob/63dfd061a633b2155b7e445967717018766127e4/rstats_nested_arrays/nested_arrays/01_main_wrapper.sh#L8)
(2 through 10). The [log path for the inner loop](https://github.com/Nick-Eagles/LIBD_presentations/blob/63dfd061a633b2155b7e445967717018766127e4/rstats_nested_arrays/nested_arrays/01_main_wrapper.sh#L11)
includes both the outer and inner (`%a`) task IDs to make each task have a
unique log. Finally, [we submit the inner loop](https://github.com/Nick-Eagles/LIBD_presentations/blob/63dfd061a633b2155b7e445967717018766127e4/rstats_nested_arrays/nested_arrays/01_main_wrapper.sh#L12-L16).
In the inner loop, we [loop through 4 tasks](https://github.com/Nick-Eagles/LIBD_presentations/blob/63dfd061a633b2155b7e445967717018766127e4/rstats_nested_arrays/nested_arrays/01_main.sh#L6),
representing data samples, with each task [invoking a Python script](https://github.com/Nick-Eagles/LIBD_presentations/blob/63dfd061a633b2155b7e445967717018766127e4/rstats_nested_arrays/nested_arrays/01_main.sh#L20). Inside [the Python script](https://github.com/Nick-Eagles/LIBD_presentations/blob/main/rstats_nested_arrays/nested_arrays/01_main.py),
we access the task IDs for the inner and outer loops to determine the data
sample and k value to use for (a hypothetical) k-means clustering analysis.
