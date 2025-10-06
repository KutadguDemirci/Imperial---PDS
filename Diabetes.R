############################
# Introduction to Data Analysis in R
############################

# Welcome to our first week's code examples. 

# We provide a brief example of using R to do data analysis.
# We shall be looking at the well known Pima Indians Diabetes dataset.

# You may view this dataset at:
# https://archive.ics.uci.edu/ml/datasets/diabetes
# or:
# https://www.kaggle.com/uciml/pima-indians-diabetes-database

# We have downloaded it already for you as a csv file called 'DiabetesData.csv'. 

# The first step is to read in the data. 
# We shall store it in an object called ds_diabetes (where ds stands for dataset).
# The top row of the dataset has column headings, hence we set header=T.
ds_diabetes = read.csv(file = 'DiabetesData.csv', sep=",", header = T)

# Evaluate if that worked by printing the first 6 lines of the data set with the following command.
head(ds_diabetes)

# Data types - this is a "data frame", a list-like object with a tabular structure.
str(ds_diabetes)

# Let us create some plots using the "$" operator to select specific columns of the data frame.
hist(ds_diabetes$pregnant, xlab = "Pregnant", main="Histogram of variable pregnant")
hist(ds_diabetes$glucose, xlab = "Glucose", main="Histogram of variable glucose")

# Note that when using the freq=FALSE argument, then the histogram is not a percentage, 
# it is  normalized (so the total area is equal to 1).
hist(ds_diabetes$glucose, xlab = "Glucose", main="Histogram of normalized variable glucose", freq=F)

# Scatterplot of two variables.
plot(ds_diabetes$glucose,ds_diabetes$pressure, main= "Scatterplot",xlab="Glucose", ylab="Pressure")

# Quick evaluation of the response variable using a frequency table.
ftable(ds_diabetes$diabetes)

# To evaluate statistics of all variables at once, use "summary".
# Note, different quantities evaluated for different types of data.
summary(ds_diabetes)

# Missing values are present! That is a problem we will ignore for now, and simply replace missing values with zero.

# To replace NA's with zero we create a new object called ds_diabetes2 and replace NA's with zeroes.
ds_diabetes2 = ds_diabetes
ds_diabetes2[is.na(ds_diabetes2)] = 0

# Let's see if that worked using the summary function again
summary(ds_diabetes2)

# There is one more issue to resolve.
# The response variable, which is diabetes, is a character string.
# As far as R is concerned this means there are as many possible outcomes as there are unique strings.
# However there are only 2 outcomes, namely "POS" and "NEG".
# We convert the Diabetes column to a factor which will resolve this issue
ds_diabetes2$diabetes = as.factor(ds_diabetes2$diabetes)

# Now our data is adequate for our needs, let's move on to the modeling part!

############################
## Logistic regression - can we predict whether an individual is diabetic? 
############################

# Split the data into test and training data.
# The training data is used to fit the logistic regression model. 
# The test data is used to calculate predictions and accuracy measures for evaluating the model. 

train = ds_diabetes2[1:700,] # select the first 700 observations for training
test = ds_diabetes2[701:768,] # select the last 68 observations for testing

model = glm(diabetes ~.,family=binomial(link='logit'), data=train)

# Evaluate model - do not worry about what the output means now, that will be addressed in later modules.
# You might have a (slightly) different result in python due to the optimization procedure.
summary(model)

# Prediction  - this computes the probability that an individual is diabetic.
fitted = predict(model,newdata=test,type='response')

# Let us see what the predictions are. The predictions are not binary!
fitted

# Add a threshold and transform it to binary predictions.
threshold = 0.5
fitted = ifelse(fitted > threshold,1,0)

## Compute accuracy and confusion matrix. First transform the test factor to numeric and subtract 1. 
# This converts the output to either 0 or 1.
test_numeric = as.numeric(test$diabetes)-1

# Evaluate the average classification error (the average over all wrong classifications). 
# The operator != evaluates which elements are different element-wise.
misclass = mean(fitted != test_numeric) 
print(paste('Accuracy',1-misclass))

# Confusion matrix 
table(fitted,test_numeric)

