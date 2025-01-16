# Script to read and display first 5 rows of each dataset

# Read the CSV files
grow_to_whom <- read.csv("../data/raw/grow_to_whom.csv")
howl_on_sound <- read.csv("../data/raw/howl_on_sound.csv")
keep <- read.csv("../data/raw/keep.csv")
problems <- read.csv("../data/raw/problems.csv")

# Function to display dataset info
print_dataset_info <- function(dataset, name) {
    cat("\n===========================================")
    cat(paste("\nDataset:", name))
    cat("\n===========================================")
    cat("\nDimensions (rows x columns):", paste(dim(dataset), collapse=" x "))
    cat("\nColumn names:", paste(names(dataset), collapse=", "))
    cat("\n\nFirst 5 rows:\n")
    print(head(dataset, 5))
    cat("\n")
}

# Display information for each dataset
print_dataset_info(grow_to_whom, "grow_to_whom")
print_dataset_info(howl_on_sound, "howl_on_sound")
print_dataset_info(keep, "keep")
print_dataset_info(problems, "problems")
