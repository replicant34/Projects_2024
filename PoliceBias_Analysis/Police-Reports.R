# The Dataset for this analysis was upload into a package carData
install.packages("carData")
library(carData)
df <- MplsStops

# Once dataset is retrieved, we can take a look at the summary and the structure 
summary(df)

# Outpur Summary
# idNum            date                              problem         MDC       
# 17-000003:    1   Min.   :2017-01-01 00:00:42.00   suspicious:25822   MDC  :43699  
# 17-000007:    1   1st Qu.:2017-03-29 08:35:09.00   traffic   :26098   other: 8221  
# 17-000073:    1   Median :2017-06-17 18:46:47.00                                   
# 17-000092:    1   Mean   :2017-06-23 19:57:49.73                                   
# 17-000098:    1   3rd Qu.:2017-09-18 18:32:06.75                                   
# 17-000111:    1   Max.   :2017-12-31 23:52:35.00                                   
# (Other)  :51914                                                                    
# citationIssued personSearch vehicleSearch            preRace                race      
# NO  :15899     NO  :38462   NO  :40579    Unknown        :28337   Black       :15220  
# YES : 3211     YES : 5237   YES : 3120    Black          : 6805   White       :11703  
# NA's:32810     NA's: 8221   NA's: 8221    White          : 6004   Unknown     : 9219  
#                                           Native American:  908   East African: 2188  
#                                           Latino         :  528   Latino      : 1858  
#                                           (Other)        : 1117   (Other)     : 3511  
#                                           NA's           : 8221   NA's        : 8221  
#     gender           lat             long        policePrecinct         neighborhood  
# Female :10015   Min.   :44.89   Min.   :-93.33   Min.   :1.000   Downtown West: 4409  
# Male   :27131   1st Qu.:44.95   1st Qu.:-93.29   1st Qu.:2.000   Whittier     : 3328  
# Unknown: 6492   Median :44.98   Median :-93.28   Median :3.000   Near - North : 2256  
# NA's   : 8282   Mean   :44.97   Mean   :-93.27   Mean   :3.257   Lyndale      : 2154  
# 3rd Qu.:45.00   3rd Qu.:-93.25   3rd Qu.:4.000   Jordan       : 2075  
# Max.   :45.05   Max.   :-93.20   Max.   :5.000   Hawthorne    : 2031  
# (Other)      :35667  

# because the objective of this study is to discover if there is any systematic 
# bias in the police presiders toward to certain group.
# Summary reveals that Black people being pulled over more frequently than others
# As well as males are being pulled over 3 times more often than females 
# However at this stage we are not able to make any conclusion due to there are 
# may be different factors related to this statistic.

str(df)

# Output structure 

# 'data.frame':	51920 obs. of  14 variables:
#   $ idNum         : Factor w/ 61212 levels "16-395258","16-395296",..: 6823 
# $ date          : POSIXct, format: "2017-01-01 00:00:42" "2017-01-01 00:03:07" 
# $ problem       : Factor w/ 2 levels "suspicious","traffic": 1 1 2 1 2 2 1 2 2 2 ...
# $ MDC           : Factor w/ 2 levels "MDC","other": 1 1 1 1 1 1 1 1 1 1 ...
# $ citationIssued: Factor w/ 2 levels "NO","YES": NA NA NA NA NA NA NA NA NA NA ...
# $ personSearch  : Factor w/ 2 levels "NO","YES": 1 1 1 1 1 1 1 1 1 1 ...
# $ vehicleSearch : Factor w/ 2 levels "NO","YES": 1 1 1 1 1 1 1 1 1 1 ...
# $ preRace       : Factor w/ 8 levels "Black","White",..: 3 3 3 3 3 3 3 3 3 3 ...
# $ race          : Factor w/ 8 levels "Black","White",..: 3 3 2 4 2 4 1 7 2 1 ...
# $ gender        : Factor w/ 3 levels "Female","Male",..: 3 2 1 2 1 2 2 1 2 2 ...
# $ lat           : num  45 45 44.9 44.9 45 ...
# $ long          : num  -93.2 -93.3 -93.3 -93.3 -93.3 ...
# $ policePrecinct: int  1 1 5 5 1 1 1 2 2 4 ...
# $ neighborhood  : Factor w/ 87 levels "Armatage","Audubon Park",..: 11 20 84 

# As we can see df contains 51920 records and 14 features
# Some features reflect person policman perception on the potential violator
# Other columns can’t tell us anything because of it just facts

# So,lets get only those features which important for our analysis 
library(dplyr)
df <- df %>% select(vehicleSearch,
                    race,
                    gender,
                    policePrecinct)

# Transform policePrecinct feature
df$policePrecinct <- as.factor(df$policePrecinct)

# install.packages("installr')
# library(installr)
# updateR()

install.packages(c("partykit", "Formula"))

install.packages("CHAID", repos = "https://R-Forge.R-project.org")
library(CHAID)

control <- chaid_control(minbucket = 1000, maxheight = 2)
model <- chaid(vehicleSearch - .,
               data = df,
               control = control)

plot(model)



