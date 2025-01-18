# Set working directory
setwd("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/data/raw")

# Load datasets with corrected paths
grow_to_whom <- read.csv("grow_to_whom.csv")
howl_on_sound <- read.csv("howl_on_sound.csv")
keep <- read.csv("keep.csv")
problems <- read.csv("problems.csv")

# Preview the datasets
head(grow_to_whom)
head(howl_on_sound)
head(keep)
head(problems)

# Check structure of datasets
str(grow_to_whom)
str(howl_on_sound)
str(keep)
str(problems)


# Summary statistics for numerical columns
summary(grow_to_whom)
summary(howl_on_sound)
summary(keep)
summary(problems)

# Visualizations for granularity check

# 1. Distribution of growling towards specific targets
ggplot(gather(grow_to_whom, key = "Target", value = "Growl", -ID_full), aes(x = Target, y = Growl)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Distribution of Growling Towards Targets") +
  ylab("Count") +
  xlab("Target")

# 2. Howling for different sounds
ggplot(gather(howl_on_sound, key = "Sound", value = "Howl", -ID_full), aes(x = Sound, y = Howl)) +
  geom_bar(stat = "identity", fill = "darkgreen") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Distribution of Howling for Sounds") +
  ylab("Count") +
  xlab("Sound")

# 3. Behavior distribution (keeping location)
ggplot(gather(keep, key = "Location", value = "Frequency", -ID_full), aes(x = Location, y = Frequency)) +
  geom_bar(stat = "identity", fill = "purple") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Distribution of Keeping Locations") +
  ylab("Count") +
  xlab("Location")

# 4. Problem behaviors
ggplot(gather(problems, key = "Problem", value = "Occurrence", -ID_full), aes(x = Problem, y = Occurrence)) +
  geom_bar(stat = "identity", fill = "orange") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Distribution of Problematic Behaviors") +
  ylab("Count") +
  xlab("Problem")

