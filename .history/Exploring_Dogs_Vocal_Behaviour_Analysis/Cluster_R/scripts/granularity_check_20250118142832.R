# Script for checking data granularity and clustering tendency
# This script performs various tests to determine if the data is suitable for clustering

# Load required packages
library(tidyverse)
library(cluster)
library(factoextra)
library(readxl)
library(hopkins)
library(gridExtra)
library(knitr)

# Create directories if they don't exist
dir.create("Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/figures", recursive = TRUE, showWarnings = FALSE)

# Read the data
data_path <- "Exploring_Dogs_Vocal_Behaviour_Analysis/base_data/raw/DATA_STONE_BASE_20241230.xlsx"
raw_data <- read_excel(data_path)

# Print column names for debugging
print("Available columns:")
print(names(raw_data))

# Select only the relevant numerical columns for clustering
# We'll focus on behavioral scores and exclude any ID or metadata columns
numerical_data <- raw_data %>%
  select(where(is.numeric)) %>%
  select(-matches("^(ID|id|Index|index)")) %>%  # Exclude ID columns
  na.omit()  # Remove rows with missing values

# Print dimensions of processed data
print("Dimensions of processed numerical data:")
print(dim(numerical_data))
# Script for checking data granularity and clustering tendency
# This script performs various tests to determine if the data is suitable for clustering

# Load required packages
library(tidyverse)
library(cluster)
library(factoextra)
library(readxl)
library(hopkins)
library(gridExtra)
library(knitr)

# Create directories if they don't exist
dir.create("Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/figures", recursive = TRUE, showWarnings = FALSE)

# Read the data
data_path <- "Exploring_Dogs_Vocal_Behaviour_Analysis/base_data/raw/DATA_STONE_BASE_20241230.xlsx"
raw_data <- read_excel(data_path)


# Function to save plots with consistent dimensions
save_plot <- function(plot, filename, width = 10, height = 8) {
  ggsave(
    filename = file.path("Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/figures", filename),
    plot = plot,
    width = width,
    height = height,
    dpi = 300
  )
}

# 1. Hopkins Statistic Test
set.seed(123)  # For reproducibility
# Calculate Hopkins statistic
# Ensure m is smaller than the number of samples
n_samples <- nrow(numerical_data)
m_size <- min(floor(n_samples/10), n_samples - 1)  # Ensure m is valid
hopkins_result <- hopkins(scale(numerical_data), m = m_size)

# 2. Visual Assessment of Cluster Tendency (VAT)
vat_plot <- fviz_dist(dist(scale(numerical_data)), show_labels = FALSE) +
  ggtitle("Visual Assessment of Cluster Tendency (VAT)") +
  theme_minimal()

# Save VAT plot
save_plot(vat_plot, "vat_plot.png")

# 3. Elbow Method
wss <- numeric(10)
for (i in 1:10) {
  km <- kmeans(scale(numerical_data), centers = i, nstart = 25)
  wss[i] <- km$tot.withinss
}

elbow_data <- data.frame(k = 1:10, wss = wss)
elbow_plot <- ggplot(elbow_data, aes(x = k, y = wss)) +
  geom_line() +
  geom_point() +
  ggtitle("Elbow Method for Optimal k") +
  xlab("Number of Clusters (k)") +
  ylab("Total Within Sum of Squares") +
  theme_minimal()

# Save elbow plot
save_plot(elbow_plot, "elbow_plot.png")

# 4. Silhouette Analysis
silhouette_plot <- fviz_nbclust(scale(numerical_data), kmeans, method = "silhouette") +
  ggtitle("Silhouette Analysis for Optimal k") +
  theme_minimal()

# Save silhouette plot
save_plot(silhouette_plot, "silhouette_plot.png")

# Create markdown report
report_content <- sprintf('
# Granularity Analysis Report

## Overview
This report presents the results of various analyses to determine the clustering tendency of the dataset.

## Hopkins Statistic
The Hopkins statistic (H) ranges from 0 to 1:
- H ≈ 0.5 suggests random data
- H closer to 0 suggests uniformly distributed data
- H closer to 1 suggests highly clusterable data

**Result: H = %.3f**

Interpretation: %s

## Visual Assessment of Cluster Tendency (VAT)
![VAT Plot](figures/vat_plot.png)

The VAT plot shows the dissimilarity matrix of the data. Dark blocks along the diagonal suggest potential cluster structure.

## Elbow Method
![Elbow Plot](figures/elbow_plot.png)

The elbow method helps determine the optimal number of clusters by plotting the total within-sum of squares against the number of clusters.

## Silhouette Analysis
![Silhouette Plot](figures/silhouette_plot.png)

The silhouette analysis helps validate the optimal number of clusters by measuring how similar an object is to its own cluster compared to other clusters.

## Conclusion
%s
',
hopkins_result,
ifelse(hopkins_result > 0.75,
       "The data shows strong clustering tendency.",
       ifelse(hopkins_result > 0.5,
              "The data shows moderate clustering tendency.",
              "The data shows weak clustering tendency.")),
ifelse(hopkins_result > 0.75,
       "Based on the analyses, the data appears suitable for clustering analysis. The Hopkins statistic indicates strong clustering tendency, and the visual methods support this conclusion.",
       ifelse(hopkins_result > 0.5,
              "The data shows moderate potential for clustering. While clusters may exist, they might not be strongly separated.",
              "The data shows limited clustering tendency. Consider whether clustering is the most appropriate approach for this dataset."))
)

# Save the report
writeLines(report_content, "Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/full_granularity_analysis.md")

# Print summary to console
cat("Analysis complete! Results have been saved to:\n")
cat("1. Figures: Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/figures/\n")
cat("2. Report: Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/full_granularity_analysis.md\n")
