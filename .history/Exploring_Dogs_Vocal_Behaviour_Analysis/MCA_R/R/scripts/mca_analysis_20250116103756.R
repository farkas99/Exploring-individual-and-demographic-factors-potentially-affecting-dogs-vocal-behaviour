library(FactoMineR)
library(factoextra)

# Load the data files
grow_to_whom <- read.csv("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/R/data/raw/grow_to_whom.csv")
howl_on_sound <- read.csv("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/R/data/raw/howl_on_sound.csv")
keep <- read.csv("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/R/data/raw/keep.csv")
problems <- read.csv("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/R/data/raw/problems.csv")

# Perform MCA on each dataset
mca_grow_to_whom <- MCA(grow_to_whom, graph = FALSE)
mca_howl_on_sound <- MCA(howl_on_sound, graph = FALSE)
mca_keep <- MCA(keep, graph = FALSE)
mca_problems <- MCA(problems, graph = FALSE)

# Save the MCA results
save(mca_grow_to_whom, file = "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/R/results/mca_grow_to_whom.RData")
save(mca_howl_on_sound, file = "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/R/results/mca_howl_on_sound.RData")
save(mca_keep, file = "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/R/results/mca_keep.RData")
save(mca_problems, file = "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/R/results/mca_problems.RData")
