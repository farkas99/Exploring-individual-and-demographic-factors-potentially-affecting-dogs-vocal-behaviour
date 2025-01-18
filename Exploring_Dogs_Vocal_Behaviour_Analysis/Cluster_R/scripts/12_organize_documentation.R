# Script to organize all analysis files into a structured documentation folder
# This helps maintain a clear record of all analyses and results

# Load required packages
if (!require("fs")) install.packages("fs")
library(fs)

# Set base directory path
base_dir <- file.path(getwd(), "Exploring_Dogs_Vocal_Behaviour_Analysis", "Cluster_R")

# Create documentation structure
doc_dir <- file.path(base_dir, "documentation")
dir.create(doc_dir, showWarnings = FALSE, recursive = TRUE)

# Create subdirectories
dirs <- c(
  "1_data_exploration",
  "2_clustering_analysis",
  "3_dataset_relationships",
  "4_visualizations",
  "5_final_reports"
)

for (d in dirs) {
  dir.create(file.path(doc_dir, d), showWarnings = FALSE)
}

# Function to copy files with documentation
copy_with_doc <- function(from, to, description) {
  # Copy file
  file.copy(from, to, overwrite = TRUE)
  
  # Create documentation file
  doc_file <- file.path(dirname(to), paste0(tools::file_path_sans_ext(basename(to)), "_documentation.txt"))
  writeLines(
    c(
      paste("Documentation for:", basename(from)),
      paste("Created:", format(Sys.time(), "%Y-%m-%d %H:%M:%S")),
      "",
      "Description:",
      description,
      "",
      "File Location:",
      paste("Original:", from),
      paste("Documentation:", to)
    ),
    doc_file
  )
}

# 1. Data Exploration
copy_with_doc(
  file.path(base_dir, "results", "data_exploration_results.txt"),
  file.path(doc_dir, "1_data_exploration", "initial_exploration.txt"),
  "Initial exploration of all datasets showing basic statistics and data structure"
)

# 2. Clustering Analysis
copy_with_doc(
  file.path(base_dir, "results", "clustering_prep", "granularity_analysis.txt"),
  file.path(doc_dir, "2_clustering_analysis", "granularity_analysis.txt"),
  "Analysis of data granularity to determine clustering feasibility"
)

copy_with_doc(
  file.path(base_dir, "results", "clustering", "clustering_summary.txt"),
  file.path(doc_dir, "2_clustering_analysis", "clustering_summary.txt"),
  "Summary of clustering results including optimal number of clusters and cluster characteristics"
)

# 3. Dataset Relationships
copy_with_doc(
  file.path(base_dir, "results", "relationships", "dataset_relationships.txt"),
  file.path(doc_dir, "3_dataset_relationships", "relationships_analysis.txt"),
  "Analysis of relationships between different datasets including correlations"
)

# 4. Visualizations
viz_files <- list.files(file.path(base_dir, "results", "final_visualizations"),
                       pattern = "\\.png$", full.names = TRUE)
for (viz in viz_files) {
  copy_with_doc(
    viz,
    file.path(doc_dir, "4_visualizations", basename(viz)),
    "Visualization of analysis results"
  )
}

# 5. Final Reports
copy_with_doc(
  file.path(base_dir, "results", "final_report.md"),
  file.path(doc_dir, "5_final_reports", "comprehensive_report.md"),
  "Comprehensive final report of all analyses and findings"
)

copy_with_doc(
  file.path(base_dir, "results", "dataset_relationships_summary.md"),
  file.path(doc_dir, "5_final_reports", "relationships_summary.md"),
  "Summary of dataset relationships and their implications"
)

copy_with_doc(
  file.path(base_dir, "results", "final_conclusions.md"),
  file.path(doc_dir, "5_final_reports", "conclusions.md"),
  "Final conclusions and recommendations from the analysis"
)

# Create README for documentation
writeLines(
  c(
    "# Analysis Documentation",
    "",
    "This directory contains organized documentation of all analyses performed:",
    "",
    "1. **Data Exploration**: Initial exploration and basic statistics",
    "2. **Clustering Analysis**: Granularity analysis and clustering results",
    "3. **Dataset Relationships**: Analysis of relationships between datasets",
    "4. **Visualizations**: All visualization outputs",
    "5. **Final Reports**: Comprehensive reports and conclusions",
    "",
    "Each subdirectory contains relevant files and their documentation.",
    "Documentation files (ending in _documentation.txt) provide details about each analysis file."
  ),
  file.path(doc_dir, "README.md")
)

cat("Documentation organized. All files are now in the 'documentation' directory with appropriate documentation.\n")
