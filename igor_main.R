# Install packages if we need it 
if (!require("caret")) install.packages("caret")

# Load library
library(caret)

# Clear environment
rm(list = ls())

dataFileNames <- list.files("data_Q3_2016", pattern = "*.csv")

# Download only first 50 raws from each file for preliminary analysis because
# data set is huge
setwd("data_Q3_2016")
datasetTest <- NULL
for(fileName in dataFileNames){
  datasetT <- rbind(dataset, read.csv(fileName, nrows = 50))
}

# function from cater package gives information and recommendation about each raws 
# Help: nearZeroVar diagnoses predictors that have one unique value 
# (i.e. are zero variance predictors)
# or predictors that are have both of the following characteristics: 
# they have very few unique values relative to the number of samples and the ratio of the 
# frequency of the most common value to the frequency of the second most common value is large.
nearZeroVar(dataset, saveMetrics = TRUE)

# Based on information from previous funtion and wiki article https://ru.wikipedia.org/wiki/S.M.A.R.T. following set is chosen
chosenRawNames <- c("date", "serial_number",
                    "model", "capacity_bytes", "failure", 
                    "smart_1_normalized",         # Raw Read Error Rate
                    "smart_3_normalized",         # Spin-Up Time
                    "smart_7_normalized",         # Seek Error Rate
                    "smart_9_raw",                # Power-on Time Count (Power-On Hours)
                    "smart_12_raw",               # Device Power Cycle Count
                    "smart_190_raw"               # Airflow Temperature (WDC)
                    )

dataset <- NULL
for(fileName in dataFileNames){
  dataTmp <- read.csv(fileName)
  dataset <- rbind(dataset, dataTmp[,chosenRawNames])
}

nearZeroVar(dataset, saveMetrics = TRUE)
# freqRatio percentUnique zeroVar   nzv
# date                   1.000660  0.0014278814   FALSE FALSE
# serial_number          1.000000  1.1574220656   FALSE FALSE
# model                  3.980589  0.0009777884   FALSE FALSE
# capacity_bytes         8.094873  0.0002017659   FALSE FALSE
# failure            17946.387187  0.0000310409   FALSE  TRUE
# smart_1_normalized     3.520207  0.0012571565   FALSE FALSE
# smart_3_normalized     2.173114  0.0021107812   FALSE FALSE
# smart_7_normalized     2.980110  0.0010088293   FALSE FALSE
# smart_9_raw            1.007834  0.8058683444   FALSE FALSE
# smart_12_raw           1.085338  0.0042370829   FALSE FALSE
# smart_190_raw          1.028422  0.0005897771   FALSE FALSE

# save and load processed dataset for easy access. 
write.csv(dataset, "hd_selected_set.csv")
dataset <- read.csv("hd_selected_set.csv")
summary(dataset)
str(dataset)

table(dataset$failure)
#  0       1 
# 6442753     359 

# get only serial number for disks which were broken (359 records)
serialFailed <- as.character(dataset[which(dataset$failure==1), "serial_number"])
# dataset with all records for broken disks 
datasetSerialFailed <- dataset[which(dataset$serial_number %in% serialFailed),]
write.csv(datasetSerialFailed, "datasetSerialFailed")

# new comment
