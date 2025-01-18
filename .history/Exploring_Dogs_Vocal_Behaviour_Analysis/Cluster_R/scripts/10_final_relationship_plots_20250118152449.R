# Final Relationship Visualization Script
# This script creates comprehensive visualizations of dataset relationships

# Load required packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("gridExtra")) install.packages("gridExtra")
if (!require("reshape2")) install.packages("reshape2")
if (!require("viridis")) install.packages("viridis")
library(tidyverse)
library(ggplot2)
library(gridExtra)
library(reshape2)
library(viridis)

# Set base directory path
base_dir <- file.path(getwd(), "Exploring_Dogs_Vocal_Behaviour_Analysis", "Cluster_R")

# Create directory for final visualizations
dir.create(file.path(base_dir, "results", "final_visualizations"), recursive = TRUE, showWarnings = FALSE)

# Dataset response patterns
response_data <- data.frame(
  Dataset = rep(c("Problems", "Growling", "Howling", "Keeping"), each = 3),
  Response_Type = rep(c("No Response", "Single Response", "Multiple Responses"), 4),
  Percentage = c(
    # Problems
    0.0, 60.0, 40.0,
    # Growling
    16.7, 59.7, 23.6,
    # Howling
    0.0, 96.9, 3.1,
    # Keeping
    0.0, 78.9, 21.1
  )
)

# 1. Response Pattern Visualization
p1 <- ggplot(response_data, aes(x = Dataset, y = Percentage, fill = Response_Type)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_viridis(discrete = TRUE) +
  theme_minimal() +
  labs(title = "Response Patterns Across Datasets",
       y = "Percentage of Dogs",
       x = "") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom",
        plot.title = element_text(hjust = 0.5))

# Save response pattern plot
ggsave(file.path(base_dir, "results", "final_visualizations", "response_patterns_stacked.png"),
       p1, width = 10, height = 8)

# 2. Dataset Complexity Visualization
complexity_data <- data.frame(
  Dataset = c("Problems", "Growling", "Howling", "Keeping"),
  Variables = c(10, 9, 4, 5),
  Avg_Responses = c(1.66, 1.36, 1.04, 1.22),
  Max_Responses = c(8, 8, 4, 4),
  Multiple_Response_Rate = c(40.0, 23.6, 3.1, 21.1)
)

# Prepare data for radar chart
radar_data <- data.frame(
  Dataset = complexity_data$Dataset,
  Variables_Scaled = scale(complexity_data$Variables)[,1],
  Avg_Responses_Scaled = scale(complexity_data$Avg_Responses)[,1],
  Max_Responses_Scaled = scale(complexity_data$Max_Responses)[,1],
  Multiple_Response_Rate_Scaled = scale(complexity_data$Multiple_Response_Rate)[,1]
)

# Melt data for radar chart
radar_melted <- melt(radar_data, id.vars = "Dataset")

# Create radar chart
p2 <- ggplot(radar_melted, aes(x = variable, y = value, color = Dataset, group = Dataset)) +
  geom_polygon(aes(fill = Dataset), alpha = 0.2) +
  geom_line() +
  coord_polar() +
  theme_minimal() +
  labs(title = "Dataset Complexity Comparison",
       x = "",
       y = "") +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5))

# Save complexity comparison plot
ggsave(file.path(base_dir, "results", "final_visualizations", "dataset_complexity.png"),
       p2, width = 10, height = 10)

# 3. Correlation Network Visualization
correlation_data <- data.frame(
  pair = c("Problems-Growling", "Problems-Howling", "Problems-Keeping",
           "Growling-Howling", "Growling-Keeping", "Howling-Keeping"),
  correlation = c(0.254, 0.034, 0.014, 0.044, 0.006, 0.040)
)

# Create network-style visualization
p3 <- ggplot(correlation_data, aes(x = pair, y = correlation)) +
  geom_segment(aes(x = pair, xend = pair, y = 0, yend = correlation),
               color = "grey50", size = 1) +
  geom_point(size = 5, aes(color = correlation)) +
  scale_color_viridis() +
  theme_minimal() +
  labs(title = "Dataset Correlations",
       x = "",
       y = "Correlation Strength") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5))

# Save correlation network plot
ggsave(file.path(base_dir, "results", "final_visualizations", "correlation_network.png"),
       p3, width = 12, height = 8)

# 4. Combined Metrics Plot
metrics_long <- melt(complexity_data, id.vars = "Dataset")

p4 <- ggplot(metrics_long, aes(x = Dataset, y = value, fill = variable)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_viridis(discrete = TRUE) +
  theme_minimal() +
  labs(title = "Dataset Metrics Comparison",
       x = "",
       y = "Value",
       fill = "Metric") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom",
        plot.title = element_text(hjust = 0.5))

# Save combined metrics plot
ggsave(file.path(base_dir, "results", "final_visualizations", "dataset_metrics.png"),
       p4, width = 12, height = 8)

# Create summary plot combining key visualizations
png(file.path(base_dir, "results", "final_visualizations", "dataset_analysis_summary.png"),
    width = 1800, height = 1800)
grid.arrange(p1, p2, p3, p4, ncol = 2,
             top = "Comprehensive Dataset Analysis")
dev.off()

cat("Final relationship visualizations completed. Results saved in 'results/final_visualizations' directory.\n")
