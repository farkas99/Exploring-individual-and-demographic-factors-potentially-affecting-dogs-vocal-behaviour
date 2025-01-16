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
    # Convert all variables to factors (categorical)
    # In ethological studies, binary data is often treated as categorical
    data[] <- lapply(data, function(x) {
        # Remove any leading/trailing whitespace
        if(is.character(x)) x <- trimws(x)
        # Convert empty strings to NA
        x[x == ""] <- NA
        # Convert to factor, excluding NA values
        factor(x, exclude = NULL)
    })
    return(data)
}

# Function to perform MCA with validation
perform_mca <- function(data, name) {
    # Handle missing values
    cat("\nChecking for missing values in", name, "dataset...\n")
    n_missing <- sum(is.na(data))
    if(n_missing > 0) {
        cat("Found", n_missing, "missing values\n")
        # Impute missing values
        data_imp <- imputeMCA(data, ncp = 2)$completeObs
        data <- data_imp
    }
    
    # Calculate number of dimensions to retain
    # Using cross-validation method common in behavioral studies
    tryCatch({
        nb <- estim_ncpMCA(data, ncp.min = 1, ncp.max = 5, method = "Regularized")
        
        # Perform MCA
        # ncp = number of dimensions to retain (based on cross-validation)
        mca_result <- MCA(data, ncp = nb$ncp, graph = FALSE)
        
        # Calculate eigenvalues and their contributions
        eig <- get_eigenvalue(mca_result)
        
        # Save results with full path
        save(mca_result, eig, 
             file = paste0("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/results/", name, "_mca_results.RData"))
        
        # Return results for further analysis
        return(list(mca = mca_result, eig = eig))
    }, error = function(e) {
        cat("\nError in", name, "analysis:", conditionMessage(e), "\n")
        return(NULL)
    })
}

# Load the datasets with full paths
grow_to_whom <- read.csv("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/data/raw/grow_to_whom.csv", na.strings = c("", "NA", "N/A"))
howl_on_sound <- read.csv("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/data/raw/howl_on_sound.csv", na.strings = c("", "NA", "N/A"))
keep <- read.csv("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/data/raw/keep.csv", na.strings = c("", "NA", "N/A"))
problems <- read.csv("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/data/raw/problems.csv", na.strings = c("", "NA", "N/A"))

# Remove ID column as it's not relevant for MCA
grow_to_whom$ID_full <- NULL
howl_on_sound$ID_full <- NULL
keep$ID_full <- NULL
problems$ID_full <- NULL

# Prepare data for MCA
grow_data <- prepare_data(grow_to_whom)
howl_data <- prepare_data(howl_on_sound)
keep_data <- prepare_data(keep)
problems_data <- prepare_data(problems)

# Function to print summary statistics
print_mca_summary <- function(mca_result, name) {
    if(!is.null(mca_result)) {
        cat("\n=== Summary for", name, "===\n")
        # Print eigenvalues and variance explained
        print(mca_result$eig)
        # Print most contributing categories
        print(dimdesc(mca_result))
    }
}

# Perform MCA for each behavioral aspect
# 1. Growling behavior
cat("\nAnalyzing growling behavior patterns...\n")
grow_mca <- perform_mca(grow_data, "growling")

# 2. Howling behavior
cat("\nAnalyzing howling behavior patterns...\n")
howl_mca <- perform_mca(howl_data, "howling")

# 3. Keeping conditions
cat("\nAnalyzing keeping conditions patterns...\n")
keep_mca <- perform_mca(keep_data, "keeping")

# 4. Behavioral problems
cat("\nAnalyzing behavioral problems patterns...\n")
problems_mca <- perform_mca(problems_data, "problems")

# Print summaries
if(!is.null(grow_mca)) print_mca_summary(grow_mca$mca, "Growling Behavior")
if(!is.null(howl_mca)) print_mca_summary(howl_mca$mca, "Howling Behavior")
if(!is.null(keep_mca)) print_mca_summary(keep_mca$mca, "Keeping Conditions")
if(!is.null(problems_mca)) print_mca_summary(problems_mca$mca, "Behavioral Problems")

# Save workspace for visualization script with full path
save.image("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/results/mca_workspace.RData")
