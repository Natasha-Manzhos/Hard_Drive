# Install packages if we need it 
if (!require("corrplot")) install.packages("corrplot")
if (!require("ggplot2"))  install.packages("ggplot2")
if (!require("dplyr"))    install.packages("dplyr")
if (!require("stringr"))  install.packages("stringr")
if (!require("tidyr"))    install.packages("tidyr")
if (!require("gridExtra"))install.packages("gridExtra")

# Load librarys
library (corrplot)
library (ggplot2)
library (dplyr)
library (stringr)
library (tidyr)
library (gridExtra)

# Clear global environment
rm(list = ls())

# Receving names of file in dir "data_Q3_2016"
file_names   <- list.files(path="data_Q3_2016",pattern="*.csv")
# Receving number of file in dir "data_Q3_2016"
N_file_names <- length(file_names)
# Set up current idr
setwd("data_Q3_2016")
# Claer viable
dataset <- 0

# Read first file from dir
dataset <- read.csv(file_names[1])
# Read all other files
for(i in 2:N_file_names){
  # Read next file
  data    <- read.csv(file_names[i])
  # Mergerdata
  dataset <- rbind.data.frame(dataset,data)
}

# Write appended files
write.csv(dataset,"hard_drive_short.csv",quote=FALSE,row.names=FALSE)
# Remove dataset,data
remove(dataset)
remove(data)

# Read database
dataset <- read.csv("hard_drive_short.csv")
View(dataset)

# Choose columns for work
hard_drive <- dataset[c("date","serial_number","model","capacity_bytes",
                        "failure","smart_9_raw","smart_9_normalized")]
View(hard_drive)

# Temporary work database for work
test_hard_drive  <- hard_drive[c("date","model","failure")]
# Normalized capacity
test_hard_drive$T_capacity_bytes <- hard_drive$capacity_bytes/ 1e12
# For sure that model is character type
test_hard_drive$model            =  as.character(test_hard_drive$model)

# Spliting "model"="firm"+"model_number"
# Insert " " before first digit in a test_hard_drive$model
t1 <- str_replace(test_hard_drive$model,  pattern = "[0-9]", 
                               paste(" ",str_extract(test_hard_drive$model, pattern = "[0-9]") ))
# Spliting each model on two parts
# Spliting symbol is first " "
t2 <- str_split_fixed(t1,pattern=" ",n=2)
# Add two new colums to test_hard_drive
# Firm is firm name
# model_number is the number of hard drive model
test_hard_drive <- mutate(test_hard_drive,firm         = t2[,1],
                                          model_number = t2[,2])
# Deleting extra " " in model_number
test_hard_drive$model_number <- str_replace(test_hard_drive$model_number,pattern = " ","")
View(test_hard_drive)

# Form factor "firm" and "failure"
test_hard_drive$firm    <- as.factor(test_hard_drive$firm)
test_hard_drive$failure <- as.factor(test_hard_drive$failure)
# Structure
str(test_hard_drive)

# Dependence capacity (in TB) on firm
# Facet - failure (0 - work, 1- not) (Picture)
ggplot(test_hard_drive, aes(x=firm,y=T_capacity_bytes,color=firm))+geom_jitter()+facet_wrap(~failure,nrow=2,scales = "free")

# Dependence number of record on each firm + 
# Facet on failure (0 - work, 1 - not) (Picture)
ggplot(test_hard_drive, aes(firm, fill = firm ) ) + geom_bar()+facet_wrap(~failure,nrow=2,scales = "free")

# Number of record for each firm (table)
firms <- count (test_hard_drive,firm,failure)
View(firms)


