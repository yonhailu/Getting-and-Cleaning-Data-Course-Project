if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

## unzip 

unzip("C:/Users/Yonathan/Desktop/Coursera/data/dataset.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = ".", unzip = "internal", setTimes = FALSE)

unzip(zipfile="C:/Users/Yonathan/Desktop/Coursera/data/dataset.zip", exdir="./data")
list.files("UCI HAR Dataset")
path_runa <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_runa, recursive=TRUE)
files

##Merging the training and the test sets 

# Reading trainings tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

##Assigning column names

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activity"
colnames(subject_train) <- "subject"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activity"
colnames(subject_test) <- "subject"

colnames(activityLabels) <- c('activity','activityType')

## mergin all data 

mergetrain <- cbind(y_train, subject_train, x_train)
mergetest <- cbind(y_test, subject_test, x_test)
mergetraintest <- rbind(mrg_train, mrg_test)

##Extracts only the measurements on the mean and standard deviation for each measurement

colNames <- colnames(mergetraintest)

meanandstd <- (grepl("activity" , colNames) | 
                   grepl("subject" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

datasetmeanandstd <- mergetraintest[ , mean_and_std == TRUE]

## labeling the activities
datasetActivityNames <- merge(datasetmeanandstd, activityLabels,
                              by='activity',
                              all.x=TRUE)

## Creating another tidy data independent tidy data set with the average of each variable for each activity and each subject.

TidySet <- aggregate(. ~subject + activity, datasetActivityNames, mean)
TidySet <- TidySet[order(TidySet$subject, TidySet$activity),]

write.table(TidySet, "TidySet.txt", row.name=FALSE)

