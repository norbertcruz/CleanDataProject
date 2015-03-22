# CleanDataProject

The purpose of this project is to clean and summarise the data from the UCI HAR Dataset downloaded from:

    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
    
The zip folder must be downloaded and unzipped into the working directory

The script found in run_analysis.R works by following steps

    1. Merges the training and test sets to create one data set
    2. Appropraitely labels the data set with descriptive variable names
    3. Extracts only the measurements on the mean and standard deviation for each measure
    4. Sets descriptive activity names to the activities in the data set
    5. Creates a second, independent tidy data set with the mean of each variable for each activity of each subject
    
HOW TO RUN

Set the working directory to the correct location. Load the run_analysis.R file with the source command. The script should be run by storing the output of the function into a variable. The output will be the data set created in the last step.

    Example: 
    
    source("./run_analysis.R")
    
    tidyData <- run_analysis()    
    
The script loads the dplyr package as to use the arrange(), group_by() and summarise_each() functions

STEP1

    Reads the train and test sets. Joins their respective files into separate train and data sets. 
    Merges these sets into a combined set.
    
    Train Set
    
        trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
    
        trainMeasure <- read.table("./UCI HAR Dataset/train/X_train.txt")
    
        trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt")
    
        trainSet <- cbind(trainSubject, trainActivity, trainMeasure)
    
    
    Test Set
    
        testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
    
        testMeasure <- read.table("./UCI HAR Dataset/test/X_test.txt")
    
        testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt")
    
        testSet <- cbind(testSubject, testActivity, testMeasure)
    
    
    Combined Set
    
        dataSet <- rbind(trainSet, testSet)
        
STEP 2

    Reads the variable names from the "features.txt" file. Reformats the varaible names and then alocates them in the combined data set.
    
    Original Variable Names
    
        measures <- read.table("./UCI HAR Dataset/features.txt")
    
        measures <- measures[, 2]
        
    Reformat Variable Names
    
        measures <- gsub("[(),-]", "_", measures)
    
        measures <- gsub("_+", "_", measures)
    
        measures <- gsub("_$", "", measures)
    
        (and so on)
        
    Replace Variable Names
    
        names(dataSet) <- c(c("Subject", "Activity"), measures)
        
STEP 3

    Generates a subset from the combined data set that only includes variables that contain the mean and standard deviation of the measures
    
        subsetMeasures <- measures[grep("mean|std", measures)]
    
        subsetNames <- c(c("Subject", "Activity"), subsetMeasures)
    
        tidyData <- dataSet[, subsetNames]
        
STEP 4

    Reads activity labels from "activity_labels.text". The activity labels are converted to lower case and assigned correctly to the data subset with a for loop.
    
STEP 5

    The tidy data set is generated using the group_by() and summarise each() functions on the data subset
    
        dataMeans <- group_by(tidyData, Activity, Subject)
    
        dataMeans <- summarise_each(dataMeans, funs(mean))
        
    The mean values are rounded to 8 decimal places with the round() function
    
    The final data set is written into a text file
    
        write.table(dataMeans, file = "./dataMeans.txt", row.name = FALSE)