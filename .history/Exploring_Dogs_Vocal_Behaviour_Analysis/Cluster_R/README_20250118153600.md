# Dog Behavioral Pattern Analysis Project

## Overview
This project analyzes dog behavioral patterns using multiple datasets and advanced clustering techniques. The analysis revealed two distinct behavioral groups and validated the importance of using multiple behavioral measures for assessment.

## Project Structure

### Scripts (./scripts/)
1. `01_explore_data.R`: Initial data exploration
2. `02_clustering_preparation.R`: Data preparation for clustering
3. `03_clustering_analysis.R`: Main clustering analysis
4. `04_cluster_interpretation.R`: Interpretation of clustering results
5. `05_cluster_visualization.R`: Visualization of cluster characteristics
6. `06_vocalization_analysis.R`: Analysis of vocalization patterns
7. `07_comprehensive_analysis.R`: Combined analysis of all aspects
8. `08_final_visualizations.R`: Final visualization generation
9. `09_dataset_relationships.R`: Analysis of dataset relationships
10. `10_final_relationship_plots.R`: Visualization of dataset relationships
11. `11_generate_final_report.R`: Report generation script
12. `12_organize_documentation.R`: Documentation organization

### Data (./data/)
- **Raw Data** (./data/raw/):
  * `keep.csv`: Living environment data
  * `howl_on_sound.csv`: Howling response data
  * `grow_to_whom.csv`: Growling target data
  * `problems.csv`: Behavioral problems data

- **Processed Data** (./data/processed/):
  * Contains cleaned and prepared datasets
  * Intermediate analysis results

### Results (./results/)
- **Clustering Results** (./results/clustering/):
  * Cluster analysis outputs
  * Silhouette analysis
  * Cluster characteristics

- **Visualizations** (./results/visualizations/):
  * Response pattern plots
  * Cluster distribution plots
  * Dataset relationship visualizations

- **Reports** (./results/):
  * `final_report.md`: Comprehensive analysis report
  * `dataset_relationships_summary.md`: Dataset relationship analysis
  * `final_conclusions.md`: Key findings and recommendations

### Documentation (./documentation/)
Organized documentation of all analyses:
1. Data Exploration
2. Clustering Analysis
3. Dataset Relationships
4. Visualizations
5. Final Reports

## Key Findings

### Behavioral Groups
1. **Reactive Group (9.3% of dogs)**
   - High human-directed reactivity
   - Multiple trigger responses
   - Complex behavioral patterns

2. **Typical Behavior Group (90.7% of dogs)**
   - Lower overall reactivity
   - Single-trigger responses
   - Standard behavioral patterns

### Dataset Contributions
- Problems Dataset: Primary clustering driver
- Growling Dataset: Strong discriminatory power
- Howling Dataset: Validation support
- Keeping Dataset: Environmental context

## Running the Analysis

### Prerequisites
- R (version 4.0 or higher)
- Required R packages:
  * tidyverse
  * cluster
  * factoextra
  * ggplot2
  * gridExtra
  * reshape2
  * viridis
  * fs

### Execution Order
1. Run data exploration: `01_explore_data.R`
2. Run clustering preparation: `02_clustering_preparation.R`
3. Run clustering analysis: `03_clustering_analysis.R`
4. Run interpretation scripts: `04_cluster_interpretation.R`
5. Generate visualizations: `05_cluster_visualization.R` through `10_final_relationship_plots.R`
6. Generate reports: `11_generate_final_report.R`
7. Organize documentation: `12_organize_documentation.R`

## Results Navigation

### For Quick Overview
1. Read `final_report.md` in results directory
2. Review visualizations in results/visualizations/
3. Check final conclusions in `final_conclusions.md`

### For Detailed Analysis
1. Explore documentation directory
2. Review clustering results in results/clustering/
3. Examine dataset relationships in results/relationships/

### For Methodology
1. Review scripts in order (01-12)
2. Check documentation for each analysis step
3. Examine intermediate results in processed data

## Future Directions
1. Longitudinal stability studies
2. Breed-specific analyses
3. Intervention effectiveness studies
4. Environmental impact assessment

## Contact
For questions about this analysis, please contact the research team.
