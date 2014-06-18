Instructions:
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

 You should create one R script called run_analysis.R that does the following. 

    1. Merges the training and the test sets to create one data set.
    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    3. Uses descriptive activity names to name the activities in the data set
    4. Appropriately labels the data set with descriptive variable names. 
    5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    
Data: 
The following files are available for the train and test data. Their descriptions are equivalent.
1.'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
2.'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.
3.'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration.
4. 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.



How run_analysis.R implements the above steps:

    Load both test and train data
    Load the features and activity labels.
    The merging of the training and the test sets consists basically of binding them by row (rbind) i.e. subjects, Y-values, and X-values. 
    Given 'one data set' means 'one data frame', one has to put together those three objects by column and do cbind
    Extract the mean and standard deviation separately and adding to a new list 'new'.
    These are 33 of each. It results in a list called "new", containing the numbers of the selected columns, i.e. 33 means and 33 stddevs. This list is used for subsetting the original data set, hence reducing the data columns from 561 to 66.
    Till now the activities are coded by there ID in the second last column of the data.frame containing the subsetted data.
    Now both are merged (by default by id as column names have been chosen identically), and then id is dropped
    Process and clean the data for lower cases. 
    This data.frame is finally given to a graphical output file using the gridExtra package.
