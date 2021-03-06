

training <- read.csv("pml-training.csv", header=TRUE)
testing <- read.csv("pml-test.csv", header=TRUE)
library(caret)
library(randomForest)
library(plyr)
options(warn=-1)

# Load and Clean the data -------------------------------------------------

testing <- subset(testing, select=-c(1:7))
training <- subset(training, select=-c(1:7))
threshold_val <- 0.95 * dim(training)[1]

include_cols <- !apply(training, 2, function(y) sum(is.na(y)) > threshold_val || sum(y=="") > threshold_val)
training <- training[, include_cols]
nearZvar <- nearZeroVar(training, saveMetrics = TRUE)
training <- training[ , nearZvar$nzv==FALSE] 
dim(training)

# modeling ----------------------------------------------------------------

set.seed(32233)
inTrain = createDataPartition(training$classe, p = 0.7, list=FALSE)
train1A <- training[inTrain,]
train2A <- training[-inTrain,]

randomForMod <- randomForest(classe~., data=train1A, importance=TRUE)
randomForMod

train2A_pred <- predict(randomForMod, newdata=train2A)
#  Confusion Matrix here :
confusionMatrix(train2A_pred, train2A$classe)
# Testing the model on the 'testing' dataset
testing_pred <- predict(randomForMod, newdata=testing)
testing_pred

