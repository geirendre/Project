##
# Run from the directory containing the "UCI HAR Dataset" directory.
setwd("UCI HAR Dataset")
library(plyr)

trainX <- read.table("train/X_train.txt")
trainY <- read.table("train/y_train.txt")
trainSubject <- read.table("train/subject_train.txt")

# Merges the data sets.
testX <- read.table("test/X_test.txt")
testY <- read.table("test/y_test.txt")
testSubject <- read.table("test/subject_test.txt")
# rowbind x-datasets
dataX <- rbind(trainX, testX)
# rowbind y-datasets
dataY <- rbind(trainY, testY)
# rowbind Subject-dataset
subject_data <- rbind(trainSubject, testSubject)

# Read in and clean up the coloumn names
features <- read.table("features.txt")
features[,-1] <- (gsub("-mean", "Mean", (features[,-1])))
features[,-1] <- (gsub("-std", "StdDev", (features[,-1])))
features[,-1] <- (gsub("^t", "Time", (features[,-1])))
features[,-1] <- (gsub("^f", "Frequency", (features[,-1])))
features[,-1] <- (gsub("BodyBody", "Body", (features[,-1])))
features[,-1] <- (gsub("\\(", '', (features[,-1])))
features[,-1] <- (gsub("\\)", '', (features[,-1])))
features[,-1] <- (gsub("-", "", (features[,-1])))

# 2.  Extracts only the measurements on the mean and standard deviation for each measurement.
mean_and_std_features <- grep("Mean|StdDev", features[, 2])
dataX <- dataX[, mean_and_std_features]
names(dataX) <- features[mean_and_std_features, 2]


# 3.  Uses descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
dataY[, 1] <- activities[dataY[, 1], 2]
names(dataY) <- "activity"


# 4.  Appropriately labels the data set with descriptive variable names.
names(subject_data) <- "subject"
# coloumnbind X, Y and subject
all_data <- cbind(dataX, dataY, subject_data)


# 5.  From the data set in step 4, creates a second, 
#     independent tidy data set with the average of each 
#     variable for each activity and each subject.
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

# CD back into the parent directory and write the two datasets to txt files.
setwd("..")
write.table(all_data, "all_data.txt", row.name=FALSE)
write.table(averages_data, "averages_data.txt", row.name=FALSE)
# Tidying of data completed