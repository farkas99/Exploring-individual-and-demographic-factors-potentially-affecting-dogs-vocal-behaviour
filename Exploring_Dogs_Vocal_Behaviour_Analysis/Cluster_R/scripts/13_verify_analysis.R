# Script to verify the completeness and organization of the analysis
# This helps ensure all components are present and properly structured

# Load required packages
if (!require("fs")) install.packages("fs")
library(fs)

# Set base directory path
base_dir <- file.path(getwd(), "Exploring_Dogs_Vocal_Behaviour_Analysis", "Cluster_R")

# Function to check file existence and print status
check_file <- function(path, description) {
  exists <- file.exists(path)
  status <- if(exists) "✓" else "✗"
  cat(sprintf("%s %s: %s\n", status, description, basename(path)))
  return(exists)
}

# Function to check directory existence and content
check_directory <- function(path, description) {
  exists <- dir.exists(path)
  status <- if(exists) "✓" else "✗"
  cat(sprintf("\n%s %s Directory: %s\n", status, description, basename(path)))
  if(exists) {
    files <- list.files(path)
    if(length(files) > 0) {
      cat("  Contents:\n")
      sapply(files, function(f) cat(sprintf("    - %s\n", f)))
    } else {
      cat("  (Empty directory)\n")
    }
  }
  return(exists)
}

# Create verification report
sink(file.path(base_dir, "verification_report.md"))

cat("# Analysis Verification Report\n\n")
cat(format(Sys.time(), "Generated: %Y-%m-%d %H:%M:%S\n\n"))

# 1. Check Data Files
cat("## 1. Data Files\n\n")
cat("### Raw Data:\n")
raw_data_files <- c(
  file.path(base_dir, "data", "raw", "keep.csv"),
  file.path(base_dir, "data", "raw", "howl_on_sound.csv"),
  file.path(base_dir, "data", "raw", "grow_to_whom.csv"),
  file.path(base_dir, "data", "raw", "problems.csv")
)
sapply(raw_data_files, check_file, description = "Raw data file")

# 2. Check Scripts
cat("\n## 2. Analysis Scripts\n\n")
scripts <- paste0(sprintf("%02d", 1:13), c(
  "_explore_data.R",
  "_clustering_preparation.R",
  "_clustering_analysis.R",
  "_cluster_interpretation.R",
  "_cluster_visualization.R",
  "_vocalization_analysis.R",
  "_comprehensive_analysis.R",
  "_final_visualizations.R",
  "_dataset_relationships.R",
  "_final_relationship_plots.R",
  "_generate_final_report.R",
  "_organize_documentation.R",
  "_verify_analysis.R"
))
sapply(file.path(base_dir, "scripts", scripts), check_file, description = "Script")

# 3. Check Results
cat("\n## 3. Results\n\n")
check_directory(file.path(base_dir, "results"), "Results")
check_directory(file.path(base_dir, "results", "clustering"), "Clustering")
check_directory(file.path(base_dir, "results", "visualizations"), "Visualizations")
check_directory(file.path(base_dir, "results", "relationships"), "Relationships")

# 4. Check Documentation
cat("\n## 4. Documentation\n\n")
check_directory(file.path(base_dir, "documentation"), "Main Documentation")
doc_dirs <- c("1_data_exploration", "2_clustering_analysis", "3_dataset_relationships",
              "4_visualizations", "5_final_reports")
sapply(file.path(base_dir, "documentation", doc_dirs), check_directory, description = "Documentation Section")

# 5. Check Key Reports
cat("\n## 5. Key Reports\n\n")
key_reports <- c(
  file.path(base_dir, "results", "final_report.md"),
  file.path(base_dir, "results", "dataset_relationships_summary.md"),
  file.path(base_dir, "results", "final_conclusions.md"),
  file.path(base_dir, "README.md")
)
sapply(key_reports, check_file, description = "Report")

# Summary
cat("\n## Summary\n\n")
cat("This verification report checks the presence and organization of all analysis components.\n")
cat("Any missing components are marked with ✗ and should be addressed if necessary.\n")
cat("Components marked with ✓ are present and properly organized.\n")

sink()

cat("Verification completed. Results saved in 'verification_report.md'\n")
