# Introduction
This document describes the script run_analysis.R that is used to create a tidy data from the data provided in 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

The scripts start by  reading the data of a training set and a test set. Each set contains  list of subjects, activities and different 
measurements that were obtained by processing a sampled data during that activity.
As required in the problem, the script only select columns that are related to mean and standard deviation. It does this by identifying
the column names with the either the string "mean" or "std" using the grep command.

The script then performs some sanity check to make sure that the dimensions of the activity, subject and measurement list are compatible.
It then combines the information about the subject, activity and the measurements into one data set.
It then combines the two data sets for training and test into one big data set.
Then the script modifies the activity column and instead of using numbers, it uses a more intuitive descption of activity like "walking", 
"laying", etc.
In addition, a header is added to each columns with the description of the data in this column.

The next step in the script is creating a new tidy dataset based on the original one. This is done using the dplyr package using the group_by and
summarise_each command. For each subjectId and activity, the mean for each column is computed. 
The script also updates the new header for the columns and replace each variable name xx by a new name mean[xx].

Finally, the resulting tidy data is save to a file.  