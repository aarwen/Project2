## You should create one R script called run_analysis.R that does the following.

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## 0. read to order txt files from directory

# read features to be used as column names for the X-values of train and test data set
features <- read.table("./features.txt", col.names = c("featureid", "feature"))

# read labels to be allocated to the Y-values of train and test data set
labels <- read.table("./activity_labels.txt", col.names = c("activitylabelid", "activitylabel"))

# read data from both data sets
# use same column name as it will be combined later
# use factor type because it classifies the people
train <- read.table("./train/subject_train.txt", col.names = "subject", colClasses = "factor")
test <- read.table("./test/subject_test.txt", col.names = "subject", colClasses = "factor")

# read activity lables from both data sets
# use same column name as it will be combined later; the column contains the activitylabelid from the previously built data.frame
# use factor type because it classifies the 6 different activity labels
Ytrain <- read.table("./train/Y_train.txt", col.names ="activitylabelid", colClasses ="factor")
Ytest <- read.table("./test/Y_test.txt", col.names ="activitylabelid", colClasses ="factor")

# read the set of 561 variables estimated from the inertial signals (X-values for both data sets
# use same column names as it will be combined later; the columns correspond to the 561 feature stored previously in the respective data.frame
Xtrain <- read.table("./train/X_train.txt", col.names = features$feature)
Xtest <- read.table("./test/X_test.txt", col.names = features$feature)


## 1. Merge the training and the test sets to create one data set.

# basically rbind the three sets containing training and test data: X, Y, and subject

all <- rbind(train, test)
Yall <- rbind(Ytrain, Ytest)
Xall <- rbind(Xtrain, Xtest)

# Since this is 'one data frame', then we do one more cbind
# Putting all acvities at the end.

Grandall <- cbind(Xall, all, Yall)


## 2. Extract only the measurements on the mean and standard deviation for each measurement.

# now we for "mean()" and "std()"
# extracting means and stddevs seperately 
# Then adding it to a new list called "new", containing means and std. dev

allmeans <- grep("mean()", features$feature, fixed = TRUE)
allstds <- grep("std()", features$feature, fixed = TRUE)
new <- sort(c(allmeans,allstds))

# subset the whole data set "Xall" with the selected column numbers, and cbind 

Xallmeanstd <- Xall[,new]
allmeanstd <- cbind(Xallmeanstd, all, Yall)


## 3. Uses descriptive activity names to name the activities in the data set

# merge both (column names have been chosen identically), and drop the id

allmeanstdact <- merge(allmeanstd, labels)
allmeanstdact$activitylabelid <- NULL

## 4. Appropriately label the data set with descriptive activity names.

# Applying in all underscores

labels$activitylabel <- sub("_","",labels$activitylabel)
labels$activitylabel <- tolower(labels$activitylabel)


## 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

# split the data.frame into 180 groups
u <- split(allmeanstdact, list(allmeanstdact$activitylabel, allmeanstdact$subject))

# calculate column Means for each group and put it back as --> as.data.frame and transpose

avg <- as.data.frame(t(sapply(u, function(allmeanstdact) colMeans(allmeanstdact[,1:66]))))

# restore activity labels as first column, subject in second column, and delete row names

avg <- cbind(row.names(avg), row.names(avg), avg[,1:66])
names(avg)[1:2] <- c("activity", "subject")
avg$activity <- sub("[.][0-9]+","",avg$activity)
avg$subject <- sub("[a-z]+[.]","",avg$subject)
avg$subject <- as.numeric(avg$subject)
avg <- avg[order(avg$activity, avg$subject),]
row.names(avg) <- NULL


## using the package to generate a png-file

library(gridExtra)
png("avg.png", height = 5000, width = 10000)
grid.table(avg)
dev.off()