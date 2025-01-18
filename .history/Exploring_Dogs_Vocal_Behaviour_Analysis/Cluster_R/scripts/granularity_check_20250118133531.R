# Load necessary libraries
library(tidyverse)
library(cluster)       # For Hopkins statistic
library(factoextra)    # For visualizing clustering tendencies
library(corrplot)      # For visualizing correlations
library(knitr)         # For saving results as Markdown
library(kableExtra)    # For enhanced Markdown tables

# Set working directory
setwd("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/data/raw")

# Load datasets
grow_to_whom <- read.csv("grow_to_whom.csv")
howl_on_sound <- read.csv("howl_on_sound.csv")
keep <- read.csv("keep.csv")
problems <- read.csv("problems.csv")

# Prepare output Markdown file
output_file <- "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/granularity_analysis.md"
sink(output_file)

# Write header
cat("# Granularity Analysis Results\n\n")

# 1. Proportion Analysis
cat("## Proportion of Growling Behaviors\n\n")
proportion_growl <- grow_to_whom %>%
  summarise(across(-ID_full, ~ mean(.x) * 100)) %>%
  pivot_longer(everything(), names_to = "Behavior", values_to = "Percentage")
cat("### Table: Proportion of Growling Behaviors\n")
kable(proportion_growl, format = "markdown") %>% print()
cat("\n\n")

# 2. Variance and Standard Deviation
cat("## Variance and Standard Deviation of Growling Behaviors\n\n")
variance_growl <- grow_to_whom %>%
  summarise(across(-ID_full, ~ var(.x)))
sd_growl <- grow_to_whom %>%
  summarise(across(-ID_full, ~ sd(.x)))
cat("### Variance\n")
kable(variance_growl, format = "markdown") %>% print()
cat("\n### Standard Deviation\n")
kable(sd_growl, format = "markdown") %>% print()
cat("\n\n")

# 3. Binary Pattern Analysis
cat("## Binary Pattern Analysis\n\n")
unique_patterns <- grow_to_whom %>%
  select(-ID_full) %>%
  distinct() %>%
  nrow()
cat(paste("**Number of unique binary behavior patterns:**", unique_patterns, "\n\n"))

# 4. Hopkins Statistic
cat("## Hopkins Statistic - Clustering Tendency\n\n")
hopkins_stat <- get_clust_tendency(scale(grow_to_whom[-1]), n = nrow(grow_to_whom) * 0.1, graph = FALSE)
cat(paste("**Hopkins statistic (clustering tendency):**", round(hopkins_stat$hopkins_stat, 3), "\n\n"))

# 5. Pairwise Correlations
cat("## Pairwise Correlations of Growling Behaviors\n\n")
cor_matrix <- grow_to_whom %>%
  select(-ID_full) %>%
  cor()
cat("### Correlation Matrix\n")
kable(cor_matrix, format = "markdown") %>% print()
cat("\n\n")

# Close the Markdown file
sink()

# Notify user
cat("Results have been saved to:", output_file, "\n")
