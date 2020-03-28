library(dplyr)

features <- read.table("features.txt", col.names = c("n","functions"))
activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features$functions)
y_test <- read.table("test/y_test.txt", col.names = "code")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features$functions)
y_train <- read.table("train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)
  
TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

TidyData$code <- activities[TidyData$code, 2]



Solution <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean))
write.table(Solution, "solution.txt", row.name=FALSE)

