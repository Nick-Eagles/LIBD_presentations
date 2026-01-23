#!/bin/bash
#SBATCH -p katun
#SBATCH --job-name=duckplyr_fread
#SBATCH -t 1-0:00:00

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

/usr/bin/time -v Rscript duckplyr_fread.R

echo "**** Job ends ****"
date
