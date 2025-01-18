# Load necessary libraries
library(tidyverse)

# Set working directory
setwd("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/data/raw")

# Load datasets
grow_to_whom <- read.csv("grow_to_whom.csv")
howl_on_sound <- read.csv("howl_on_sound.csv")
keep <- read.csv("keep.csv")
problems <- read.csv("problems.csv")

# Create a folder for saving plots
output_folder <- "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/figures"
dir.create(output_folder, showWarnings = FALSE)

# Check granularity - Visualizations

# 1. Distribution of growling towards specific targets
plot1 <- ggplot(gather(grow_to_whom, key = "Target", value = "Growl", -ID_full), aes(x = Target, y = Growl)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Distribution of Growling Towards Targets") +
  ylab("Count") +
  xlab("Target")
print(plot1)  # Print plot to console
ggsave(filename = file.path(output_folder, "granularity_check_grow_to_whom.png"), plot = plot1, width = 8, height = 5)

# 2. Distribution of howling for different sounds
plot2 <- ggplot(gather(howl_on_sound, key = "Sound", value = "Howl", -ID_full), aes(x = Sound, y = Howl)) +
  geom_bar(stat = "identity", fill = "darkgreen") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Distribution of Howling for Sounds") +
  ylab("Count") +
  xlab("Sound")
print(plot2)  # Print plot to console
ggsave(filename = file.path(output_folder, "granularity_check_howl_on_sound.png"), plot = plot2, width = 8, height = 5)

# 3. Behavior distribution - Keeping location
plot3 <- ggplot(gather(keep, key = "Location", value = "Frequency", -ID_full), aes(x = Location, y = Frequency)) +
  geom_bar(stat = "identity", fill = "purple") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Distribution of Keeping Locations") +
  ylab("Count") +
  xlab("Location")
print(plot3)  # Print plot to console
ggsave(filename = file.path(output_folder, "granularity_check_keep.png"), plot = plot3, width = 8, height = 5)

# 4. Problem behaviors distribution
plot4 <- ggplot(gather(problems, key = "Problem", value = "Occurrence", -ID_full), aes(x = Problem, y = Occurrence)) +
  geom_bar(stat = "identity", fill = "orange") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Distribution of Problematic Behaviors") +
  ylab("Count") +
  xlab("Problem")
print(plot4)  # Print plot to console
ggsave(filename = file.path(output_folder, "granularity_check_problems.png"), plot = plot4, width = 8, height = 5)
