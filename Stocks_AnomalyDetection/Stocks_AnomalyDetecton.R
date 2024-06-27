install.packages("tseries")
library(tseries)
install.packages("zoo")
library(zoo)
install.packages("corrplot")
library(corrplot)
install.packages("CausalImpact")
library(CausalImpact)

# Define the date ranges
start <- "2014-01-01"
treatment <- "2015-09-01"
end <- "2015-12-31"

# Det data
Volswagen <- get.hist.quote(instrument = "VOW.DE",
                            start = start,
                            end = end,
                            quote = "Close",
                            compression = "d")

Disney <- get.hist.quote(instrument = "DIS",
                         start = start,
                         end = end,
                         quote = "Close",
                         compression = "d")

Novartis <- get.hist.quote(instrument = "NVS",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "d")

Carlsberg <- get.hist.quote(instrument = "CARL-B.CO",
                            start = start,
                            end = end,
                            quote = "Close",
                            compression = "d")

# Check for missing values
print(sum(is.na(Volswagen)))
print(sum(is.na(Disney)))
print(sum(is.na(Novartis)))
print(sum(is.na(Carlsberg)))

# Merge sotocks into one df
stocks <- cbind(Volswagen, Disney, Novartis, Carlsberg)

print(sum(is.na(stocks)))

# missing values
stocks_clean <- na.locf(stocks, na.rm = FALSE)


data_range <- index(stocks_clean)
data_start <- min(data_range)
data_end <- max(data_range)

print(paste("Data starts on:", data_start))
print(paste("Data ends on:", data_end))

pre.period <- as.Date(c(data_start, as.Date(treatment) - 1))
post.period <- as.Date(c(as.Date(treatment), data_end))

print(pre.period)
print(post.period)

# Correlations
correlation <- window(stocks_clean, start = pre.period[1], end = pre.period[2])
cor_matrix <- cor(correlation)

# Plot corr.matrix
corrplot(cor_matrix, method = "color", type = "upper", order = "hclust", 
         addCoef.col = "black", tl.col = "black", tl.srt = 45, 
         diag = FALSE, title = "Correlation Matrix of Stocks")

# CausalImpact
impact <- CausalImpact(data = stocks_clean,
                       pre.period = pre.period,
                       post.period = post.period)

# Summary of the impact analysis
summary(impact)
plot(impact)

# Summary output
# Posterior inference {CausalImpact}

# Average        Cumulative    
# Actual                   132            11505         
# Prediction (s.d.)        176 (9)        15288 (781)   
# 95% CI                   [159, 192]     [13803, 16719]

# Absolute effect (s.d.)   -43 (9)        -3783 (781)   
# 95% CI                   [-60, -26]     [-5214, -2298]

# Relative effect (s.d.)   -25% (3.9%)    -25% (3.9%)   
# 95% CI                   [-31%, -17%]   [-31%, -17%]  

# Posterior tail-area probability p:   0.00102
# Posterior prob. of a causal effect:  99.89796%


# Summary explanation
# Actual vs. Predicted: The actual average value of the outcome during the 
   # post-treatment period was 132, while the predicted average value was 176. 
   # The actual cumulative value was 11505, while the predicted cumulative value
   # was 15288.
# Absolute Effect: The treatment is estimated to have caused a decrease of 43 
   # units on average during the post-treatment period, with a cumulative 
   # decrease of 3783 units. The 95% confidence interval suggests that the true 
   # average decrease could be between 26 and 60 units, and the cumulative 
   # decrease could be between 2298 and 5214 units.
# Relative Effect: The treatment is estimated to have caused a 25% decrease on 
   # average, with the true relative decrease likely to be between 17% and 31%.
# Statistical Significance: The p-value of 0.00102 indicates that the observed 
   # effect is statistically significant, and there is a 99.898% probability 
   # that the treatment had a causal effect on the outcome.

# Conclusion
  # The analysis suggests that the treatment had a significant negative impact 
   # on the outcome variable, reducing it by approximately 25% on average during
   # the post-treatment period. The high posterior probability (99.898%) and the
   # low p-value (0.00102) provide strong evidence that the observed effect 
   # is not due to random chance.
