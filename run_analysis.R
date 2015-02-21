# Reading data
train_subject  <-  read.table("./train/subject_train.txt", stringsAsFactors=FALSE)
train_data     <-  read.table("./train/X_train.txt", stringsAsFactors=FALSE)
train_activity <-  read.table("./train/Y_train.txt", stringsAsFactors=FALSE)
test_subject   <-  read.table("./test/subject_test.txt", stringsAsFactors=FALSE)
test_data      <-  read.table("./test/X_test.txt", stringsAsFactors=FALSE)
test_activity  <-  read.table("./test/Y_test.txt", stringsAsFactors=FALSE)

#selecting only columns with mean or std information
features <- read.table("features.txt")[,2]
good_columns <- grep("mean|std", features)
train_data <- train_data[, good_columns]
test_data <- test_data[, good_columns]

# Sanity check that the dimensions match
if ((dim(train_subject)[2][1]!= 1)  | (dim(train_activity)[2][1]!= 1))
  print("Train data size error- subject and activity should be a column vector")
if ((dim(test_subject)[2][1]!= 1)  | (dim(test_activity)[2][1]!= 1))
  print("Test data size error- subject and activity should be a column vector")
train_nrow <- dim(train_data)[1][1]
if ((dim(train_subject)[1][1]!= train_nrow)  | (dim(train_activity)[1][1]!= train_nrow))
  print("Train data size error- mismatch of number of rows")
test_nrow <- dim(test_data)[1][1]
if ((dim(test_subject)[1][1]!= test_nrow)  | (dim(test_activity)[1][1]!= test_nrow))
  print("Test data size error- mismatch of number of rows")

#combining subject, activity and data
train_total <- cbind(train_subject, cbind(train_activity, train_data))
test_total  <- cbind(test_subject, cbind(test_activity, test_data))

#combining training and test data and sorting it according to subject and activity
all_data <- rbind(train_total, test_total)
all_data_sorted <- all_data[ order(all_data[,1], all_data[,2]), ]

#adding columns name
col_names <- c(c("subjectID", "activity"), as.character(features[good_columns]))
colnames(all_data_sorted) <- col_names

#replacing activity number by a string
activities <- c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting","Standing","Laying")
for (i in 1:nrow(all_data_sorted)){
  all_data_sorted[i,2] <- activities[as.numeric(all_data_sorted[i,2])]
}

#grouping by subjectID and activities and calculate the means using dplyr
gb <- group_by(all_data_sorted,subjectID, activity)
summary_table <- gb %>% summarise_each(funs(mean))

#updating columns name to reflect that these are the averages
for (i in 3:length(col_names)){ col_names[i] = paste("mean[",col_names[i],"]")}
colnames(summary_table) <- col_names

#saving the table
write.table(summary_table, "summary_table.txt",row.name=FALSE, sep = "\t")

