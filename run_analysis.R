run_analysis <- function() {
    
    library(dplyr)
    
    ## Read train set files
    
    trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
    
    trainMeasure <- read.table("./UCI HAR Dataset/train/X_train.txt")
    
    trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt")
    
    
    ## Join train set 
    
    trainSet <- cbind(trainSubject, trainActivity, trainMeasure)
    
    
    ## Read test set files
    
    testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
    
    testMeasure <- read.table("./UCI HAR Dataset/test/X_test.txt")
    
    testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt")
    
    
    ## Join test set
    
    testSet <- cbind(testSubject, testActivity, testMeasure)
    
    
    ## Join data sets
    
    dataSet <- rbind(trainSet, testSet)
    
    
    ## Read variable names
    
    measures <- read.table("./UCI HAR Dataset/features.txt")
    
    measures <- measures[, 2]
    
    
    ## Reformat variable names
    
    measures <- gsub("[(),-]", "_", measures)
    
    measures <- gsub("_+", "_", measures)
    
    measures <- gsub("_$", "", measures)
    
    measures <- gsub("BodyBody", "Body", measures)
    
    measures <- gsub("meanFreq", "Freq", measures)
    
    measures <- gsub("Body", "Bd", measures)
    
    measures <- gsub("Gravity", "Gr", measures)
    
    measures <- gsub("Acc", "Ac", measures)
    
    measures <- gsub("Gyro", "Gy", measures)
    
    measures <- gsub("Jerk", "Jk", measures)
    
    measures <- gsub("Mag", "M", measures)
    
    
    ## Replace variable names in dataSet
    
    names(dataSet) <- c(c("Subject", "Activity"), measures)
    
    
    ## Subset data for mean and standard deviation measures
    
    subsetMeasures <- measures[grep("mean|std", measures)]
    
    subsetNames <- c(c("Subject", "Activity"), subsetMeasures)
    
    tidyData <- dataSet[, subsetNames]
    
    
    ## Arrange data and properly name activities
    
    tidyData <- arrange(tidyData, Subject, Activity)
    
    activityName <- read.table("./UCI HAR Dataset//activity_labels.txt")
    
    activityName <- tolower(as.character(activityName[, 2]))
    
    tidyData$Activity <- as.character(tidyData$Activity)
    
    activity <- tidyData$Activity
    
    for(i in 1:length(activity)) {
        
        if(activity[i] == "1") {
            
            activity[i] <- activityName[1]
        
        }   
        
        else if(activity[i] == "2") {
                
            activity[i] <- activityName[2]
            
        }   
        
        else if(activity[i] == "3") {
                    
            activity[i] <- activityName[3]
                
        }   
        
        else if(activity[i] == "4") {
                        
            activity[i] <- activityName[4]
                    
        }   
        
        else if(activity[i] == "5") {
                        
            activity[i] <- activityName[5]
                    
        }   
        
        else activity[i] <- "lying"
        
    }
    
    tidyData$Activity <- activity  ## assigns correct activity values
    
    
    ## Generate tidy data with mean for each measure by Subject and Activity
    
    dataMeans <- group_by(tidyData, Activity, Subject)
    
    dataMeans <- summarise_each(dataMeans, funs(mean))
    
    
    ## Round data to 10 decimal places
    
    dataMeans[, 3:68] <- round(dataMeans[, 3:68], 8)
    
    
    ## Write tidy data to file
    
    write.table(dataMeans, file = "./CleanDataProject/dataMeans.txt", row.name = FALSE)
    
    dataMeans  ## returns tidy data set with grouped means
}