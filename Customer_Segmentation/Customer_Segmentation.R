# data preparation
# read dataset
data <- read.csv("Train.csv")

# Feature selection
# Keeping only those features which matters for the clastering
data <- data[, 2:9]
summary(data)


# Summary Output
#     Gender          Ever_Married            Age         Graduated          Profession       
# Length:8068        Length:8068        Min.   :18.00   Length:8068        Length:8068       
# Class :character   Class :character   1st Qu.:30.00   Class :character   Class :character  
# Mode  :character   Mode  :character   Median :40.00   Mode  :character   Mode  :character  
# Mean   :43.47                                        
# 3rd Qu.:53.00                                        
# Max.   :89.00                                        

# Work_Experience  Spending_Score      Family_Size  
# Min.   : 0.000   Length:8068        Min.   :1.00  
# 1st Qu.: 0.000   Class :character   1st Qu.:2.00  
# Median : 1.000   Mode  :character   Median :3.00  
# Mean   : 2.642                      Mean   :2.85  
# 3rd Qu.: 4.000                      3rd Qu.:4.00  
# Max.   :14.000                      Max.   :9.00  
# NA's   :829                         NA's   :335  

# First of all we need to understand how many classes we have in "Professions"

unique(data$Profession)

# Unique Output
# [1] "Healthcare"    "Engineer"      "Lawyer"        "Entertainment" "Artist"       
# [6] "Executive"     "Doctor"        "Homemaker"     "Marketing"     "" 

# Basically we have 10 classes in Professions feature, however one of them is blank
# To handle blanks we are going to label all missing values with "NA"
# and after we need to remove all NA values due to it may affect our clustering

data[data == ""] <- NA
data <- data[complete.cases(data), ]

# Get only numeric features
library(dplyr)
df <- data %>% select_if(is.numeric)

# Get only character features
char <- data %>% select_if(is.character)

# One hot encoding character features 
install.packages("fastDummies")
library(fastDummies)
char <- dummy_cols(char, 
                   remove_most_frequent_dummy = TRUE)

# Merge df and char datasets
df <- cbind(df, char[, 6:18])

# Scaling 
df[, 1:16] <- scale(df[, 1:16])

# Define number of classes for segmentation 
install.packages("factoextra")
library(factoextra)

fviz_nbclust(df, kmeans, method = "wss") +
  labs(subtitle = "Elbow Method")

# Based on the plot "Number of Cluster" and appling "Elbow method" we can conlude:
# That optimal number of clusters is 6

# Clustering
clusters <- kmeans(df, centers = 6, iter.max = 10)
clusters$centers

# Assign clusters to the customers
df_clustered <- cbind(data, clusters$cluster)
write.csv(df_clustered, file = "segmented_dataset.csv")

# Extracting clusters table to form clear clasters
write.csv(clusters$centers, file = "segmentation.csv")

# Plotting 
install.packages("ggplot2")
install.packages("RColorBrewer")
install.packages("ggfortify")
install.packages("reshape2")
library(ggplot2)
library(RColorBrewer)
library(ggfortify)
library(reshape2)

# Perform PCA for visualization
pca <- prcomp(df, center = TRUE, scale. = TRUE)
df_pca <- as.data.frame(pca$x)

# Add cluster assignments to PCA data
df_pca$cluster <- as.factor(clusters$cluster)

# Plot PCA with clusters
ggplot(df_pca, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(size = 2) +
  scale_color_brewer(palette = "Set1") +
  labs(title = "Customer Segmentation (PCA)", x = "Principal Component 1", y = "Principal Component 2") +
  theme_minimal()

# Plotting cluster centers
centers <- as.data.frame(clusters$centers)
centers$cluster <- rownames(centers)

# Convert centers data to long format for ggplot
centers_long <- melt(centers, id.vars = "cluster")

ggplot(centers_long, aes(x = variable, y = value, fill = cluster)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  scale_fill_brewer(palette = "Set1") +
  labs(title = "Cluster Centers", x = "Feature", y = "Scaled Value") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Add cluster assignments to original df
df$cluster <- as.factor(clusters$cluster)

# Visualizing distribution of each feature within each cluster
# Convert original data to long format for ggplot
data_long <- melt(df, id.vars = "cluster")

ggplot(data_long, aes(x = cluster, y = value, fill = cluster)) +
  geom_boxplot() +
  facet_wrap(~ variable, scales = "free", ncol = 3) +
  scale_fill_brewer(palette = "Set1") +
  labs(title = "Feature Distribution by Cluster", x = "Cluster", y = "Value") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))





