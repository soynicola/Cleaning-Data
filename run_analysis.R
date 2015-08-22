## Before you run this script, 
## Please change directory to where you saved UCI HAR Dataset.

## Assume you should have already installe reshape2 pacakges. 
library(reshape2)

## 1. Merges the training and the test sets to create one data set.
## Steps breakdowon as below.

## read test and train dataset
test_dat <-read.table("UCI HAR Dataset/test/X_test.txt", sep="")
train_dat <-read.table("UCI HAR Dataset/train/X_train.txt", sep="")

## read test and train labels
test_label <-read.table("UCI HAR Dataset/test/Y_test.txt", sep="")
train_label <-read.table("UCI HAR Dataset/train/Y_train.txt", sep="")

## read test and train subjects
test_subject <-read.table("UCI HAR Dataset/test/subject_test.txt", sep="")
train_subject <-read.table("UCI HAR Dataset/train/subject_train.txt", sep="")

## read activity label, and merge it to test and train labels 
activity_labels <-read.table("UCI HAR Dataset/activity_labels.txt", sep="")
x_test_labels <- merge(test_label,activity_labels,by="V1")
y_train_labels <- merge(train_label,activity_labels,by="V1")

## read features and make it as column name of test and train data
features <- read.table("UCI HAR Dataset/features.txt", sep="")[,2]
colnames(test_dat) <- as.character(features)
colnames(train_dat) <- as.character(features)
             
## merge the test and train data and their labels
test_data <- cbind(test_subject, x_test_labels, test_dat)
train_data <- cbind(train_subject, y_train_labels, train_dat)

## merge the data together
all_data <- rbind(train_data,test_data)[c(-2)]

## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 

## Extract the mean & std from feature list
col_mean <- grep("-mean\\()", features, ignore.case= TRUE, value=TRUE)
col_std <- grep("-std()", features, ignore.case= TRUE, value=TRUE)
mean_std <- c(col_mean, col_std)

## subset the columns with subject, activity, and above mean_std 
subset_dat <- all_data[, c("V1", "V2", mean_std)]

## 3.Uses descriptive activity names to name the activities in the data set
## This is done above.

## 4.Appropriately labels the data set with descriptive variable names.
newlabels <- colnames(subset_dat)

## call a function mgsub to replace mutiple patterns 
mgsub <- function(pattern, replacement, x, ...) {
        result <- x
        for (i in 1:length(pattern)) {
                result <- gsub(pattern[i], replacement[i], result, ...)
        }
        result
}
## use mgsub to replace the abbreviation in column names to understandable words.
newlabels <- mgsub(c("-mean\\(\\)", "-std\\(\\)", "tBody", "tGravity", "fBody", "fGravity", "Acc", "Gyro", "Mag"), c(".Mean", ".STD", "Time.Body", "Time.Gravity", "FFT.Body", "FFT.Gravity", ".Acceleration", ".Gyroscope", ".Magnitude"), mean_std)
## use the newlabels on dataset
colnames(subset_dat) <- c("Subject", "Activity", newlabels)

## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## Calculate mean based on each pair of subject & activity.  
datamelt <- melt(subset_dat, id=c("Subject", "Activity"))
final <- dcast(datamelt, Subject + Activity~ variable, mean)

## write the final result to csv
write.table(final, file="tidy.txt", row.names = FALSE)