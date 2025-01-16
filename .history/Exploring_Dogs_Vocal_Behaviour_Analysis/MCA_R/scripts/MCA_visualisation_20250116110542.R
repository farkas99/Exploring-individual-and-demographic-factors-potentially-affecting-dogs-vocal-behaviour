# MCA Visualization for Dog Vocalization Behavior Analysis
# This script creates visualizations for the MCA results of dog behavioral patterns

# Load required packages
if (!require("ggplot2")) install.packages("ggplot2")      # For advanced plotting
if (!require("factoextra")) install.packages("factoextra") # For MCA visualization
if (!require("gridExtra")) install.packages("gridExtra")   # For arranging plots
library(ggplot2)
library(factoextra)
library(gridExtra)

# Load the MCA results
load("../results/mca_workspace.RData")

# Set a consistent theme for all plots
theme_set(theme_minimal() +
          theme(text = element_text(size = 12),
                axis.title = element_text(size = 10),
                plot.title = element_text(size = 14, face = "bold")))

# Function to create standard MCA plots with ethological interpretations
create_mca_plots <- function(mca_result, name) {
    # 1. Scree plot - Shows importance of each dimension
    # In ethology, this helps determine how many behavioral patterns to consider
    p1 <- fviz_screeplot(mca_result$mca, addlabels = TRUE) +
        ggtitle(paste(name, "- Behavioral Pattern Dimensions")) +
        xlab("Dimensions") +
        ylab("Percentage of Explained Variance")
    
    # 2. Variable categories plot - Shows relationships between behaviors
    # This reveals which behaviors tend to occur together
    p2 <- fviz_mca_var(mca_result$mca,
                       repel = TRUE,      # Avoid text overlap
                       title = paste(name, "- Behavioral Associations"))
    
    # 3. Biplot - Shows both individuals and variables
    # This helps identify typical behavioral profiles
    p3 <- fviz_mca_biplot(mca_result$mca,
                         repel = TRUE,
                         title = paste(name, "- Individual Dogs and Behaviors"),
                         label = "var")  # Only label variables for clarity
    
    # Save individual plots
    ggsave(paste0("../results/figures/", tolower(name), "_scree.png"), p1,
           width = 8, height = 6)
    ggsave(paste0("../results/figures/", tolower(name), "_categories.png"), p2,
           width = 10, height = 8)
    ggsave(paste0("../results/figures/", tolower(name), "_biplot.png"), p3,
           width = 12, height = 8)
    
    # Create and save combined plot
    combined <- grid.arrange(p1, p2, p3, ncol = 2,
                           top = paste("MCA Analysis -", name))
    ggsave(paste0("../results/figures/", tolower(name), "_combined.png"),
           combined, width = 15, height = 10)
}

# Function to analyze and plot variable contributions
create_contribution_plots <- function(mca_result, name) {
    # Contributions to primary behavioral pattern (Dimension 1)
    p1 <- fviz_contrib(mca_result$mca, choice = "var", axes = 1,
                       top = 20) +
        ggtitle(paste(name, "- Contributions to Primary Pattern")) +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    # Contributions to secondary behavioral pattern (Dimension 2)
    p2 <- fviz_contrib(mca_result$mca, choice = "var", axes = 2,
                       top = 20) +
        ggtitle(paste(name, "- Contributions to Secondary Pattern")) +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    # Save contribution plots
    ggsave(paste0("../results/figures/", tolower(name), "_contrib_dim1.png"), p1,
           width = 10, height = 6)
    ggsave(paste0("../results/figures/", tolower(name), "_contrib_dim2.png"), p2,
           width = 10, height = 6)
}

# Create visualizations for each behavioral aspect
# 1. Growling behavior patterns
cat("\nVisualizing growling behavior patterns...\n")
create_mca_plots(grow_mca, "Growling")
create_contribution_plots(grow_mca, "Growling")

# 2. Howling behavior patterns
cat("\nVisualizing howling behavior patterns...\n")
create_mca_plots(howl_mca, "Howling")
create_contribution_plots(howl_mca, "Howling")

# 3. Keeping conditions and their relationships
cat("\nVisualizing keeping conditions patterns...\n")
create_mca_plots(keep_mca, "Keeping")
create_contribution_plots(keep_mca, "Keeping")

# 4. Behavioral problems and their associations
cat("\nVisualizing behavioral problems patterns...\n")
create_mca_plots(problems_mca, "Problems")
create_contribution_plots(problems_mca, "Problems")

# Create an HTML report with interpretations
cat('
<!DOCTYPE html>
<html>
<head>
<title>Dog Vocalization Behavior MCA Analysis Results</title>
<style>
body { font-family: Arial, sans-serif; max-width: 1200px; margin: auto; padding: 20px; }
img { max-width: 100%; height: auto; }
.section { margin-bottom: 40px; }
</style>
</head>
<body>
<h1>Multiple Correspondence Analysis of Dog Vocalization Behavior</h1>

<div class="section">
<h2>Growling Behavior Patterns</h2>
<p>Analysis of growling behavior reveals patterns in how dogs direct their growling responses to different targets.</p>
<img src="figures/growling_combined.png" alt="Growling behavior analysis">
<h3>Variable Contributions</h3>
<img src="figures/growling_contrib_dim1.png" alt="Growling primary pattern">
<img src="figures/growling_contrib_dim2.png" alt="Growling secondary pattern">
</div>

<div class="section">
<h2>Howling Behavior Patterns</h2>
<p>Analysis of howling responses to different stimuli shows patterns in sound-triggered vocalizations.</p>
<img src="figures/howling_combined.png" alt="Howling behavior analysis">
<h3>Variable Contributions</h3>
<img src="figures/howling_contrib_dim1.png" alt="Howling primary pattern">
<img src="figures/howling_contrib_dim2.png" alt="Howling secondary pattern">
</div>

<div class="section">
<h2>Keeping Conditions</h2>
<p>Analysis of keeping conditions reveals patterns in how different living environments relate to each other.</p>
<img src="figures/keeping_combined.png" alt="Keeping conditions analysis">
<h3>Variable Contributions</h3>
<img src="figures/keeping_contrib_dim1.png" alt="Keeping primary pattern">
<img src="figures/keeping_contrib_dim2.png" alt="Keeping secondary pattern">
</div>

<div class="section">
<h2>Behavioral Problems</h2>
<p>Analysis of behavioral problems shows patterns in how different issues tend to co-occur.</p>
<img src="figures/problems_combined.png" alt="Behavioral problems analysis">
<h3>Variable Contributions</h3>
<img src="figures/problems_contrib_dim1.png" alt="Problems primary pattern">
<img src="figures/problems_contrib_dim2.png" alt="Problems secondary pattern">
</div>

</body>
</html>
', file = "../results/mca_analysis_report.html")

# Print completion message
cat("\nMCA visualization completed. Results saved in '../results' directory.\n")
cat("Open mca_analysis_report.html to view the complete analysis report.\n")
