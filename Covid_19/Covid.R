rm(list=ls())
install.packages("Hmisc")
library(Hmisc)

df <- read_csv("COVID19_line_list_data.csv")

describe(df)
# Data prep. death column
df$death_dummy <- as.integer(df$death != 0)

# Calculating death rate
sum(df$death_dummy) / nrow(df)

# Check the hypothesis that death rate relies on the age
dead = subset(df, death_dummy == 1)
alive = subset(df, death_dummy == 0)
mean(dead$age, na.rm = TRUE)
mean(alive$age, na.rm = TRUE)

# Apply T-test to reject or prove Null hypothesis 
t.test(alive$age, dead$age, alternative = "two.sided", conf.level = 0.95)
# As a result we've got p value close to 0 (2.2e-16)
# We reject Null hypothesis, and can make a conclusion
# The age has significant impact on death rate

# The T-test but with gender difference 
male = subset(df, gender == "male")
female = subset(df, gender == "female")
mean(male$death_dummy, na.rm = TRUE)
mean(female$death_dummy, na.rm = TRUE)
t.test(male$death_dummy, female$death_dummy, alternative = "two.sided", conf.level = 0.95)

# P-value = 0.002 which much less than 0.05
# So, we can conclude that gender also has impact on death rate

