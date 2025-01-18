# Load necessary libraries
library(tidyverse)
library(cluster)       # For Hopkins statistic
library(factoextra)    # For visualizing clustering tendencies
library(corrplot)      # For visualizing correlations

# Set working directory
setwd("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/data/raw")

# Load datasets
grow_to_whom <- read.csv("grow_to_whom.csv")
howl_on_sound <- read.csv("howl_on_sound.csv")
keep <- read.csv("keep.csv")
problems <- read.csv("problems.csv")

# Granularity analysis

# 1. Proportion Analysis
proportion_growl <- grow_to_whom %>%
  summarise(across(-ID_full, ~ mean(.x) * 100)) %>%
  pivot_longer(everything(), names_to = "Behavior", values_to = "Percentage")
print("Proportion of growling behaviors:")
print(proportion_growl)

# Plot proportions
ggplot(proportion_growl, aes(x = Behavior, y = Percentage)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Proportion of Growling Behaviors") +
  ylab("Percentage (%)") +
  xlab("Behavior")

# 2. Variance and Standard Deviation
variance_growl <- grow_to_whom %>%
  summarise(across(-ID_full, ~ var(.x)))
print("Variance of growling behaviors:")
print(variance_growl)

sd_growl <- grow_to_whom %>%
  summarise(across(-ID_full, ~ sd(.x)))
print("Standard deviation of growling behaviors:")
print(sd_growl)

# 3. Binary Pattern Analysis - Count unique binary patterns
unique_patterns <- grow_to_whom %>%
  select(-ID_full) %>%
  distinct() %>%
  nrow()
print(paste("Number of unique binary behavior patterns:", unique_patterns))

# 4. Hopkins Statistic - Clustering tendency
hopkins_stat <- get_clust_tendency(scale(grow_to_whom[-1]), n = nrow(grow_to_whom) * 0.1, graph = FALSE)
print("Hopkins statistic result (clustering tendency):")
print(hopkins_stat)

# 5. Pairwise Correlations
cor_matrix <- grow_to_whom %>%
  select(-ID_full) %>%
  cor()
print("Correlation matrix of growling behaviors:")
print(cor_matrix)

# Visualize correlation matrix
corrplot(cor_matrix, method = "color", type = "upper", order = "hclust", 
         tl.cex = 0.7, tl.col = "black", addCoef.col = "black",
         title = "Correlation Matrix of Growling Behaviors")
