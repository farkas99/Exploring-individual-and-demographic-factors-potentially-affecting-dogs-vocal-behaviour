# Script to explore the content of CSV files
# This script reads and displays the first 5 rows of each data file

# Load required packages
if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)

# Set working directory to the Cluster_R folder
setwd("Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R")

# Function to read and display data summary
explore_data <- function(file_path, file_name) {
  # Read the CSV file with full path
  data <- read.csv(file_path, stringsAsFactors = TRUE)
  
  # Create output
  cat("\n==============================================\n")
  cat("Exploring:", file_name, "\n")
  cat("==============================================\n")
  
  # Display dimensions
  cat("\nDimensions (rows x columns):", paste(dim(data), collapse = " x "), "\n")
  
  # Display column names
  cat("\nColumn names:\n")
  print(colnames(data))
  
  # Display first 5 rows
  cat("\nFirst 5 rows of data:\n")
  print(head(data, 5))
  
  # Display summary statistics
  cat("\nSummary statistics:\n")
  print(summary(data))
  
  # Check for missing values
  cat("\nMissing values per column:\n")
  print(colSums(is.na(data)))
  
  return(data)
}

# Create results directory if it doesn't exist
dir.create("results", showWarnings = FALSE, recursive = TRUE)

# Open file connection for saving output
sink("results/data_exploration_results.txt")

# Explore each dataset
keep_data <- explore_data("data/raw/keep.csv", "keep.csv")
howl_data <- explore_data("data/raw/howl_on_sound.csv", "howl_on_sound.csv")
growl_data <- explore_data("data/raw/grow_to_whom.csv", "grow_to_whom.csv")
problems_data <- explore_data("data/raw/problems.csv", "problems.csv")

# Close the file connection
sink()

# Save the data objects for later use
save(keep_data, howl_data, growl_data, problems_data, 
     file = "results/explored_data.RData")

cat("Data exploration completed. Results saved in 'results/data_exploration_results.txt'\n")
