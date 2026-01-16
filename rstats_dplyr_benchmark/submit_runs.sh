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
rm -f results/job_ids.txt

script_names=(dplyr_fread.sh duckplyr_fread.sh pure_dplyr.sh pure_duckplyr.sh)
num_cores=(1 2 4 8)

for script_name in "${script_names[@]}"; do
    for cores in "${num_cores[@]}"; do
        for iteration in 1 2; do
            job_id=$(
                sbatch \
                    --parsable \
                    -c $cores \
                    --nodelist=compute-178 \
                    -o logs/${script_name%.sh}_c${cores}_i${iteration}.txt \
                    -e logs/${script_name%.sh}_c${cores}_i${iteration}.txt \
                    $script_name
            )
            echo "$job_id" >> results/job_ids.txt
            echo "Submitted ${script_name} (iteration ${iteration}) with ${cores} cores: job ID $job_id"
        done
    done
done

echo "**** Job ends ****"
date
