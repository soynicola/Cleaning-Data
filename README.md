# Getting and Cleaning Data Project
This project requires us to use dataset from wearable computing to get a tidy data.

You should create one R script called run_analysis.R that does the following. 
   1. Merges the training and the test sets to create one data set.
   2. Extracts only the measurements on the mean and standard deviation for each measurement. 
   3. Uses descriptive activity names to name the activities in the data set
   4. Appropriately labels the data set with descriptive variable names. 
   5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Notes
Before you run the script, please notice the following. 
   1. Please unzip the dataset file https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. 
   2. Make sure that your working directory is set at getdata_projectfiles_UCI HAR Dataset.
   3. Install reshape2 pacakge

Script is saves as "run_analysis.R".

## Steps
   1. Read test, train, their respective label and subject file. 
   2. Use feature & activity label and merge them altogether as a new dataframe "all_data". 
   3. Since only mean & std are needed, use grep function to extract the feature names which contains mean() and std(); subset the data by the feature list. 
   4. Write a function "mgsub" to replace multiple names into appropriate and readable labels. 
   5. Load plyr package, use melt function to subset data, and then use dcast to caculate variable mean by each pair of Subject + Activity.
   6. Write the final result to "tidy.txt".

## Result
You shall get a "tidy.txt" in your working directory, which contains the tidy data.
You can use read.table("tidy.txt", header = T) to view it in R.


