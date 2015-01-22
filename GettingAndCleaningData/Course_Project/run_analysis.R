#Set your working directory
setwd("C:\\Users\\aoberoi\\Desktop\\Coursera\\Getting and Cleaning Data\\Project\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset")
### START OF STEP 1
#1.Read subject_id data(train) which is contined in train/subject_train.txt,into data frame
train_subject_id<-read.table("./train/subject_train.txt", header = FALSE,na.strings="N/A")

#2.Read subject data(test) which is contined in test/subject_train.txt,into data frame
test_subject_id<-read.table("./test/subject_test.txt", header = FALSE,na.strings="N/A")

#3.Combine the test and train datasets for subject_id into 1 using row binding,into data frame
subject_id<-rbind.fill(train_subject_id,test_subject_id)

#4.Read activity data(train) which is contined in train/y_train.txt,into data frame
train_activity<-read.table("./train/y_train.txt", header = FALSE,na.strings="N/A")

#5.Read activity data(test) which is contined in test/y_test.txt,into data frame
test_activity<-read.table("./test/y_test.txt", header = FALSE,na.strings="N/A")

#6.Combine the test and train datasets for Activity into 1 using row binding,into data frame
activity<-rbind.fill(train_activity,test_activity)

#7.Read features data(train) which is contined in train/X_train.txt,into data frame
train_feature<-read.table("./train/X_train.txt", header = FALSE,na.strings="N/A")

#8.Read features data(test) which is contined in test/X_test.txt,into data frame
test_feature<-read.table("./test/X_test.txt", header = FALSE,na.strings="N/A")

#9.Combine the test and train datasets for 561 features into 1 using row binding,into data frame
feature<-rbind.fill(train_feature,test_feature)

#10.Change column names for subjectId and Activity columns
names(subject_id) <- "sid"
names(activity) <- "activity"

#11.Combine the SubjectId,Activity and features into 1 data frame using column binding.
data<-cbind(subject_id,activity,feature)

#12.Retrieve and Assign column names to features from features.txt.The data frame "data" now has slightly descriptive column names.

feature_names<-read.table("./features.txt", header = FALSE,na.strings="N/A")
names<-feature_names[,2]
names<-as.character(names)
names(data)<-c("SubjectId","Activity",names)
### END OF STEP 1


### START OF STEP 2
#13.Extract columns with mean or std as column name and create a new data frame with these reduced features.
indices<-grep("mean|std",names(data))
new_data<-data[,c(1,2,indices)]

### END OF STEP 2

###START OF STEP 3
#14.To provide descriptive labels for activities,we need to read the activty labels from a file "activity_labels.txt" and substitute these values in data frame:
#e.g need to replace activity = 1 with WALKING.We set the 2nd column of the data fram i.e activity to values read from the text file.
activity_list<-read.table("./activity_labels.txt", header = FALSE,na.strings="N/A")
new_data[,2]<-activity_list[new_data[,2],2]

### END OF STEP 3

###START OF STEP 4
#15.To provide descriptive names:
#a)Remove parentheses from the column names of data frame
#b)Replace "-" with "." which is acceptable 
names(new_data)<-gsub("\\(|)","",names(new_data))
names(new_data)<-gsub("-",".",names(new_data))

###END OF STEP 4

###START OF STEP 5
#16.Since we need to summarize the averages of the features as per subjectId and activity,
#a)Group data frame by SubjectId and Activity
#b)summarize all the non-grouped data i.e find their average/arithmetic mean and store in a new data frame i.e tidy_data.
grouped_data<-group_by(new_data,SubjectId,Activity)
tidy_data<-summarise_each(grouped_data,funs(mean))

###END OF STEP 5
#Write data
write.table(tidy_data,file="./tidy_data.txt",row.names = FALSE)

#To read back the data for reference
td<- read.table("./tidy_data.txt", header = TRUE)

#Thus a tidy data set has been created.


