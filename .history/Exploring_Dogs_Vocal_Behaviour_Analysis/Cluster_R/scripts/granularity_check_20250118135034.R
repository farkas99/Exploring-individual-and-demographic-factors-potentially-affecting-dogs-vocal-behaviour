# Load necessary libraries
library(tidyverse)
library(cluster)
library(factoextra)
library(corrplot)
library(knitr)
library(kableExtra)

# Set working directory
setwd("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/data/raw")

# Load datasets
datasets <- list(
  "grow_to_whom" = read.csv("grow_to_whom.csv"),
  "howl_on_sound" = read.csv("howl_on_sound.csv"),
  "keep" = read.csv("keep.csv"),
  "problems" = read.csv("problems.csv")
)

# Prepare output Markdown file
output_file <- "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/full_granularity_analysis.md"
sink(output_file)

# Write header
cat("# Full Granularity Analysis Results\n\n")

# Function to process each dataset
process_dataset <- function(data, name) {
  cat("## Dataset: ", name, "\n\n")
  
  # Proportion Analysis
  cat("### Proportion Analysis\n\n")
  proportions <- data %>%
    summarise(across(-ID_full, ~ mean(.x) * 100)) %>%
    pivot_longer(everything(), names_to = "Behavior", values_to = "Percentage")
  cat("#### Table: Proportion of Behaviors\n")
  kable(proportions, format = "markdown") %>% print()
  cat("\n\n")
  
  # Variance and Standard Deviation
  cat("### Variance and Standard Deviation\n\n")
  variance <- data %>%
    summarise(across(-ID_full, ~ var(.x)))
  sd <- data %>%
    summarise(across(-ID_full, ~ sd(.x)))
  cat("#### Variance\n")
  kable(variance, format = "markdown") %>% print()
  cat("\n#### Standard Deviation\n")
  kable(sd, format = "markdown") %>% print()
  cat("\n\n")
  
  # Binary Pattern Analysis
  cat("### Binary Pattern Analysis\n\n")
  unique_patterns <- data %>%
    select(-ID_full) %>%
    distinct() %>%
    nrow()
  cat(paste("**Number of unique binary behavior patterns:**", unique_patterns, "\n\n"))
  
  # Hopkins Statistic
  cat("### Hopkins Statistic - Clustering Tendency\n\n")
  hopkins_stat <- get_clust_tendency(scale(data[-1]), n = nrow(data) * 0.1, graph = FALSE)
  cat(paste("**Hopkins statistic (clustering tendency):**", round(hopkins_stat$hopkins_stat, 3), "\n\n"))
  
  # Pairwise Correlations
  cat("### Pairwise Correlations\n\n")
  cor_matrix <- data %>%
    select(-ID_full) %>%
    cor()
  cat("#### Correlation Matrix\n")
  kable(cor_matrix, format = "markdown") %>% print()
  cat("\n\n")
  
  # Visualize correlation matrix (save plot)
  corrplot_file <- paste0("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/", name, "_correlation_matrix.png")
  png(corrplot_file, width = 800, height = 800)
  corrplot(cor_matrix, method = "color", type = "upper", order = "hclust",
           tl.cex = 0.7, tl.col = "black", addCoef.col = "black",
           title = paste("Correlation Matrix:", name))
  dev.off()
  cat(paste("Correlation matrix saved to:", corrplot_file, "\n\n"))
}

# Process each dataset
for (dataset_name in names(datasets)) {
  process_dataset(datasets[[dataset_name]], dataset_name)
}

# Close the Markdown file
sink()

# Notify user
cat("Results have been saved to:", output_file, "\n")
