import os

#   We're looping through two categorical variables with this nested array job.
#   Get the task IDs for each loop from the environment variables
inner_task_id = int(os.getenv('SLURM_ARRAY_TASK_ID')) - 1
outer_task_id = int(os.getenv('OUTER_TASK_ID'))

#   The inner loop spans the four samples. The sample ID for this array task
#   can be subset from the inner task ID
all_samples = ['A', 'B', 'C', 'D']
this_sample = all_samples[inner_task_id]

#   The outer loop spans the values of k. Since k is an integer, we opt to
#   directly use the outer task ID as the value of k
this_k = outer_task_id

print(f'Clustering sample {this_sample} at k = {this_k}')
