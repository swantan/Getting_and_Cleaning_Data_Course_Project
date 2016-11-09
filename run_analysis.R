# You will be required to submit: 
# 1) a tidy data set as described below
# 2) a link to a Github repository with your script for performing the analysis
# 3) a code book that describes the variables, the data, and any transformations 
# or work that you performed to clean up the data called CodeBook.md. 
# You should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected.

#Here are the data for the project:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



##Download files
setwd("~/Documents/[Coursera] Data Specialization/3. Getting and Cleaning Data")
if(!file.exists("./data")){dir.create("./data")}
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              "./Project/data/HARUSDataset.zip", method = "curl")

#Unzip dataSet to /data directory
unzip(zipfile="./Project/data/HARUSDataset.zip", 
      exdir="./Project/data")

##1. Merges the training and the test sets to create one data set
#To read testing files
x.test <- read.table("./Project/data/UCI HAR Dataset/test/X_test.txt")
y.test <- read.table("./Project/data/UCI HAR Dataset/test/y_test.txt")
subject.test <- read.table("./Project/data/UCI HAR Dataset/test/subject_test.txt")

#To read training files
x.train <- read.table("./Project/data/UCI HAR Dataset/train/X_train.txt")
y.train <- read.table("./Project/data/UCI HAR Dataset/train/y_train.txt")
subject.train <- read.table("./Project/data/UCI HAR Dataset/train/subject_train.txt")

#To read features.txt
features <- read.table("./Project/data/UCI HAR Dataset/features.txt")

#To read activity_labels.txt
actlabels <- read.table("./Project/data/UCI HAR Dataset/activity_labels.txt")

#4. Appropriately labels the data set with descriptive variable names.
#To assign column names
colnames(x.test) <- features[,2]
colnames(x.train) <- features[,2]

colnames(y.test) <- "activityID"
colnames(y.train) <- "activityID"

colnames(subject.test) <- "subjectID"
colnames(subject.train) <- "subjectID"

colnames(actlabels) <- c("activityID", "activityType")

#To merge
merge.test <- cbind(subject.test, y.test, x.test)
merge.train <- cbind(subject.train, y.train, x.train)
merge.all <- rbind(merge.train, merge.test)
str(merge.all)
write.table(merge.all, file = "./Project/data/tidydataset1.csv", sep = ",")


#2. Extracts only the measurements on the mean and standard deviation for each measurement
headers <- colnames(merge.all)
mean.std <- (grepl("mean*", headers) | grepl("std*", headers))
set.mean.std <- merge.all[, mean.std == TRUE]
set.mean.std <- cbind(merge.all[1], merge.all[2], set.mean.std)

#3. Uses descriptive activity names to name the activities in the data set
with.activity.names <- merge(set.mean.std, actlabels, by = "activityID", all.x = TRUE)


#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
secdata <- aggregate(. ~subjectID + activityID + activityType, with.activity.names, mean)
library(dplyr)
secdata <- arrange(secdata, activityID)
write.table(secdata, file = "./Project/data/tidydataset2.csv", sep = ",")
