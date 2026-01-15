#!/bin/bash
#SBATCH -p katun
#SBATCH --mem=2G
#SBATCH --job-name=submit_runs
#SBATCH -t 1-0:00:00
#SBATCH -o logs/submit_runs.txt
#SBATCH -e logs/submit_runs.txt
#SBATCH -c 1

set -e

echo "**** Job starts ****"
date

echo "**** JHPCE info ****"
echo "User: ${USER}"
echo "Job id: ${SLURM_JOB_ID}"
echo "Job name: ${SLURM_JOB_NAME}"
echo "Node name: ${HOSTNAME}"
echo "Task id: ${SLURM_ARRAY_TASK_ID}"

mkdir -p results

script_names=(dplyr_fread.sh duckplyr_fread.sh pure_dplyr.sh pure_duckplyr.sh)
num_cores=(1 2 4 8)

for script_name in "${script_names[@]}"; do
    for cores in "${num_cores[@]}"; do
        job_id=$(
            sbatch
                --parsable
                -c $cores
                -o logs/${script_name%.sh}_c${cores}.txt
                -e logs/${script_name%.sh}_c${cores}.txt
                $script_name
        )
        echo "$job_id" >> results/job_ids.txt
        echo "Submitted ${script_name} with ${cores} cores: job ID $job_id"
    done

    sleep 1000
done

echo "**** Job ends ****"
date
