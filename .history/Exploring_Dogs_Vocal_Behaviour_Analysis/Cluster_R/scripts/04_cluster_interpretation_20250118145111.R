# Cluster Interpretation Script
# This script creates detailed visualizations and interpretations of the clustering results

# Load required packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("reshape2")) install.packages("reshape2")
if (!require("ggplot2")) install.packages("ggplot2")
library(tidyverse)
library(reshape2)
library(ggplot2)

# Set base directory path
base_dir <- file.path(getwd(), "Exploring_Dogs_Vocal_Behaviour_Analysis", "Cluster_R")

# Load clustering results
load(file.path(base_dir, "results", "clustering", "clustering_results.RData"))
load(file.path(base_dir, "results", "clustering_prep", "prepared_data.RData"))

# Create directory for interpretation results
dir.create(file.path(base_dir, "results", "interpretation"), recursive = TRUE, showWarnings = FALSE)

# Function to create and save characteristic plots
create_characteristic_plot <- function(cluster_means, characteristic_type) {
  # Prepare data for plotting
  plot_data <- cluster_means %>%
    select(starts_with(characteristic_type)) %>%
    gather(key = "Variable", value = "Mean")
  
  # Clean variable names for plotting
  plot_data$Variable <- gsub("_", " ", plot_data$Variable)
  plot_data$Variable <- tools::toTitleCase(plot_data$Variable)
  
  # Create plot
  p <- ggplot(plot_data, aes(x = reorder(Variable, Mean), y = Mean)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    coord_flip() +
    theme_minimal() +
    labs(title = paste(tools::toTitleCase(characteristic_type), "Characteristics by Cluster"),
         x = "",
         y = "Mean Probability") +
    theme(axis.text.y = element_text(size = 8))
  
  # Save plot
  ggsave(file.path(base_dir, "results", "interpretation", 
                   paste0(characteristic_type, "_characteristics.png")),
         p, width = 10, height = 6)
  
  return(p)
}

# Create cluster profiles with original data
cluster_data <- data.frame(
  Cluster = km_result$cluster,
  combined_data
)

# Calculate proportions for each variable by cluster
cluster_proportions <- data.frame(
  Variable = names(combined_data),
  Cluster1 = colMeans(combined_data[km_result$cluster == 1, ]),
  Cluster2 = colMeans(combined_data[km_result$cluster == 2, ])
)

# Create detailed interpretation report
sink(file.path(base_dir, "results", "interpretation", "cluster_interpretation.txt"))

cat("Detailed Cluster Interpretation\n")
cat("============================\n\n")

cat("Overview\n")
cat("--------\n")
cat("The analysis revealed two distinct clusters of dogs:\n")
cat("Cluster 1:", nrow(cluster_data[cluster_data$Cluster == 1,]), "dogs (", 
    round(nrow(cluster_data[cluster_data$Cluster == 1,])/nrow(cluster_data)*100, 1), "%)\n")
cat("Cluster 2:", nrow(cluster_data[cluster_data$Cluster == 2,]), "dogs (",
    round(nrow(cluster_data[cluster_data$Cluster == 2,])/nrow(cluster_data)*100, 1), "%)\n\n")

cat("Cluster Characteristics\n")
cat("----------------------\n")

# Function to describe cluster characteristics
describe_cluster <- function(cluster_num) {
  cat(paste("\nCluster", cluster_num, "Characteristics:\n"))
  
  # Get top 5 most prevalent characteristics
  cluster_col <- paste0("Cluster", cluster_num)
  top_chars <- cluster_proportions[order(cluster_proportions[[cluster_col]], decreasing = TRUE), ][1:5, ]
  
  cat("\nMost prevalent characteristics:\n")
  for(i in 1:5) {
    cat(sprintf("%d. %s (%.1f%%)\n", 
                i,
                gsub("_", " ", top_chars$Variable[i]),
                top_chars[[cluster_col]][i] * 100))
  }
  cat("\n")
}

# Describe each cluster
describe_cluster(1)
describe_cluster(2)

cat("\nBehavioral Differences Between Clusters\n")
cat("-----------------------------------\n")

# Calculate and display differences between clusters
differences <- data.frame(
  Variable = cluster_proportions$Variable,
  Difference = cluster_proportions$Cluster1 - cluster_proportions$Cluster2
)
differences <- differences[order(abs(differences$Difference), decreasing = TRUE), ]

cat("\nMost distinctive characteristics (largest differences between clusters):\n")
for(i in 1:5) {
  cat(sprintf("%d. %s (%.1f%% difference)\n",
              i,
              gsub("_", " ", differences$Variable[i]),
              differences$Difference[i] * 100))
}

sink()

# Create visualization of cluster differences
diff_plot_data <- differences %>%
  head(10) %>%  # Top 10 differences
  mutate(Variable = gsub("_", " ", Variable))

p <- ggplot(diff_plot_data, aes(x = reorder(Variable, abs(Difference)), y = Difference)) +
  geom_bar(stat = "identity", aes(fill = Difference > 0)) +
  coord_flip() +
  theme_minimal() +
  labs(title = "Top 10 Differences Between Clusters",
       x = "",
       y = "Difference in Proportion (Cluster 1 - Cluster 2)") +
  theme(legend.position = "none")

ggsave(file.path(base_dir, "results", "interpretation", "cluster_differences.png"),
       p, width = 12, height = 8)

cat("Cluster interpretation completed. Results saved in 'results/interpretation' directory.\n")
