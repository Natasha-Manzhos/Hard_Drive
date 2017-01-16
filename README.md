# Source  https://www.kaggle.com/backblaze/hard-drive-test-data 
## Context

Each day, Backblaze takes a snapshot of each operational hard drive that includes basic hard drive information (e.g., capacity, failure) and S.M.A.R.T. statistics reported by each drive. This dataset contains data from the first two quarters in 2016.

## Content 

This dataset contains basic hard drive information and 90 columns or raw and normalized values of 45 different S.M.A.R.T. statistics. Each row represents a daily snapshot of one hard drive.

* **date**: Date in yyyy-mm-dd format

* **serial_number**: Manufacturer-assigned serial number of the drive

* **model**: Manufacturer-assigned model number of the drive

* **capacity_bytes**: Drive capacity in bytes

* **failure**: Contains a “0” if the drive is OK. Contains a “1” if this is the last day the drive was operational before failing.

* **90 variables that begin with 'smart'**: Raw and Normalized values for 45 different SMART stats as reported by the given drive

## Inspiration

Some items to keep in mind as you process the data:

* S.M.A.R.T. statistic can vary in meaning based on the manufacturer and model. It may be more informative to compare drives that are similar in model and manufacturer

* Some S.M.A.R.T. columns can have out-of-bound values

* When a drive fails, the 'failure' column is set to 1 on the day of failure, and starting the day after, the drive will be removed from the dataset. Each day, new drives are also added. This means that total number of drives each day may vary. 

* S.M.A.R.T. 9 is the number of hours a drive has been in service. To calculate a drive's age in days, divide this number by 24.

Given the hints above, below are a couple of questions to help you explore the dataset:

1. What is the median survival time of a hard drive? How does this differ by model/manufacturer?

2. Can you calculate the probability that a hard drive will fail given the hard drive information and statistics in the dataset?

## Acknowledgement

The original collection of data can be found [here](https://www.backblaze.com/b2/hard-drive-test-data.html). When using this data, Backblaze asks that you cite Backblaze as the source; you accept that you are solely responsible for how you use the data; and you do not sell this data to anyone.