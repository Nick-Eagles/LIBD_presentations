#!/bin/bash
#SBATCH --mem=2G
#SBATCH --job-name=01_main_wrapper
#SBATCH -c 1
#SBATCH -t 10:00
#SBATCH -o /dev/null
#SBATCH -e /dev/null
#SBATCH --array=2-10%2

export OUTER_TASK=$SLURM_ARRAY_TASK_ID
log_path=logs/01_main_k${OUTER_TASK}_sample%a.txt
sbatch \
    --export=ALL,OUTER_TASK \
    -o $log_path \
    -e $log_path \
    01_main.sh

## This script was made using slurmjobs version 1.2.4
## available from http://research.libd.org/slurmjobs/
