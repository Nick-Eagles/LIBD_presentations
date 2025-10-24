This project largely consists of individual directories, each with a different
topic to be shared as instructional content. It may consist of R, Python, or
shell scripts, for the most part.

## Pairing of R and shell scripts for SLURM submission

In some cases, you will be prompted to generate a corresponding shell script for
a given R script in the project. In this case, the R script
contains the actual work to execute, while its corresponding shell script, which
contains SLURM-recognized syntax, submits the R script (via the `Rscript`
command) as a job to a SLURM-based computing cluster to execute.

A shell script in this project should have the following structure. Note the
brackets "<base name of R script here>", denoting the name of the corresponding
R script to be filled in. Note also the parent directory name of the R script
that must be filled in:

### Content template for shell scripts

```
#!/bin/bash
#SBATCH -p katun
#SBATCH --mem=10G
#SBATCH --job-name=<base name of R script here>
#SBATCH -c 1
#SBATCH -t 1-0:00:00
#SBATCH -o ../../processed-data/<parent directory to R script>/logs/<base name of R script here>.txt
#SBATCH -e ../../processed-data/<parent directory to R script>/logs/<base name of R script here>.txt

set -e

echo "**** Job starts ****"
date

echo "**** JHPCE info ****"
echo "User: ${USER}"
echo "Job id: ${SLURM_JOB_ID}"
echo "Job name: ${SLURM_JOB_NAME}"
echo "Node name: ${HOSTNAME}"
echo "Task id: ${SLURM_ARRAY_TASK_ID}"

## Load the R module
module load conda_R/4.5

## List current modules for reproducibility
module list

Rscript <base name of R script here>.R

echo "**** Job ends ****"
date
```

Suppose an R script `01_first.R` exists under `code/02_QC`, and you are prompted to
generate the corresponding shell script. Please generate this exact script, for
example:

### Concrete example for shell script paired with `code/02_QC/01_first.R`

```
#!/bin/bash
#SBATCH -p katun
#SBATCH --mem=10G
#SBATCH --job-name=01_first
#SBATCH -c 1
#SBATCH -t 1-0:00:00
#SBATCH -o ../../processed-data/02_QC/logs/01_first.txt
#SBATCH -e ../../processed-data/02_QC/logs/01_first.txt

set -e

echo "**** Job starts ****"
date

echo "**** JHPCE info ****"
echo "User: ${USER}"
echo "Job id: ${SLURM_JOB_ID}"
echo "Job name: ${SLURM_JOB_NAME}"
echo "Node name: ${HOSTNAME}"
echo "Task id: ${SLURM_ARRAY_TASK_ID}"

## Load the R module
module load conda_R/4.5

## List current modules for reproducibility
module list

Rscript 01_first.R

echo "**** Job ends ****"
date
```

Generate this script even if the `processed-data/02_QC/logs/` directory (or even
its parents) don't exist.
