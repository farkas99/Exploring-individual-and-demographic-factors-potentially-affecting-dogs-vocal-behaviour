# Dataset Relationships Analysis Script
# This script analyzes the relationships between different behavioral datasets

# Load required packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("corrplot")) install.packages("corrplot")
library(tidyverse)
library(ggplot2)
library(corrplot)

# Set base directory path
base_dir <- file.path(getwd(), "Exploring_Dogs_Vocal_Behaviour_Analysis", "Cluster_R")

# Create directory for relationship analysis
dir.create(file.path(base_dir, "results", "relationships"), recursive = TRUE, showWarnings = FALSE)

# Load datasets
problems_data <- read.csv(file.path(base_dir, "data", "raw", "problems.csv"))
growl_data <- read.csv(file.path(base_dir, "data", "raw", "grow_to_whom.csv"))
howl_data <- read.csv(file.path(base_dir, "data", "raw", "howl_on_sound.csv"))
keep_data <- read.csv(file.path(base_dir, "data", "raw", "keep.csv"))

# Function to calculate dataset summary statistics
analyze_dataset_patterns <- function(data, name) {
  # Remove ID column
  data_clean <- data[, !colnames(data) %in% c("ID_full")]
  
  # Calculate response patterns
  response_counts <- rowSums(data_clean)
  zero_responses <- sum(response_counts == 0)
  single_responses <- sum(response_counts == 1)
  multiple_responses <- sum(response_counts > 1)
  
  # Calculate co-occurrences
  cooccur_matrix <- t(data_clean) %*% data_clean
  
  return(list(
    name = name,
    total_dogs = nrow(data_clean),
    zero_responses = zero_responses,
    single_responses = single_responses,
    multiple_responses = multiple_responses,
    avg_responses = mean(response_counts),
    max_responses = max(response_counts),
    cooccur_matrix = cooccur_matrix
  ))
}

# Analyze each dataset
datasets <- list(
  problems = problems_data,
  growling = growl_data,
  howling = howl_data,
  keeping = keep_data
)

dataset_analyses <- lapply(names(datasets), function(name) {
  analyze_dataset_patterns(datasets[[name]], name)
})
names(dataset_analyses) <- names(datasets)

# Create cross-dataset relationship analysis
# Function to calculate cross-dataset correlations
calculate_cross_correlations <- function(data1, data2, name1, name2) {
  # Remove ID columns
  data1_clean <- data1[, !colnames(data1) %in% c("ID_full")]
  data2_clean <- data2[, !colnames(data2) %in% c("ID_full")]
  
  # Calculate total responses for each dog in each dataset
  responses1 <- rowSums(data1_clean)
  responses2 <- rowSums(data2_clean)
  
  # Calculate correlation
  cor_value <- cor(responses1, responses2)
  
  return(list(
    datasets = paste(name1, "vs", name2),
    correlation = cor_value
  ))
}

# Calculate all pairwise correlations
cross_correlations <- list()
for(i in 1:(length(datasets)-1)) {
  for(j in (i+1):length(datasets)) {
    name1 <- names(datasets)[i]
    name2 <- names(datasets)[j]
    cross_correlations[[paste(name1, name2)]] <- 
      calculate_cross_correlations(datasets[[name1]], datasets[[name2]], name1, name2)
  }
}

# Save analysis results
sink(file.path(base_dir, "results", "relationships", "dataset_relationships.txt"))

cat("Dataset Relationship Analysis\n")
cat("===========================\n\n")

# Print individual dataset statistics
for(analysis in dataset_analyses) {
  cat(sprintf("\n%s Dataset:\n", tools::toTitleCase(analysis$name)))
  cat("-----------------\n")
  cat(sprintf("Total dogs: %d\n", analysis$total_dogs))
  cat(sprintf("Dogs with no responses: %d (%.1f%%)\n", 
              analysis$zero_responses,
              analysis$zero_responses/analysis$total_dogs * 100))
  cat(sprintf("Dogs with single response: %d (%.1f%%)\n",
              analysis$single_responses,
              analysis$single_responses/analysis$total_dogs * 100))
  cat(sprintf("Dogs with multiple responses: %d (%.1f%%)\n",
              analysis$multiple_responses,
              analysis$multiple_responses/analysis$total_dogs * 100))
  cat(sprintf("Average responses per dog: %.2f\n", analysis$avg_responses))
  cat(sprintf("Maximum responses per dog: %d\n", analysis$max_responses))
}

# Print cross-dataset correlations
cat("\nCross-Dataset Correlations\n")
cat("------------------------\n")
for(corr in cross_correlations) {
  cat(sprintf("%s: %.3f\n", corr$datasets, corr$correlation))
}

sink()

# Create visualization of response patterns
response_patterns <- data.frame(
  Dataset = rep(names(datasets), each = 3),
  Response_Type = rep(c("No Response", "Single Response", "Multiple Responses"), length(datasets)),
  Count = c(
    sapply(dataset_analyses, function(x) c(x$zero_responses, x$single_responses, x$multiple_responses))
  )
)

p1 <- ggplot(response_patterns, aes(x = Dataset, y = Count, fill = Response_Type)) +
  geom_bar(stat = "identity", position = "fill") +
  theme_minimal() +
  labs(title = "Response Patterns Across Datasets",
       y = "Proportion",
       x = "") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(file.path(base_dir, "results", "relationships", "response_patterns.png"),
       p1, width = 10, height = 6)

# Create correlation heatmap between datasets
correlation_matrix <- matrix(NA, nrow = length(datasets), ncol = length(datasets))
rownames(correlation_matrix) <- names(datasets)
colnames(correlation_matrix) <- names(datasets)

for(i in 1:length(datasets)) {
  for(j in 1:length(datasets)) {
    if(i != j) {
      correlation_matrix[i,j] <- calculate_cross_correlations(
        datasets[[i]], datasets[[j]], 
        names(datasets)[i], names(datasets)[j]
      )$correlation
    } else {
      correlation_matrix[i,j] <- 1
    }
  }
}

png(file.path(base_dir, "results", "relationships", "dataset_correlations.png"),
    width = 800, height = 800)
corrplot(correlation_matrix,
         method = "color",
         type = "upper",
         addCoef.col = "black",
         tl.col = "black",
         tl.srt = 45,
         title = "Cross-Dataset Correlations")
dev.off()

cat("Dataset relationship analysis completed. Results saved in 'results/relationships' directory.\n")
