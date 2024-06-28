data <- read.csv("responses.csv")
str(data)
# Shorted output 
# 'data.frame':	3378 obs. of  31 variables:
# $ Age.group                                         : chr  "0-18" "0-18" "0-18" "19-24" ...
# $ broken.a.bone                                     : chr  "False" "False" "False" "False" ...
# $ been.on.the.radio.or.television                   : chr  "True" "False" "False" "False" ...
# $ gotten.a.speeding.ticket                          : chr  "False" "False" "False" "False" ...

# As we can see our target variable (Age) contains different age droups
# Independent variables are binary but they are written as char format
# The next step we need to do is:
# 1. to pick a certain age group we are interested in and transform to (1,0)
# 2. Tranform independent var. to (1,0) according to (True, False)

data$Age.group <- ifelse(data$Age.group == "0-18", 0, 1)

# Now all records above 18 are written as 1, below as 0

install.packages("dplyr")
library(dplyr)

# Convert "True" and "False" to 1 and 0 for all columns except 'Age.group'
df_transformed <- data %>%
  mutate(across(-Age.group, ~ ifelse(. == "True", 1, ifelse(. == "False", 0, .))))

str(df_transformed)
df_transformed <- df_transformed %>% mutate(across(everything(), as.numeric))
str(df_transformed)
# Now all records transforment into binary format
# We have some missing values, but in this case we are going to apply
# XGBoost model which can deal with missing values by its own

# Train/Test split
install.packages("caTools")
library(caTools)
split <- sample.split(df_transformed$Age.group, SplitRatio = 0.75)

train <- subset(df_transformed, split == TRUE)
test <- subset(df_transformed, split == FALSE)

y_train <- train$Age.group
y_test <- test$Age.group

X_train <- as.matrix(train[, 2:ncol(train)])
X_test <- as.matrix(test[, 2:ncol(train)])

# Parameters 
params <- list(eta = 0.3,
               max_depth = 6,
               subsample = 1,
               colsample_bytree = 1,
               min_child_weight = 1,
               gamma = 0,
               eval_metric = "auc",
               objective = "binary:logistic",
               booster = "gbtree")

install.packages("xgboost")  
library(xgboost)  
model <- xgboost(data = X_train,
                 label = y_train,
                 nround = 50,
                 params = params,
                 varbose = 1)  
  
pred = predict(model, newdata = X_test)
pred = ifelse(pred > 0.5, 1, 0)

install.packages("caret")
library(caret)
confusionMatrix(table(pred, y_test))

# Output confusion metrix

# y_test
# pred   0   1
# 0  57  59
# 1 140 589

# Accuracy : 0.7645          
# 95% CI : (0.7344, 0.7927)
# No Information Rate : 0.7669          
# P-Value [Acc > NIR] : 0.5833  

# The most important components 
xgb.plot.shap(data = X_test,
              model = model,
              top_n = 3)

