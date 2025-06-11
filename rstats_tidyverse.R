library(tidyverse)
library(data.table)
library(dtplyr)

################################################################################
#   R's default behavior: copy on modify
################################################################################

a = tibble(x = 1:3)

#   At this point, a second tibble is not created. 'b' just points to the same
#   location in memory as 'a'; it's a reference, not copy
b = a

#   However, the second we modify 'b', R actually creates a full copy of 'a',
#   then adds a column to the new tibble
b$y = 4:6

#   Note that 'a' remains unchanged
a

#   This applies for almost all ordinary objects in base R, like vectors, lists,
#   and data frames!
