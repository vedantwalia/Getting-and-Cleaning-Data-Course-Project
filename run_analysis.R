library(plyr)
library(dplyr)
library(tidyr)

testX <- read.table("test/X_test.txt")
testY <- read.table("test/y_test.txt")
testS <- read.table("test/subject_test.txt")

trainX <- read.table("train/X_train.txt")
trainY <- read.table("train/y_train.txt")
trainS <- read.table("train/subject_train.txt")
flabels <- read.table("features.txt")
alabels <- read.table("activity_labels.txt")

trainS <- mutate(trainS, Class = "train")
testS <- mutate(testS, Class = "test")

xAll <- bind_rows(trainX, testX)
yAll <- bind_rows(trainY, testY)
sAll <- bind_rows(trainS, testS)

colnames(xAll) <- flabels$V2
colnames(yAll) <- c("Activity")
colnames(sAll) <- c("Subject", "Class")

all <- bind_cols(xAll, yAll, sAll)
all_t <- tbl_df(all)
rm(all)


valid_column_names <- make.names(names=names(all_t), unique=TRUE, allow_ = TRUE)
names(all_t) <- valid_column_names


all_t <- all_t %>%
  select(Class, Subject, Activity, contains(".mean."), contains(".std.")) %>%
  mutate(Activity = factor(Activity, labels = alabels$V2)) %>%
  gather(Measurement, Meas_val, -(Class:Activity)) %>%
  separate(Measurement, c("Feature_Variable", "Stat_Type", "Axis"))

tidy_dataset <- all_t %>%
  group_by(Subject, Activity, Feature_Variable, Stat_Type, Axis) %>%
  summarize(Avg_val = mean(Meas_val)) %>%
  spread(Stat_Type, Avg_val) %>%
  rename("Mean" = mean, "Std" = std)


write.table(tidy_dataset, "SummaryDataset.txt", row.names=FALSE)

