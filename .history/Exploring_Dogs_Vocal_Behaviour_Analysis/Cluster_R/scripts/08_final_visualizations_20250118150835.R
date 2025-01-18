# Final Visualization Script
# This script creates comprehensive visualizations of the clustering results

# Load required packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("gridExtra")) install.packages("gridExtra")
if (!require("reshape2")) install.packages("reshape2")
library(tidyverse)
library(ggplot2)
library(gridExtra)
library(reshape2)

# Set base directory path
base_dir <- file.path(getwd(), "Exploring_Dogs_Vocal_Behaviour_Analysis", "Cluster_R")

# Create directory for final visualizations
dir.create(file.path(base_dir, "results", "final_visualizations"), recursive = TRUE, showWarnings = FALSE)

# Load the data and clustering results
load(file.path(base_dir, "results", "comprehensive", "prepared_data.RData"))
problems_data <- read.csv(file.path(base_dir, "data", "raw", "problems.csv"))
growl_data <- read.csv(file.path(base_dir, "data", "raw", "grow_to_whom.csv"))
howl_data <- read.csv(file.path(base_dir, "data", "raw", "howl_on_sound.csv"))
keep_data <- read.csv(file.path(base_dir, "data", "raw", "keep.csv"))

# 1. Dataset Response Rates Visualization
dataset_stats <- data.frame(
  Dataset = c("Problems", "Growling", "Howling", "Keeping"),
  Variables = c(10, 9, 4, 5),
  Response_Rate = c(16.65, 15.13, 25.93, 24.42),
  Avg_Responses = c(1.66, 1.36, 1.04, 1.22)
)

p1 <- ggplot(dataset_stats, aes(x = Dataset, y = Response_Rate)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = sprintf("%.1f%%", Response_Rate)), vjust = -0.5) +
  theme_minimal() +
  labs(title = "Response Rates Across Datasets",
       y = "Response Rate (%)",
       x = "") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

p2 <- ggplot(dataset_stats, aes(x = Dataset, y = Avg_Responses)) +
  geom_bar(stat = "identity", fill = "darkgreen") +
  geom_text(aes(label = sprintf("%.2f", Avg_Responses)), vjust = -0.5) +
  theme_minimal() +
  labs(title = "Average Responses per Dog",
       y = "Average Number of Responses",
       x = "") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Save combined plot
png(file.path(base_dir, "results", "final_visualizations", "dataset_characteristics.png"),
    width = 1200, height = 500)
grid.arrange(p1, p2, ncol = 2)
dev.off()

# 2. Cluster Characteristics Heatmap
# Prepare data for heatmap
cluster_data <- data.frame(
  Cluster = km_result$cluster,
  problems_data[, -1],  # Remove ID column
  growl_data[, -1],     # Remove ID column
  howl_data[, -1],      # Remove ID column
  keep_data[, -1]       # Remove ID column
)

# Calculate mean values for each variable by cluster
cluster_means <- cluster_data %>%
  group_by(Cluster) %>%
  summarise(across(everything(), mean))

# Reshape data for heatmap
cluster_means_long <- cluster_means %>%
  gather(key = "Variable", value = "Proportion", -Cluster)

# Create heatmap
p3 <- ggplot(cluster_means_long, aes(x = factor(Cluster), y = Variable, fill = Proportion)) +
  geom_tile() +
  scale_fill_gradient2(low = "white", high = "red", mid = "pink", 
                      midpoint = 0.5, limit = c(0,1), name = "Proportion") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 8),
        axis.text.x = element_text(size = 10),
        axis.title = element_text(size = 12)) +
  labs(title = "Behavioral Characteristics by Cluster",
       x = "Cluster",
       y = "")

# Save heatmap
ggsave(file.path(base_dir, "results", "final_visualizations", "cluster_heatmap.png"),
       p3, width = 12, height = 16)

# 3. Silhouette Score Visualization
silhouette_data <- data.frame(
  k = 2:6,
  score = sil_scores
)

p4 <- ggplot(silhouette_data, aes(x = k, y = score)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  theme_minimal() +
  labs(title = "Silhouette Scores for Different Numbers of Clusters",
       x = "Number of Clusters (k)",
       y = "Silhouette Score") +
  scale_x_continuous(breaks = 2:6)

# Save silhouette plot
ggsave(file.path(base_dir, "results", "final_visualizations", "silhouette_scores.png"),
       p4, width = 8, height = 6)

# 4. Cluster Size Visualization
cluster_sizes <- data.frame(
  Cluster = c("High Reactivity\nGroup", "Typical Behavior\nGroup"),
  Size = c(519, 5068)
)

p5 <- ggplot(cluster_sizes, aes(x = "", y = Size, fill = Cluster)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_void() +
  labs(title = "Distribution of Dogs Across Clusters") +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5, size = 14))

# Save cluster size plot
ggsave(file.path(base_dir, "results", "final_visualizations", "cluster_distribution.png"),
       p5, width = 8, height = 8)

cat("Final visualizations completed. Results saved in 'results/final_visualizations' directory.\n")
