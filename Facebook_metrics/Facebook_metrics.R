# First of all we need to set our data and correct delimiter to read it
data <- read.csv("dataset_Facebook.csv", sep = ";")

install.packages("dplyr")
library(dplyr)

dataset <- data %>% select(Lifetime.Post.Total.Impressions,
                           Page.total.likes,
                           Type,
                           Post.Weekday,
                           Paid,
                           comment,
                           like,
                           share)

# Lets take a quick look at data we have just selected 
str(dataset)

# Output 
# 'data.frame':	500 obs. of  8 variables:
# $ Lifetime.Post.Total.Impressions: int  5091 19057 4373 87991 13594 20849 19479 24137 22538 8668 ...
# $ Page.total.likes               : int  139441 139441 139441 139441 139441 139441 139441 139441 139441 139441 ...
# $ Type                           : chr  "Photo" "Status" "Photo" "Photo" ...
# $ Post.Weekday                   : int  4 3 3 2 2 1 1 7 7 6 ...
# $ Paid                           : int  0 0 0 1 0 0 1 1 0 0 ...
# $ comment                        : int  4 5 0 58 19 1 3 0 0 3 ...
# $ like                           : int  79 130 66 1572 325 152 249 325 161 113 ...
# $ share                          : int  17 29 14 147 49 33 27 14 31 26 ...

# Change datatype for two features 
dataset$Type <- as.factor(dataset$Type)
dataset$Post.Weekday <- as.factor(dataset$Post.Weekday)

# Log transformation to balance values 
dataset$Lifetime.Post.Total.Impressions <- log(dataset$Lifetime.Post.Total.Impressions)
dataset$Page.total.likes <- log(dataset$Page.total.likes)

# Liniar regression model
model <- lm(Lifetime.Post.Total.Impressions ~ .,
            data = dataset)
summary(model)

# Output
# Residuals:
# Min      1Q  Median      3Q     Max 
# -3.1334 -0.5372 -0.1618  0.3039  3.9788 

#Coefficients:
#  Estimate Std. Error t value Pr(>|t|)    
#(Intercept)      26.1351131  3.6490642   7.162 3.00e-12 ***
#  Page.total.likes -1.4507850  0.3124641  -4.643 4.44e-06 ***
#  TypePhoto        -0.3060504  0.2095949  -1.460  0.14489    
# TypeStatus        0.6627662  0.2533574   2.616  0.00918 ** 
#  TypeVideo         1.6575119  0.4223941   3.924 9.98e-05 ***
# Post.Weekday2     0.2687267  0.1656505   1.622  0.10541    
# Post.Weekday3     0.1218099  0.1676624   0.727  0.46787    
# Post.Weekday4     0.3723387  0.1639357   2.271  0.02357 *  
# Post.Weekday5     0.0074021  0.1663019   0.045  0.96452    
# Post.Weekday6     0.0269356  0.1583264   0.170  0.86498    
# Post.Weekday7    -0.0731670  0.1577847  -0.464  0.64306    
# Paid              0.2575168  0.0976203   2.638  0.00861 ** 
#  comment          -0.0051171  0.0042133  -1.215  0.22515    
#like              0.0028977  0.0003282   8.829  < 2e-16 ***
# share            -0.0080919  0.0027582  -2.934  0.00351 ** 
# ---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# Residual standard error: 0.9494 on 480 degrees of freedom
# (5 observations deleted due to missingness)
# Multiple R-squared:  0.3593,	Adjusted R-squared:  0.3406 
# F-statistic: 19.23 on 14 and 480 DF,  p-value: < 2.2e-16

# Conclusion:
# 1. Post types (Status and videos) staticticaly have the biggest impact
# 2. Share has negative impact with statistical significance
# 3. Like has positive impact with strong statistical significance
# 4. Day 4 is the best with p value less that alhpa