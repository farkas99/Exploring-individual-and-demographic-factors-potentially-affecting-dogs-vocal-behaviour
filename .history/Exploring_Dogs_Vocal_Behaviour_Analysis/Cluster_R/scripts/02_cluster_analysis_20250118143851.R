# Cluster Analysis Script
# This script analyzes clustering feasibility and determines optimal number of clusters

# Load required packages
source("install_packages.R")
library(tidyverse)
library(cluster)
library(factoextra)
library(NbClust)

# Load preprocessed data
processed_data <- readRDS("../data/processed/processed_data.rds")
behavioral_matrix <- processed_data$behavioral_matrix

# Function to assess clustering tendency
assess_clustering_tendency <- function(data) {
  # Calculate Hopkins statistic
  set.seed(123)
  hopkins_stat <- get_clust_tendency(
    data,
    n = nrow(data) - 1,
    graph = FALSE
  )$hopkins_stat
  
  # Visual assessment of cluster tendency (VAT)
  pdf("../results/figures/clustering_tendency.pdf")
  fviz_dist(dist(data), show_labels = FALSE) +
    ggtitle("Visual Assessment of Clustering Tendency")
  dev.off()
  
  # Return Hopkins statistic
  return(hopkins_stat)
}

# Function to determine optimal number of clusters
determine_optimal_clusters <- function(data, max_k = 10) {
  # Elbow method
  pdf("../results/figures/elbow_method.pdf")
  fviz_nbclust(data, kmeans, method = "wss", k.max = max_k) +
    ggtitle("Elbow Method for Optimal k")
  dev.off()
  
  # Silhouette method
  pdf("../results/figures/silhouette_method.pdf")
