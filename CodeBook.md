---
title: "CodeBook"
author: "Norbert Cruz"
date: "Sunday, March 22, 2015"
output: html_document
---

Clean UCI HAR DataSet

The UCI Har dataset consists of smartphone telemetry data collected while subjects performed various activities.

The data used for this analysis was downloaded from:

    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
    
The data was stored originaly as follows:

    - Train group
    
        a. X_tain.txt - contains numeric values for observed variables
        b. y_train.txt - contains integer values for activities
        c. subject_tain.txt - contains subject numbers
        
    - Test group
    
        a. X_test.txt
        b. y_test.txt
        c. subject_test.txt
        
    Variable names and activity labels where stored in separated files:

        - features.txt (variable names)
        - avtivity_labels.txt
    
    
STEP 1 Merge Data

    Data in each group (train, test) was merged by columns
    
        trainSet and testSet were made by column binding subject, activity and variable values read from the respective train and test files
        
    A complete dataSet was made by row binding the train and test sets
    
    Resulting dataSet contains the following columns:
    
        - Subject Number
        - Activity Integers
        - 560 Features and their respective numeric values
    
    
STEP 2 Assign Descriptive Variable Names

    Symbols such as '(', ')', ',' and '-' were replaced by "_"
    
    The "BodyBody" string was replaced by correct "Body" string
    
    The "meanFreq" string was replaced by "Freq" to facilitate data subsetting
    
    Names for the varibles of interest included:
    
        Original                    Modified
        
        tBodyAcc-XYZ*               tBdAc_XYZ
        tGravityAcc-XYZ             tGrAc_XYZ
        tBodyAccJerk-XYZ            tBdAcJk_XYZ
        tBodyGyro-XYZ               tBdGy_XYZ
        tBodyGyroJerk-XYZ           tBdGyJk_XYZ
        tBodyAccMag                 tBdAcM
        tGravityAccMag              tGrAcM
        tBodyAccJerkMag             tBdAcJkM
        tBodyGyroMag                tBdGyM
        tBodyGyroJerkMag            tBdGyJkM
        fBodyAcc-XYZ                fBdAc_XYZ
        fBodyAccJerk-XYZ            fBdAcJk_XYZ
        fBodyGyro-XYZ               fBdGy_XYZ
        fBodyAccMag                 fBdAcM
        fBodyAccJerkMag             fBdAcJkM
        fBodyGyroMag                fBdGyM
        fBodyGyroJerkMag            fBdGyJkM
        
        *where X, Y or Z denotes the direction of the 3-axial signal
        t denotes signal in time domain
        f denotes fast fourier transform of time signal
        
    Modifications include:
        
        Body -> Bd - for body signals
        Acc -> Ac - for accelerometer signals
        Gravity -> Gr - for gravity signals
        Gyro -> Gy - for gyroscope signals
        Jerk -> Jk - for jerk signals from both Acc and Gyro
        Mag -> M - for signal magnitude obtained from euclidean norm
        
    Example:
    
        tBodyAccJerk-std()-Y  ->  tBdAcJk_std_Y 
        
    Column names of combined dataSet are replaced by "Subject", "Activity", and the modified variable names
        
        
STEP 3 Extract variables with the mean and standar deviation values for the signals

    Grep function is used to extract variable names with "mean" or "std" strings present
    
    Previous modifications prevent extraction of "meanFreq" containing variables
    
    
STEP 4 Arrange data and properly name activities

    Arrange function is used to order data by Subject and Activity
    
    Activity labels are read and converted to lower case
    
    Integer values for activities in the dataSet are converted to characters
    
    Activity values are replaced by activity labels as follows:
        
        "1" -> "walking"
        "2" -> "walking_upstairs"
        "3" -> "walking_downstairs"
        "4" -> "sitting"
        "5" -> "standing"
        "6" -> "lying" (laying typo present in original file)
        
        
STEP 5 Generate a second data set with the average of each variable grouped by activity and subject

    Group_by function is used to prepare data set for calculating the mean of the trials for each variable at each activity by subject
    
    Summarise_each is used to calculate the mean value for each variable
    
    Mean values are rounded to 8 decimal places to eliminate noise
    
    This data set is stored in "dataMeans.txt" file with header