#!/bin/bash
#SBATCH -p shared
#SBATCH --mem=2G
#SBATCH --job-name=02_job_loop
#SBATCH -c 1
#SBATCH -t 1-00:00:00
#SBATCH -o /dev/null
#SBATCH -e /dev/null
#SBATCH --mail-type=ALL
#SBATCH --array=1-36%20

## Define loops and appropriately subset each variable for the array task ID
all_k=(2 3 4 5 6 7 8 9 10)
k=${all_k[$(( $SLURM_ARRAY_TASK_ID / 4 % 9 ))]}

all_sample_id=(A B C D)
sample_id=${all_sample_id[$(( $SLURM_ARRAY_TASK_ID / 1 % 4 ))]}

## Explicitly pipe script output to a log
log_path=logs/02_job_loop_${k}_${sample_id}_${SLURM_ARRAY_TASK_ID}.txt

{
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
module load conda_R/4.4

## List current modules for reproducibility
module list

## Edit with your job command
Rscript 02_job_loop.R --k ${k} --sample_id ${sample_id}

echo "**** Job ends ****"
date

} > $log_path 2>&1

## This script was made using slurmjobs version 1.3.0
## available from http://research.libd.org/slurmjobs/

