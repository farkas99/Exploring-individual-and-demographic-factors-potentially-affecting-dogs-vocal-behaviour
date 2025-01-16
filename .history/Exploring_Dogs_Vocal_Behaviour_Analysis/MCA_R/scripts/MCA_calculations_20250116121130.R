# MCA Calculations for Dog Vocalization Behavior Analysis
# This script performs Multiple Correspondence Analysis on different aspects of dog vocalization behavior

# Load required packages
if (!require("FactoMineR")) install.packages("FactoMineR")  # For MCA analysis
if (!require("factoextra")) install.packages("factoextra")  # For extracting and visualizing results
if (!require("missMDA")) install.packages("missMDA")        # For handling missing values
library(FactoMineR)
library(factoextra)
library(missMDA)

# Function to prepare data for MCA
prepare_data <- function(data) {
    # Remove ID column if present
    if("ID_full" %in% colnames(data)) {
        data$ID_full <- NULL
    }
    
    # Clean column names
    names(data) <- make.names(names(data), unique = TRUE)
    
    # Convert all variables to factors and handle missing values
    data[] <- lapply(data, function(x) {
        # Remove any leading/trailing whitespace
        if(is.character(x)) x <- trimws(x)
        # Convert empty strings and "NA" to NA
        x[x == "" | x == "NA"] <- NA
        # Convert to factor, including NA as a level
        factor(x, exclude = NULL)
    })
    
    return(data)
}

# Function to perform MCA with validation
perform_mca <- function(data, name) {
    tryCatch({
        # Handle missing values if present
        n_missing <- sum(is.na(data))
        if(n_missing > 0) {
            cat("\nImputing", n_missing, "missing values in", name, "dataset\n")
            data_imp <- imputeMCA(data, ncp = 2)$completeObs
            data <- data_imp
        }
        
        # Ensure all variables are properly formatted
        data <- as.data.frame(lapply(data, function(x) {
            if(!is.factor(x)) factor(x)
            else x
        }))
        
        # Perform MCA
        mca_result <- MCA(data, graph = FALSE)
        
        # Calculate eigenvalues
        eig <- get_eigenvalue(mca_result)
        
        # Save results
        save(mca_result, eig, 
             file = paste0("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/results/", name, "_mca_results.RData"))
        
        return(list(mca = mca_result, eig = eig))
    }, error = function(e) {
        cat("\nError in", name, "analysis:", conditionMessage(e), "\n")
        return(NULL)
    })
}

# Load and prepare datasets
grow_to_whom <- read.csv("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/data/raw/grow_to_whom.csv", stringsAsFactors = FALSE, na.strings = c("", "NA", "N/A"))
howl_on_sound <- read.csv("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/data/raw/howl_on_sound.csv", stringsAsFactors = FALSE, na.strings = c("", "NA", "N/A"))
keep <- read.csv("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/data/raw/keep.csv", stringsAsFactors = FALSE, na.strings = c("", "NA", "N/A"))
problems <- read.csv("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/data/raw/problems.csv", stringsAsFactors = FALSE, na.strings = c("", "NA", "N/A"))

# Prepare data for MCA
grow_data <- prepare_data(grow_to_whom)
howl_data <- prepare_data(howl_on_sound)
keep_data <- prepare_data(keep)
problems_data <- prepare_data(problems)

# Function to print summary statistics
print_mca_summary <- function(mca_result, name) {
    if(!is.null(mca_result)) {
        cat("\n=== Summary for", name, "===\n")
        print(mca_result$eig)
        print(dimdesc(mca_result))
    }
}

# Perform MCA for each behavioral aspect
cat("\nAnalyzing growling behavior patterns...\n")
grow_mca <- perform_mca(grow_data, "growling")

cat("\nAnalyzing howling behavior patterns...\n")
howl_mca <- perform_mca(howl_data, "howling")

cat("\nAnalyzing keeping conditions patterns...\n")
keep_mca <- perform_mca(keep_data, "keeping")

cat("\nAnalyzing behavioral problems patterns...\n")
problems_mca <- perform_mca(problems_data, "problems")

# Print summaries
if(!is.null(grow_mca)) print_mca_summary(grow_mca$mca, "Growling Behavior")
if(!is.null(howl_mca)) print_mca_summary(howl_mca$mca, "Howling Behavior")
if(!is.null(keep_mca)) print_mca_summary(keep_mca$mca, "Keeping Conditions")
if(!is.null(problems_mca)) print_mca_summary(problems_mca$mca, "Behavioral Problems")

# Save workspace for visualization script
save.image("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/results/mca_workspace.RData")
