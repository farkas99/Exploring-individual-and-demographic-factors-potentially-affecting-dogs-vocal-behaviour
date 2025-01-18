# Comprehensive Analysis Script
# This script analyzes all available datasets together

# Load required packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("cluster")) install.packages("cluster")
if (!require("factoextra")) install.packages("factoextra")
if (!require("gridExtra")) install.packages("gridExtra")
library(tidyverse)
library(cluster)
library(factoextra)
library(gridExtra)

# Set base directory path
base_dir <- file.path(getwd(), "Exploring_Dogs_Vocal_Behaviour_Analysis", "Cluster_R")

# Create directory for comprehensive analysis
dir.create(file.path(base_dir, "results", "comprehensive"), recursive = TRUE, showWarnings = FALSE)

# Read all datasets
problems_data <- read.csv(file.path(base_dir, "data", "raw", "problems.csv"))
growl_data <- read.csv(file.path(base_dir, "data", "raw", "grow_to_whom.csv"))
howl_data <- read.csv(file.path(base_dir, "data", "raw", "howl_on_sound.csv"))
keep_data <- read.csv(file.path(base_dir, "data", "raw", "keep.csv"))

# Function to analyze dataset characteristics
analyze_dataset <- function(data, name) {
  # Remove ID column
  data_clean <- data[, !colnames(data) %in% c("ID_full")]
  
  # Calculate basic statistics
  n_rows <- nrow(data_clean)
  n_cols <- ncol(data_clean)
  total_responses <- sum(data_clean == 1)
  avg_responses_per_dog <- mean(rowSums(data_clean))
  
  # Calculate correlation matrix
  cor_matrix <- cor(data_clean)
  
  # Save correlation plot
  png(file.path(base_dir, "results", "comprehensive", paste0(name, "_correlation.png")),
      width = 800, height = 800)
  corrplot::corrplot(cor_matrix, method = "color", type = "upper",
                    tl.col = "black", tl.srt = 45)
  dev.off()
  
  return(list(
    n_rows = n_rows,
    n_cols = n_cols,
    total_responses = total_responses,
    avg_responses_per_dog = avg_responses_per_dog,
    response_rate = total_responses / (n_rows * n_cols)
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
  analyze_dataset(datasets[[name]], name)
})
names(dataset_analyses) <- names(datasets)

# Create combined dataset for comprehensive clustering
combined_data <- data.frame(
  # Problems (excluding ID and No_behavioral_problems)
  problems_data %>% select(-ID_full, -No_behavioral_problems),
  
  # Growling (excluding ID and negative response)
  growl_data %>% select(-ID_full, -He_she_doesn.t_growl),
  
  # Howling (excluding ID and negative response)
  howl_data %>% select(-ID_full, -He_she_doesn.t_howl_for_any_of_the_above_options),
  
  # Keeping (excluding ID)
  keep_data %>% select(-ID_full)
)

# Scale the data
scaled_data <- scale(combined_data)

# Perform k-means clustering with different k values
set.seed(123)
k_range <- 2:6
kmeans_results <- lapply(k_range, function(k) {
  kmeans(scaled_data, centers = k, nstart = 25)
})

# Calculate silhouette scores
sil_scores <- sapply(kmeans_results, function(km) {
  ss <- silhouette(km$cluster, dist(scaled_data))
  mean(ss[, 3])
})

# Save comprehensive analysis results
sink(file.path(base_dir, "results", "comprehensive", "comprehensive_analysis.txt"))

cat("Comprehensive Dataset Analysis\n")
cat("============================\n\n")

# Dataset characteristics
for(name in names(datasets)) {
  cat(sprintf("\n%s Dataset:\n", tools::toTitleCase(name)))
  cat("-----------------\n")
  analysis <- dataset_analyses[[name]]
  cat(sprintf("Number of variables: %d\n", analysis$n_cols))
  cat(sprintf("Total positive responses: %d\n", analysis$total_responses))
  cat(sprintf("Average responses per dog: %.2f\n", analysis$avg_responses_per_dog))
  cat(sprintf("Overall response rate: %.2f%%\n", analysis$response_rate * 100))
}

# Clustering analysis
cat("\nClustering Analysis\n")
cat("-----------------\n")
cat("Silhouette scores for different numbers of clusters:\n")
for(i in seq_along(k_range)) {
  cat(sprintf("k = %d: %.3f\n", k_range[i], sil_scores[i]))
}

# Select optimal k based on silhouette score
optimal_k <- k_range[which.max(sil_scores)]
optimal_clustering <- kmeans_results[[which.max(sil_scores)]]

cat(sprintf("\nOptimal number of clusters: %d\n", optimal_k))
cat("\nCluster sizes:\n")
print(table(optimal_clustering$cluster))

# Analyze cluster characteristics
cluster_data <- data.frame(
  Cluster = optimal_clustering$cluster,
  combined_data
)

# Calculate mean values for each variable by cluster
cluster_means <- cluster_data %>%
  group_by(Cluster) %>%
  summarise(across(everything(), mean))

# Print top characteristics for each cluster
cat("\nTop characteristics by cluster:\n")
for(cluster in sort(unique(optimal_clustering$cluster))) {
  cat(sprintf("\nCluster %d:\n", cluster))
  
  # Get top 5 characteristics
  cluster_props <- sort(as.numeric(cluster_means[cluster_means$Cluster == cluster, -1]), 
                       decreasing = TRUE)[1:5]
  cluster_vars <- names(cluster_means)[-1][order(as.numeric(cluster_means[cluster_means$Cluster == cluster, -1]), 
                                               decreasing = TRUE)[1:5]]
  
  for(i in 1:5) {
    cat(sprintf("%d. %s (%.1f%%)\n", 
                i,
                gsub("_", " ", cluster_vars[i]),
                cluster_props[i] * 100))
  }
}

sink()

# Create visualization of cluster characteristics
# Save as PNG file
png(file.path(base_dir, "results", "comprehensive", "cluster_characteristics.png"),
    width = 1200, height = 800)
par(mfrow = c(2, 2))

# Plot for each dataset type
datasets_vars <- list(
  problems = grep("^(It_is_hard|Separation|Noise|Aggression|He_she_barks|Jumps|Shy|Hyperactive)",
                 names(combined_data), value = TRUE),
  growling = grep("^(Adult_man|Another_dog|Adult_woman|Postman|Children|A_man|A_person|veterinarian)",
                 names(combined_data), value = TRUE),
  howling = grep("^(Ice_cream|House_or|Ambulance)",
                names(combined_data), value = TRUE),
  keeping = grep("^(Kennel|Other|In_the|Chained|Inside)",
                names(combined_data), value = TRUE)
)

for(dataset_name in names(datasets_vars)) {
  vars <- datasets_vars[[dataset_name]]
  if(length(vars) > 0) {
    boxplot(scale(combined_data[, vars]), 
            main = paste(tools::toTitleCase(dataset_name), "Variables"),
            las = 2,
            cex.axis = 0.7)
  }
}
dev.off()

cat("Comprehensive analysis completed. Results saved in 'results/comprehensive' directory.\n")
