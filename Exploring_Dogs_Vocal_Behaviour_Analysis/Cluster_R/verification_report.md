
> cat("# Analysis Verification Report\n\n")
# Analysis Verification Report


> cat(format(Sys.time(), "Generated: %Y-%m-%d %H:%M:%S\n\n"))
Generated: 2025-01-18 15:39:48


> # 1. Check Data Files
> cat("## 1. Data Files\n\n")
## 1. Data Files


> cat("### Raw Data:\n")
### Raw Data:

> raw_data_files <- c(
+   file.path(base_dir, "data", "raw", "keep.csv"),
+   file.path(base_dir, "data", "raw", "howl_on_sound.csv"),
+   file.path( .... [TRUNCATED] 

> sapply(raw_data_files, check_file, description = "Raw data file")
✓ Raw data file: keep.csv
✓ Raw data file: howl_on_sound.csv
✓ Raw data file: grow_to_whom.csv
✓ Raw data file: problems.csv
         C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/data/raw/keep.csv 
                                                                                                                                                                                          TRUE 
C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/data/raw/howl_on_sound.csv 
                                                                                                                                                                                          TRUE 
 C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/data/raw/grow_to_whom.csv 
                                                                                                                                                                                          TRUE 
     C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/data/raw/problems.csv 
                                                                                                                                                                                          TRUE 

> # 2. Check Scripts
> cat("\n## 2. Analysis Scripts\n\n")

## 2. Analysis Scripts


> scripts <- paste0(sprintf("%02d", 1:13), c(
+   "_explore_data.R",
+   "_clustering_preparation.R",
+   "_clustering_analysis.R",
+   "_cluster_inte ..." ... [TRUNCATED] 

> sapply(file.path(base_dir, "scripts", scripts), check_file, description = "Script")
✓ Script: 01_explore_data.R
✓ Script: 02_clustering_preparation.R
✓ Script: 03_clustering_analysis.R
✓ Script: 04_cluster_interpretation.R
✓ Script: 05_cluster_visualization.R
✗ Script: 06_vocalization_analysis.R
✓ Script: 07_comprehensive_analysis.R
✓ Script: 08_final_visualizations.R
✓ Script: 09_dataset_relationships.R
✓ Script: 10_final_relationship_plots.R
✓ Script: 11_generate_final_report.R
✓ Script: 12_organize_documentation.R
✓ Script: 13_verify_analysis.R
            C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/scripts/01_explore_data.R 
                                                                                                                                                                                                     TRUE 
  C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/scripts/02_clustering_preparation.R 
                                                                                                                                                                                                     TRUE 
     C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/scripts/03_clustering_analysis.R 
                                                                                                                                                                                                     TRUE 
  C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/scripts/04_cluster_interpretation.R 
                                                                                                                                                                                                     TRUE 
   C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/scripts/05_cluster_visualization.R 
                                                                                                                                                                                                     TRUE 
   C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/scripts/06_vocalization_analysis.R 
                                                                                                                                                                                                    FALSE 
  C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/scripts/07_comprehensive_analysis.R 
                                                                                                                                                                                                     TRUE 
    C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/scripts/08_final_visualizations.R 
                                                                                                                                                                                                     TRUE 
   C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/scripts/09_dataset_relationships.R 
                                                                                                                                                                                                     TRUE 
C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/scripts/10_final_relationship_plots.R 
                                                                                                                                                                                                     TRUE 
   C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/scripts/11_generate_final_report.R 
                                                                                                                                                                                                     TRUE 
  C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/scripts/12_organize_documentation.R 
                                                                                                                                                                                                     TRUE 
         C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/scripts/13_verify_analysis.R 
                                                                                                                                                                                                     TRUE 

> # 3. Check Results
> cat("\n## 3. Results\n\n")

## 3. Results


> check_directory(file.path(base_dir, "results"), "Results")

✓ Results Directory: results
  Contents:
    - clustering
    - clustering_prep
    - clustering_summary_report.md
    - comprehensive
    - data_exploration_results.txt
    - dataset_contribution_summary.md
    - dataset_relationships_summary.md
    - explored_data.RData
    - figures
    - final_analysis_summary.md
    - final_conclusions.md
    - final_report.md
    - final_visualizations
    - interpretation
    - relationships
    - visualizations
[1] TRUE

> check_directory(file.path(base_dir, "results", "clustering"), "Clustering")

✓ Clustering Directory: clustering
  Contents:
    - cluster_profiles.csv
    - clustering_comparison.csv
    - clustering_results.RData
    - clustering_summary.txt
    - dendrogram.png
    - elbow_plot.png
    - kmeans_clusters.png
[1] TRUE

> check_directory(file.path(base_dir, "results", "visualizations"), "Visualizations")

✓ Visualizations Directory: visualizations
  Contents:
    - behavioral_profiles.png
    - cluster_distribution.png
[1] TRUE

> check_directory(file.path(base_dir, "results", "relationships"), "Relationships")

✓ Relationships Directory: relationships
  Contents:
    - dataset_correlations.png
    - dataset_relationships.txt
    - response_patterns.png
[1] TRUE

> # 4. Check Documentation
> cat("\n## 4. Documentation\n\n")

## 4. Documentation


> check_directory(file.path(base_dir, "documentation"), "Main Documentation")

✓ Main Documentation Directory: documentation
  Contents:
    - 1_data_exploration
    - 2_clustering_analysis
    - 3_dataset_relationships
    - 4_visualizations
    - 5_final_reports
    - README.md
[1] TRUE

> doc_dirs <- c("1_data_exploration", "2_clustering_analysis", "3_dataset_relationships",
+               "4_visualizations", "5_final_reports")

> sapply(file.path(base_dir, "documentation", doc_dirs), check_directory, description = "Documentation Section")

✓ Documentation Section Directory: 1_data_exploration
  Contents:
    - initial_exploration.txt
    - initial_exploration_documentation.txt

✓ Documentation Section Directory: 2_clustering_analysis
  Contents:
    - clustering_summary.txt
    - clustering_summary_documentation.txt
    - granularity_analysis.txt
    - granularity_analysis_documentation.txt

✓ Documentation Section Directory: 3_dataset_relationships
  Contents:
    - relationships_analysis.txt
    - relationships_analysis_documentation.txt

✓ Documentation Section Directory: 4_visualizations
  Contents:
    - cluster_distribution.png
    - cluster_distribution_documentation.txt
    - cluster_heatmap.png
    - cluster_heatmap_documentation.txt
    - correlation_network.png
    - correlation_network_documentation.txt
    - dataset_analysis_summary.png
    - dataset_analysis_summary_documentation.txt
    - dataset_characteristics.png
    - dataset_characteristics_documentation.txt
    - dataset_complexity.png
    - dataset_complexity_documentation.txt
    - dataset_metrics.png
    - dataset_metrics_documentation.txt
    - response_patterns_stacked.png
    - response_patterns_stacked_documentation.txt
    - silhouette_scores.png
    - silhouette_scores_documentation.txt

✓ Documentation Section Directory: 5_final_reports
  Contents:
    - comprehensive_report.md
    - comprehensive_report_documentation.txt
    - conclusions.md
    - conclusions_documentation.txt
    - relationships_summary.md
    - relationships_summary_documentation.txt
     C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/documentation/1_data_exploration 
                                                                                                                                                                                                     TRUE 
  C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/documentation/2_clustering_analysis 
                                                                                                                                                                                                     TRUE 
C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/documentation/3_dataset_relationships 
                                                                                                                                                                                                     TRUE 
       C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/documentation/4_visualizations 
                                                                                                                                                                                                     TRUE 
        C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/documentation/5_final_reports 
                                                                                                                                                                                                     TRUE 

> # 5. Check Key Reports
> cat("\n## 5. Key Reports\n\n")

## 5. Key Reports


> key_reports <- c(
+   file.path(base_dir, "results", "final_report.md"),
+   file.path(base_dir, "results", "dataset_relationships_summary.md"),
+   .... [TRUNCATED] 

> sapply(key_reports, check_file, description = "Report")
✓ Report: final_report.md
✓ Report: dataset_relationships_summary.md
✓ Report: final_conclusions.md
✓ Report: README.md
                 C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/final_report.md 
                                                                                                                                                                                                        TRUE 
C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/dataset_relationships_summary.md 
                                                                                                                                                                                                        TRUE 
            C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/results/final_conclusions.md 
                                                                                                                                                                                                        TRUE 
                               C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/Cluster_R/README.md 
                                                                                                                                                                                                        TRUE 

> # Summary
> cat("\n## Summary\n\n")

## Summary


> cat("This verification report checks the presence and organization of all analysis components.\n")
This verification report checks the presence and organization of all analysis components.

> cat("Any missing components are marked with ✗ and should be addressed if necessary.\n")
Any missing components are marked with ✗ and should be addressed if necessary.

> cat("Components marked with ✓ are present and properly organized.\n")
Components marked with ✓ are present and properly organized.

> sink()
