#   We'll request 4 cores on an interactive session at JHPCE, and monitor
#   memory usage by worker

library(BiocParallel)
library(lobstr)

#   This will make the parent process slightly longer in duration than the
#   children, to distinguish more easily with ps
Sys.sleep(2)

basic_vector = rep(1.2, times = 1e8)
vector_list = list(basic_vector, basic_vector, basic_vector, basic_vector)

message("Size of the basic vector:")
print(obj_size(basic_vector))
message("Size of the vector list:")
print(obj_size(vector_list))

temp = bplapply(
    vector_list,
    function(x) {
        #   Modify the vector slightly to force a copy-on-write
        x[1] = 1.3

        #   Keep the child process alive for easier monitoring
        Sys.sleep(40)

        #   Return something very small for simplicity
        return(1)
    },
    BPPARAM = MulticoreParam(4)
)
