# Clustering Preparation Script
# This script analyzes data granularity and prepares data for clustering

# Load required packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("cluster")) install.packages("cluster")
if (!require("factoextra")) install.packages("factoextra")
library(tidyverse)
library(cluster)
library(factoextra)

# Set base directory path
base_dir <- file.path(getwd(), "Exploring_Dogs_Vocal_Behaviour_Analysis", "Cluster_R")

# Load the data
load(file.path(base_dir, "results", "explored_data.RData"))

# Create directory for analysis results
dir.create(file.path(base_dir, "results", "clustering_prep"), recursive = TRUE, showWarnings = FALSE)

# Function to analyze behavioral patterns
analyze_patterns <- function(data, dataset_name) {
  # Remove ID column
  data_clean <- data[, !colnames(data) %in% c("ID_full")]
  
  # Calculate correlation matrix
  cor_matrix <- cor(data_clean)
  
  # Save correlation plot
  png(file.path(base_dir, "results", "clustering_prep", paste0(dataset_name, "_correlation.png")),
      width = 800, height = 800)
  corrplot::corrplot(cor_matrix, method = "color", type = "upper",
                    tl.col = "black", tl.srt = 45)
  dev.off()
  
  # Calculate behavior combinations
  behavior_patterns <- apply(data_clean, 1, paste, collapse = "")
  unique_patterns <- length(unique(behavior_patterns))
  
  # Calculate pattern frequencies
  pattern_freq <- table(behavior_patterns)
  top_patterns <- sort(pattern_freq, decreasing = TRUE)[1:10]
  
  return(list(
    unique_patterns = unique_patterns,
    total_patterns = nrow(data),
    pattern_ratio = unique_patterns / nrow(data),
    top_patterns = top_patterns
  ))
}

# Analyze each dataset
problems_analysis <- analyze_patterns(problems_data, "problems")
growl_analysis <- analyze_patterns(growl_data, "growl")
howl_analysis <- analyze_patterns(howl_data, "howl")
keep_analysis <- analyze_patterns(keep_data, "keep")

# Save analysis results
sink(file.path(base_dir, "results", "clustering_prep", "granularity_analysis.txt"))

cat("Data Granularity Analysis\n")
cat("========================\n\n")

# Function to print analysis results
print_analysis <- function(analysis, dataset_name) {
  cat(paste0("\n", dataset_name, " Dataset:\n"))
  cat("------------------\n")
  cat("Unique behavior patterns:", analysis$unique_patterns, "\n")
  cat("Total observations:", analysis$total_patterns, "\n")
  cat("Pattern ratio (unique/total):", round(analysis$pattern_ratio, 4), "\n")
  cat("\nTop 10 most common patterns:\n")
  print(analysis$top_patterns)
  cat("\n")
}

print_analysis(problems_analysis, "Problems")
print_analysis(growl_analysis, "Growling")
print_analysis(howl_analysis, "Howling")
print_analysis(keep_analysis, "Keeping")

sink()

# Prepare combined dataset for clustering
# We'll focus on behavioral problems and growling as main clustering variables
combined_data <- problems_data %>%
  select(-ID_full, -No_behavioral_problems) %>%  # Remove ID and redundant column
  bind_cols(
    growl_data %>%
      select(-ID_full, -He_she_doesn.t_growl)  # Remove ID and redundant column
  )

# Scale the data
scaled_data <- scale(combined_data)

# Calculate silhouette width for different k values
k_max <- 10
sil_width <- sapply(2:k_max, function(k) {
  km <- kmeans(scaled_data, centers = k, nstart = 25)
  ss <- silhouette(km$cluster, dist(scaled_data))
  mean(ss[, 3])
})

# Save silhouette analysis plot
png(file.path(base_dir, "results", "clustering_prep", "silhouette_analysis.png"),
    width = 800, height = 600)
plot(2:k_max, sil_width, type = "b", pch = 19,
     xlab = "Number of clusters (k)",
     ylab = "Average silhouette width",
     main = "Silhouette Analysis for Optimal k")
dev.off()

# Save prepared data for clustering
save(combined_data, scaled_data, sil_width,
     file = file.path(base_dir, "results", "clustering_prep", "prepared_data.RData"))

cat("Clustering preparation completed. Results saved in 'results/clustering_prep' directory.\n")
