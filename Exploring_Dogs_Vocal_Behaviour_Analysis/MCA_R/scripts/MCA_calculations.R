# MCA Calculations for Dog Vocalization Behavior Analysis
# This script performs Multiple Correspondence Analysis on different aspects of dog vocalization behavior

cat("Starting MCA analysis script...\n")

# Load required packages with error handling
load_package <- function(package_name) {
    cat("Loading package:", package_name, "...\n")
    if (!require(package_name, character.only = TRUE)) {
        cat("Installing package:", package_name, "\n")
        install.packages(package_name)
        if (!require(package_name, character.only = TRUE)) {
            stop("Failed to load package: ", package_name)
        }
    }
    cat("Successfully loaded:", package_name, "\n")
}

# Load required packages
load_package("FactoMineR")
load_package("factoextra")
load_package("missMDA")

# Function to prepare data for MCA
prepare_data <- function(data) {
    cat("Preparing data...\n")
    # Print initial data structure
    cat("Initial data structure:\n")
    print(str(data))
    
    # Remove ID column if present
    if("ID_full" %in% colnames(data)) {
        cat("Removing ID_full column...\n")
        data$ID_full <- NULL
    }
    
    # Clean column names
    cat("Original column names:", paste(names(data), collapse=", "), "\n")
    names(data) <- make.names(names(data), unique = TRUE)
    cat("Cleaned column names:", paste(names(data), collapse=", "), "\n")
    
    # Convert all variables to factors and handle missing values
    cat("Converting variables to factors...\n")
    data[] <- lapply(data, function(x) {
        if(is.character(x)) x <- trimws(x)
        x[x == "" | x == "NA"] <- NA
        factor(x, exclude = NULL)
    })
    
    cat("Final data structure:\n")
    print(str(data))
    return(data)
}

# Function to perform MCA with validation
perform_mca <- function(data, name) {
    cat("\nPerforming MCA for", name, "...\n")
    tryCatch({
        # Handle missing values if present
        n_missing <- sum(is.na(data))
        if(n_missing > 0) {
            cat("Found", n_missing, "missing values in", name, "dataset\n")
            cat("Imputing missing values...\n")
            data_imp <- imputeMCA(data, ncp = 2)$completeObs
            data <- data_imp
        }
        
        # Ensure all variables are properly formatted
        cat("Checking variable formats...\n")
        data <- as.data.frame(lapply(data, function(x) {
            if(!is.factor(x)) {
                cat("Converting non-factor variable to factor\n")
                factor(x)
            } else x
        }))
        
        # Print data summary before MCA
        cat("Data summary before MCA:\n")
        print(summary(data))
        
        # Perform MCA
        cat("Running MCA...\n")
        mca_result <- MCA(data, graph = FALSE)
        
        # Calculate eigenvalues
        cat("Calculating eigenvalues...\n")
        eig <- get_eigenvalue(mca_result)
        
        # Save results
        result_path <- paste0("C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/results/", name, "_mca_results.RData")
        cat("Saving results to:", result_path, "\n")
        save(mca_result, eig, file = result_path)
        
        return(list(mca = mca_result, eig = eig))
    }, error = function(e) {
        cat("\nError in", name, "analysis:", conditionMessage(e), "\n")
        cat("Error details:\n")
        print(e)
        return(NULL)
    })
}

# Load datasets with error handling
load_data <- function(file_path) {
    cat("\nLoading data from:", file_path, "...\n")
    tryCatch({
        data <- read.csv(file_path, stringsAsFactors = FALSE, na.strings = c("", "NA", "N/A"))
        cat("Successfully loaded data. Dimensions:", nrow(data), "rows,", ncol(data), "columns\n")
        return(data)
    }, error = function(e) {
        cat("Error loading data:", conditionMessage(e), "\n")
        stop("Failed to load data from: ", file_path)
    })
}

# Base path for data files
base_path <- "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/data/raw/"

# Load datasets
cat("\nLoading datasets...\n")
grow_to_whom <- load_data(paste0(base_path, "grow_to_whom.csv"))
howl_on_sound <- load_data(paste0(base_path, "howl_on_sound.csv"))
keep <- load_data(paste0(base_path, "keep.csv"))
problems <- load_data(paste0(base_path, "problems.csv"))

# Prepare data for MCA
cat("\nPreparing datasets for MCA...\n")
grow_data <- prepare_data(grow_to_whom)
howl_data <- prepare_data(howl_on_sound)
keep_data <- prepare_data(keep)
problems_data <- prepare_data(problems)

# Function to print summary statistics
print_mca_summary <- function(mca_result, name) {
    if(!is.null(mca_result)) {
        cat("\n=== Summary for", name, "===\n")
        cat("Eigenvalues:\n")
        print(mca_result$eig)
        cat("\nDimension description:\n")
        print(dimdesc(mca_result))
    }
}

# Perform MCA for each behavioral aspect
cat("\nPerforming MCA analyses...\n")

cat("\nAnalyzing growling behavior patterns...\n")
grow_mca <- perform_mca(grow_data, "growling")

cat("\nAnalyzing howling behavior patterns...\n")
howl_mca <- perform_mca(howl_data, "howling")

cat("\nAnalyzing keeping conditions patterns...\n")
keep_mca <- perform_mca(keep_data, "keeping")

cat("\nAnalyzing behavioral problems patterns...\n")
problems_mca <- perform_mca(problems_data, "problems")

# Print summaries
cat("\nPrinting analysis summaries...\n")
if(!is.null(grow_mca)) print_mca_summary(grow_mca$mca, "Growling Behavior")
if(!is.null(howl_mca)) print_mca_summary(howl_mca$mca, "Howling Behavior")
if(!is.null(keep_mca)) print_mca_summary(keep_mca$mca, "Keeping Conditions")
if(!is.null(problems_mca)) print_mca_summary(problems_mca$mca, "Behavioral Problems")

# Save workspace
workspace_path <- "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R/results/mca_workspace.RData"
cat("\nSaving workspace to:", workspace_path, "\n")
save.image(workspace_path)

cat("\nMCA analysis completed.\n")
