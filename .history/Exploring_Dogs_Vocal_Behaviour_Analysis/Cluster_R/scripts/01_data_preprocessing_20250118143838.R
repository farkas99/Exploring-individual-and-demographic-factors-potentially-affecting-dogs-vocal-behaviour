# Data Preprocessing Script for Clustering Analysis
# This script prepares the data for both k-means and hierarchical clustering

# Load required packages
source("install_packages.R")
library(tidyverse)
library(readxl)
library(cluster)
library(factoextra)

# Read the raw data
data_path <- "../base_data/raw/DATA_STONE_BASE_20241230.xlsx"
raw_data <- read_excel(data_path)

# Function to check data granularity and distribution
check_data_distribution <- function(data) {
  # Create summary statistics for behavioral variables
  behavioral_vars <- c("Agg_fam", "Agg_str", "Fear_str", "Fear_sit", "Sep_anx", 
                      "Att_seek", "Train", "Bark", "Comp_beh")
  
  summary_stats <- data %>%
    select(all_of(behavioral_vars)) %>%
    summary()
  
  # Save summary statistics
  sink("../results/data_distribution_summary.txt")
  print(summary_stats)
  sink()
  
  # Create distribution plots
  pdf("../results/figures/behavioral_distributions.pdf")
  for(var in behavioral_vars) {
    p <- ggplot(data, aes_string(x = var)) +
      geom_histogram(bins = 30) +
      theme_minimal() +
      ggtitle(paste("Distribution of", var))
    print(p)
  }
  dev.off()
  
  # Return summary for further analysis
  return(summary_stats)
}

# Function to preprocess data for clustering
preprocess_data <- function(data) {
  # Select behavioral variables for clustering
  behavioral_vars <- c("Agg_fam", "Agg_str", "Fear_str", "Fear_sit", "Sep_anx", 
                      "Att_seek", "Train", "Bark", "Comp_beh")
  
  # Select demographic variables for later analysis
  demographic_vars <- c("Age", "Sex", "Neutered", "Pure_breed", "Weight", 
                       "Living_place", "Other_dogs", "Children")
  
  # Create processed dataset
  processed_data <- data %>%
    select(all_of(c(behavioral_vars, demographic_vars))) %>%
    # Remove rows with missing values in behavioral variables
    drop_na(all_of(behavioral_vars))
  
  # Scale behavioral variables (important for clustering)
  scaled_behavioral <- scale(processed_data[behavioral_vars])
  
  # Create final dataset with both scaled behavioral and demographic data
  final_data <- list(
    full_data = processed_data,
    behavioral_matrix = scaled_behavioral,
    demographic_data = processed_data[demographic_vars],
    behavioral_vars = behavioral_vars,
    demographic_vars = demographic_vars
  )
  
  # Save processed data
  saveRDS(final_data, "../data/processed/processed_data.rds")
  
  return(final_data)
}

# Main execution
cat("Starting data preprocessing...\n")

# Check data distribution
cat("Analyzing data distribution...\n")
dist_summary <- check_data_distribution(raw_data)

# Preprocess data
cat("Preprocessing data...\n")
processed_data <- preprocess_data(raw_data)

cat("Data preprocessing complete!\n")
cat("Number of observations in processed data:", nrow(processed_data$full_data), "\n")

# Print basic information about the processed data
cat("\nStructure of processed data:\n")
str(processed_data$full_data)
