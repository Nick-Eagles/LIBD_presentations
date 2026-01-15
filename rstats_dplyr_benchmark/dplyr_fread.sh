#!/bin/bash
#SBATCH -p katun
#SBATCH --mem=150G
#SBATCH --job-name=dplyr_fread
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

Rscript dplyr_fread.R

echo "**** Job ends ****"
date
