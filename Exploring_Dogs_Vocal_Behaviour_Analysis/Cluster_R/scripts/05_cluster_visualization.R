# Cluster Visualization Script
# This script creates detailed visualizations of the clustering results

# Load required packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("gridExtra")) install.packages("gridExtra")
library(tidyverse)
library(ggplot2)
library(gridExtra)

# Set base directory path
base_dir <- file.path(getwd(), "Exploring_Dogs_Vocal_Behaviour_Analysis", "Cluster_R")

# Load clustering results
load(file.path(base_dir, "results", "clustering", "clustering_results.RData"))
load(file.path(base_dir, "results", "clustering_prep", "prepared_data.RData"))

# Create directory for visualizations
dir.create(file.path(base_dir, "results", "visualizations"), recursive = TRUE, showWarnings = FALSE)

# Prepare data for visualization
cluster_data <- data.frame(
  Cluster = factor(km_result$cluster, 
                  levels = c(1, 2),
                  labels = c("Reactive Group", "Less Reactive Group")),
  combined_data
)

# Function to create behavioral profile plot
create_profile_plot <- function(data, vars, title) {
  # Calculate means by cluster
  plot_data <- data %>%
    group_by(Cluster) %>%
    summarise(across(all_of(vars), mean)) %>%
    gather(key = "Behavior", value = "Proportion", -Cluster)
  
  # Clean behavior names
  plot_data$Behavior <- gsub("_", " ", plot_data$Behavior)
  plot_data$Behavior <- tools::toTitleCase(plot_data$Behavior)
  
  # Create plot
  p <- ggplot(plot_data, aes(x = reorder(Behavior, Proportion), 
                            y = Proportion * 100, 
                            fill = Cluster)) +
    geom_bar(stat = "identity", position = "dodge") +
    coord_flip() +
    theme_minimal() +
    labs(title = title,
         x = "",
         y = "Percentage of Dogs") +
    theme(legend.position = "bottom",
          axis.text.y = element_text(size = 8))
  
  return(p)
}

# Create plots for different behavioral categories
# Human-directed behaviors
human_vars <- c("Adult_man", "Adult_woman", "A_man_with_a_beard", 
                "A_person_who_walks_unusually_limping._walking_with_a_cane._staggering",
                "Postman")
p1 <- create_profile_plot(cluster_data, human_vars, "Human-Directed Behaviors")

# Problem behaviors
problem_vars <- c("Noise_sensitive_thunder._firecrackers._etc.",
                 "Aggression_towards_other_dogs",
                 "He_she_barks_too_much",
                 "Jumps_on_people",
                 "Shy",
                 "Aggression_towards_people",
                 "Hyperactive")
p2 <- create_profile_plot(cluster_data, problem_vars, "Problem Behaviors")

# Save combined plot
png(file.path(base_dir, "results", "visualizations", "behavioral_profiles.png"),
    width = 1200, height = 800)
grid.arrange(p1, p2, ncol = 1)
dev.off()

# Create cluster size visualization
size_data <- data.frame(
  Cluster = c("Reactive Group", "Less Reactive Group"),
  Size = c(sum(km_result$cluster == 1), sum(km_result$cluster == 2))
)

p3 <- ggplot(size_data, aes(x = "", y = Size, fill = Cluster)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_void() +
  labs(title = "Distribution of Dogs Across Clusters") +
  theme(legend.position = "bottom")

ggsave(file.path(base_dir, "results", "visualizations", "cluster_distribution.png"),
       p3, width = 8, height = 8)

cat("Cluster visualizations completed. Results saved in 'results/visualizations' directory.\n")
