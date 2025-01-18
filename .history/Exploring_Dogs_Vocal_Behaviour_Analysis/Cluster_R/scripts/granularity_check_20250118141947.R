# Load necessary libraries
library(tidyverse)
library(cluster)
library(factoextra)
library(corrplot)
library(knitr)
library(kableExtra)

# Paths for the datasets
dataset_paths <- list(
  "grow_to_whom" = "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/data/raw/grow_to_whom.csv",
  "howl_on_sound" = "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/data/raw/howl_on_sound.csv",
  "keep" = "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/data/raw/keep.csv",
  "problems" = "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/data/raw/problems.csv"
)

# Load datasets into a named list
datasets <- lapply(dataset_paths, read.csv)

# Markdown output file path
output_file <- "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/full_granularity_analysis.md"

# Open the Markdown file
cat("# Full Granularity Analysis Results\n\n", file = output_file, append = FALSE)

# Function to process each dataset
process_dataset <- function(data, name) {
  # Write dataset header to the Markdown file
  cat("## Dataset: ", name, "\n\n", file = output_file, append = TRUE)
  
  # Proportion Analysis
  cat("### Proportion Analysis\n\n", file = output_file, append = TRUE)
  proportions <- data %>%
    summarise(across(-ID_full, ~ mean(.x) * 100)) %>%
    pivot_longer(everything(), names_to = "Behavior", values_to = "Percentage")
  kable(proportions, format = "markdown") %>%
    writeLines(output_file, sep = "\n", append = TRUE)
  cat("\n\n", file = output_file, append = TRUE)
  cat("Proportion analysis completed for:", name, "\n")
  
  # Variance and Standard Deviation
  cat("### Variance and Standard Deviation\n\n", file = output_file, append = TRUE)
  variance <- data %>%
    summarise(across(-ID_full, ~ var(.x)))
  sd <- data %>%
    summarise(across(-ID_full, ~ sd(.x)))
  kable(variance, format = "markdown") %>%
    writeLines(output_file, sep = "\n", append = TRUE)
  cat("\n", file = output_file, append = TRUE)
  kable(sd, format = "markdown") %>%
    writeLines(output_file, sep = "\n", append = TRUE)
  cat("\n\n", file = output_file, append = TRUE)
  cat("Variance and standard deviation completed for:", name, "\n")
  
  # Binary Pattern Analysis
  unique_patterns <- data %>%
    select(-ID_full) %>%
    distinct() %>%
    nrow()
  cat("### Binary Pattern Analysis\n\n", file = output_file, append = TRUE)
  cat(paste("**Number of unique binary behavior patterns:**", unique_patterns, "\n\n"), file = output_file, append = TRUE)
  cat("Binary pattern analysis completed for:", name, "\n")
  
  # Hopkins Statistic
  hopkins_stat <- get_clust_tendency(scale(data[-1]), n = nrow(data) * 0.1, graph = FALSE)
  cat("### Hopkins Statistic - Clustering Tendency\n\n", file = output_file, append = TRUE)
  cat(paste("**Hopkins statistic (clustering tendency):**", round(hopkins_stat$hopkins_stat, 3), "\n\n"), file = output_file, append = TRUE)
  cat("Hopkins statistic calculated for:", name, "\n")
  
  # Pairwise Correlations
  cor_matrix <- data %>%
    select(-ID_full) %>%
    cor()
  cat("### Pairwise Correlations\n\n", file = output_file, append = TRUE)
  kable(cor_matrix, format = "markdown") %>%
    writeLines(output_file, sep = "\n", append = TRUE)
  cat("\n\n", file = output_file, append = TRUE)
  
  # Save correlation matrix plot
  corrplot_file <- paste0("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/", name, "_correlation_matrix.png")
  png(corrplot_file, width = 800, height = 800)
  corrplot(cor_matrix, method = "color", type = "upper", order = "hclust",
           tl.cex = 0.7, tl.col = "black", addCoef.col = "black",
           title = paste("Correlation Matrix:", name))
  dev.off()
  cat(paste("![Correlation matrix for", name, "](", corrplot_file, ")\n\n"), file = output_file, append = TRUE)
  cat("Correlation plot saved for:", name, "\n")
}

# Process each dataset and log progress
for (name in names(datasets)) {
  tryCatch(
    {
      cat("Starting analysis for:", name, "\n")
      process_dataset(datasets[[name]], name)
      cat("Finished analysis for:", name, "\n")
    },
    error = function(e) {
      cat(paste("Error processing dataset:", name, "\n", e, "\n"))
    }
  )
}

# Notify user
cat("Results have been saved to:", output_file, "\n")
