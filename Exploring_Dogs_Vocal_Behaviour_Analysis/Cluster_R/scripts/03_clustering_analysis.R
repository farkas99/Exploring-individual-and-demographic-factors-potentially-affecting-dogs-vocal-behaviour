# Clustering Analysis Script
# This script performs both k-means and hierarchical clustering

# Load required packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("cluster")) install.packages("cluster")
if (!require("factoextra")) install.packages("factoextra")
if (!require("dendextend")) install.packages("dendextend")
library(tidyverse)
library(cluster)
library(factoextra)
library(dendextend)

# Set base directory path
base_dir <- file.path(getwd(), "Exploring_Dogs_Vocal_Behaviour_Analysis", "Cluster_R")

# Load prepared data
load(file.path(base_dir, "results", "clustering_prep", "prepared_data.RData"))

# Create directory for clustering results
dir.create(file.path(base_dir, "results", "clustering"), recursive = TRUE, showWarnings = FALSE)

# Determine optimal number of clusters using multiple methods
# 1. Elbow method
set.seed(123)
wss <- sapply(1:10, function(k) {
  kmeans(scaled_data, centers = k, nstart = 25)$tot.withinss
})

# Save elbow plot
png(file.path(base_dir, "results", "clustering", "elbow_plot.png"),
    width = 800, height = 600)
plot(1:10, wss, type = "b", pch = 19,
     xlab = "Number of clusters (k)",
     ylab = "Total within-cluster sum of squares",
     main = "Elbow Method for Optimal k")
dev.off()

# 2. Silhouette method (already calculated in preparation script)
# Save detailed silhouette plot for optimal k
optimal_k <- which.max(sil_width) + 1
cat("Optimal number of clusters based on silhouette width:", optimal_k, "\n")

# Perform k-means clustering with optimal k
set.seed(123)
km_result <- kmeans(scaled_data, centers = optimal_k, nstart = 25)

# Save cluster visualization
png(file.path(base_dir, "results", "clustering", "kmeans_clusters.png"),
    width = 1000, height = 800)
fviz_cluster(km_result, data = scaled_data,
             ellipse.type = "convex",
             palette = "jco",
             ggtheme = theme_minimal())
dev.off()

# Perform hierarchical clustering
# Calculate distance matrix
dist_matrix <- dist(scaled_data, method = "euclidean")
hc_result <- hclust(dist_matrix, method = "ward.D2")

# Save dendrogram
png(file.path(base_dir, "results", "clustering", "dendrogram.png"),
    width = 1200, height = 800)
dend <- as.dendrogram(hc_result)
dend <- color_branches(dend, k = optimal_k)
plot(dend,
     main = "Hierarchical Clustering Dendrogram",
     ylab = "Height")
rect.hclust(hc_result, k = optimal_k, border = 2:5)
dev.off()

# Cut hierarchical clustering tree to get cluster assignments
hc_clusters <- cutree(hc_result, k = optimal_k)

# Compare clustering results
cluster_comparison <- table(kmeans = km_result$cluster, 
                          hierarchical = hc_clusters)

# Analyze cluster characteristics
cluster_profiles <- data.frame(
  cluster = km_result$cluster,
  combined_data
)

# Calculate mean values for each variable by cluster
cluster_means <- cluster_profiles %>%
  group_by(cluster) %>%
  summarise(across(everything(), mean)) %>%
  select(-cluster)

# Save cluster profiles
write.csv(cluster_means, 
          file.path(base_dir, "results", "clustering", "cluster_profiles.csv"))

# Save clustering comparison
write.csv(cluster_comparison,
          file.path(base_dir, "results", "clustering", "clustering_comparison.csv"))

# Create summary report
sink(file.path(base_dir, "results", "clustering", "clustering_summary.txt"))

cat("Clustering Analysis Summary\n")
cat("=========================\n\n")

cat("1. Optimal Number of Clusters\n")
cat("---------------------------\n")
cat("Based on silhouette analysis:", optimal_k, "\n\n")

cat("2. K-means Clustering Results\n")
cat("---------------------------\n")
cat("Cluster sizes:\n")
print(table(km_result$cluster))
cat("\n")

cat("3. Hierarchical Clustering Results\n")
cat("--------------------------------\n")
cat("Cluster sizes:\n")
print(table(hc_clusters))
cat("\n")

cat("4. Clustering Comparison\n")
cat("----------------------\n")
print(cluster_comparison)
cat("\n")

cat("5. Cluster Profiles\n")
cat("-----------------\n")
print(cluster_means)

sink()

# Save all results
save(km_result, hc_result, hc_clusters, cluster_means, cluster_comparison,
     file = file.path(base_dir, "results", "clustering", "clustering_results.RData"))

cat("Clustering analysis completed. Results saved in 'results/clustering' directory.\n")
