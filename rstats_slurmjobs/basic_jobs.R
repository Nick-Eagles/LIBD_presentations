library(slurmjobs)

#   With 'create_shell = FALSE', the contents of the potential shell script are
#   only printed to the screen
job_single(
    name = "my_shell_script", memory = "10G", cores = 2, create_shell = FALSE
)

#   To actually create the script, we'll just set create_shell = TRUE
job_single(
    name = "my_shell_script", memory = "10G", cores = 2, create_shell = TRUE
)

#   To create an array job, just specify the number of tasks. We'll also specify
#   the number of concurrent tasks to execute, though the default is 20 if left
#   NULL. We'll directly write to disk (create_shell = TRUE) this time.
job_single(
    name = "my_array_job", memory = "5G", cores = 1, create_shell = TRUE,
    task_num = 10, tc = 5
)
