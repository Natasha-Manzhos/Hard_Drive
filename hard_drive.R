# Install packages if we need it 
if (!require("corrplot")) install.packages("corrplot")
if (!require("ggplot2"))  install.packages("ggplot2")
if (!require("dplyr"))    install.packages("dplyr")
if (!require("stringr"))  install.packages("stringr")
if (!require("tidyr"))    install.packages("tidyr")

# Load librarys
library (corrplot)
library (ggplot2)
library (dplyr)
library (stringr)
library(tidyr)

# Clear global environment
rm(list = ls())

# Append files
file_names   <- list.files(path="data_Q3_2016",pattern="*.csv")
N_file_names <- length(file_names)
setwd("data_Q3_2016")
dataset <- 0

dataset <- read.csv(file_names[1])
for(i in 2:N_file_names){
  data    <- read.csv(file_names[i])
  dataset <- rbind.data.frame(dataset,data)
}

# Write appended files
write.csv(dataset,"hard_drive_short.csv",quote=FALSE,row.names=FALSE)
remove(dataset)
remove(data)

# Read database
dataset <- read.csv("hard_drive_short.csv")
View(dataset)

# Columns for work
hard_drive <- dataset[c("date","serial_number","model","capacity_bytes",
                        "failure","smart_9_raw","smart_9_normalized")]
View(hard_drive)




# Temporary work database for now
test_hard_drive  <- hard_drive[c("date","model","failure")]
# Normalized capacity
test_hard_drive$T_capacity_bytes <- hard_drive$capacity_bytes/ 1e12
test_hard_drive$model            =  as.character(test_hard_drive$model)

# Spliting "model"="firm"+"model_number"
t1 <- str_replace(test_hard_drive$model,  pattern = "[0-9]", 
                               paste(" ",str_extract(test_hard_drive$model, pattern = "[0-9]") ))
t2 <- str_split_fixed(t1,pattern=" ",n=2)

test_hard_drive <- mutate(test_hard_drive,firm         = t2[,1],
                                          model_number = t2[,2])
test_hard_drive$model_number <- str_replace(test_hard_drive$model_number,pattern = " ","")
View(test_hard_drive)

# Form factor
test_hard_drive$firm    <- as.factor(test_hard_drive$firm)
test_hard_drive$failure <- as.factor(test_hard_drive$failure)
str(test_hard_drive)

ggplot(test_hard_drive, aes(x=firm, y=T_capacity_bytes, color=firm )) + geom_jitter()
ggplot(test_hard_drive, aes(x=firm, y=failure, color=firm)) + geom_jitter()



# Count Number of Firms
firms <- count (test_hard_drive,name=firm)
View(firms)








