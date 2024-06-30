install.packages("AER")
library(AER)
data("CreditCard")

model = glm(card ~ age + income + dependents,
            family = "binomial",
            data = CreditCard)

summary(model)

# Output 
# Call:
# glm(formula = card ~ age + income + dependents, family = "binomial", 
#      data = CreditCard)

#Coefficients:
#  Estimate Std. Error z value Pr(>|z|)    
#(Intercept)  0.913311   0.243348   3.753 0.000175 ***
#  age         -0.006223   0.006939  -0.897 0.369769    
#income       0.209072   0.051504   4.059 4.92e-05 ***
# dependents  -0.141473   0.055834  -2.534 0.011283 *  
#  ---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# (Dispersion parameter for binomial family taken to be 1)

# Null deviance: 1404.6  on 1318  degrees of freedom
# Residual deviance: 1383.9  on 1315  degrees of freedom
# AIC: 1391.9

# Number of Fisher Scoring iterations: 4

# Plotting

# Install necessary packages
install.packages("AER")
install.packages("pROC")
install.packages("ggplot2")
install.packages("effects")

# Load libraries
install.packages("pROC")
install.packages("effects")
library(AER)
library(pROC)
library(ggplot2)
library(effects)


# ROC Curve
predicted_probabilities <- predict(model, type = "response")
roc_curve <- roc(CreditCard$card, predicted_probabilities)
plot(roc_curve, main = "ROC Curve", col = "blue")

# Predicted Probabilities Plot
new_data <- data.frame(age = seq(min(CreditCard$age), max(CreditCard$age), length.out = 100),
                       income = mean(CreditCard$income),
                       dependents = mean(CreditCard$dependents))
new_data$predicted_probabilities <- predict(model, new_data, type = "response")
ggplot(new_data, aes(x = age, y = predicted_probabilities)) +
  geom_line(color = "blue") +
  labs(title = "Predicted Probabilities by Age", x = "Age", y = "Predicted Probability") +
  theme_minimal()

# Effect Plots
plot(allEffects(model), main = "Effect Plots")

