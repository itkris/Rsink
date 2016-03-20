
library(dplyr)
library(tidyr)

# 0: Load the data in RStudio
data2 <- data.frame(read.csv("data/titanic_original.csv"))

# 1: Port of embarkation
# The embarked column has one missing value, which is known to correspond to a passenger who actually embarked at Southampton. Find the missing value and replace it with S.