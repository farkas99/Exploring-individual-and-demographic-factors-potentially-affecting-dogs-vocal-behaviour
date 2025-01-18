# Analysis of relationship between clusters and vocalization patterns
# This script examines how vocalization patterns differ between the identified clusters

# Load required packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("gridExtra")) install.packages("gridExtra")
library(tidyverse)
library(ggplot2)
library(gridExtra)

# Set base directory path
base_dir <- file.path(getwd(), "Exploring_Dogs_Vocal_Behaviour_Analysis", "Cluster_R")

# Load clustering results and data
load(file.path(base_dir, "results", "clustering", "clustering_results.RData"))
howl_data <- read.csv(file.path(base_dir, "data", "raw", "howl_on_sound.csv"))

# Create directory for vocalization analysis
dir.create(file.path(base_dir, "results", "vocalization"), recursive = TRUE, showWarnings = FALSE)

# Combine cluster assignments with howling data
vocal_data <- data.frame(
  Cluster = factor(km_result$cluster, 
                  levels = c(1, 2),
                  labels = c("Reactive Group", "Less Reactive Group")),
  howl_data[, -1]  # Remove ID column
)

# Calculate proportions for each vocalization trigger by cluster
vocal_proportions <- vocal_data %>%
  group_by(Cluster) %>%
  summarise(across(everything(), mean)) %>%
  gather(key = "Trigger", value = "Proportion", -Cluster)

# Clean trigger names for plotting
vocal_proportions$Trigger <- gsub("\\.", " ", vocal_proportions$Trigger)
vocal_proportions$Trigger <- gsub("_", " ", vocal_proportions$Trigger)
vocal_proportions$Trigger <- tools::toTitleCase(vocal_proportions$Trigger)

# Create visualization of howling patterns
p1 <- ggplot(vocal_proportions, 
             aes(x = reorder(Trigger, Proportion),
                 y = Proportion * 100,
                 fill = Cluster)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Vocalization Triggers by Cluster",
       subtitle = "Percentage of dogs that howl in response to different triggers",
       x = "",
       y = "Percentage of Dogs",
       fill = "Cluster") +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))

# Save plot
ggsave(file.path(base_dir, "results", "vocalization", "vocalization_patterns.png"),
       p1, width = 12, height = 8)

# Statistical analysis
# Chi-square test for each trigger
chi_square_results <- lapply(names(vocal_data)[-1], function(trigger) {
  contingency_table <- table(vocal_data$Cluster, vocal_data[[trigger]])
  test_result <- chisq.test(contingency_table)
  # Calculate Cramer's V
  n <- sum(contingency_table)
  cramers_v <- sqrt(test_result$statistic / (n * (min(dim(contingency_table)) - 1)))
  return(list(trigger = trigger, 
             statistic = test_result$statistic,
             p_value = test_result$p.value,
             cramers_v = cramers_v))
})

# Save statistical results
sink(file.path(base_dir, "results", "vocalization", "vocalization_analysis.txt"))

cat("Vocalization Pattern Analysis\n")
cat("===========================\n\n")

cat("1. Overall Distribution of Dogs in Clusters\n")
cat("----------------------------------------\n")
print(table(vocal_data$Cluster))
cat("\n")

cat("2. Howling Response Patterns\n")
cat("-------------------------\n")
for(cluster in levels(vocal_data$Cluster)) {
  cat(sprintf("\n%s:\n", cluster))
  cluster_props <- vocal_proportions[vocal_proportions$Cluster == cluster,]
  cluster_props <- cluster_props[order(cluster_props$Proportion, decreasing = TRUE),]
  for(i in 1:nrow(cluster_props)) {
    cat(sprintf("%s: %.1f%%\n", 
                cluster_props$Trigger[i],
                cluster_props$Proportion[i] * 100))
  }
}

cat("\n3. Statistical Analysis\n")
cat("---------------------\n")
for(result in chi_square_results) {
  cat(sprintf("\nTrigger: %s\n", gsub("\\.", " ", result$trigger)))
  cat(sprintf("Chi-square statistic: %.2f\n", result$statistic))
  cat(sprintf("p-value: %.4f\n", result$p_value))
  cat(sprintf("Effect size (Cramer's V): %.3f\n", result$cramers_v))
  cat(sprintf("Effect interpretation: %s\n", 
              ifelse(result$cramers_v < 0.1, "Negligible",
                     ifelse(result$cramers_v < 0.3, "Small",
                            ifelse(result$cramers_v < 0.5, "Medium", "Large")))))
}

cat("\n4. Summary of Findings\n")
cat("-------------------\n")
cat("- The analysis examined differences in howling patterns between reactive and less reactive dogs\n")
cat("- Statistical tests were performed to assess the significance of these differences\n")
cat("- Effect sizes (Cramer's V) were calculated to measure the strength of associations\n")

sink()

