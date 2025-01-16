# MCA Visualization for Dog Vocalization Behavior Analysis
# This script creates visualizations for the MCA results of dog behavioral patterns

cat("Starting MCA visualization script...\n")

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
load_package("ggplot2")      # For advanced plotting
load_package("factoextra")   # For MCA visualization
load_package("gridExtra")    # For arranging plots

# Define paths
base_path <- "C:/Users/Farkas/Documents/Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour/Exploring_Dogs_Vocal_Behaviour_Analysis/MCA_R"
results_path <- file.path(base_path, "results")
figures_path <- file.path(results_path, "figures")

# Create figures directory if it doesn't exist
if (!dir.exists(figures_path)) {
    cat("Creating figures directory...\n")
    dir.create(figures_path, recursive = TRUE)
}

# Load the MCA results
cat("Loading MCA workspace...\n")
load(file.path(results_path, "mca_workspace.RData"))

# Set a consistent theme for all plots
theme_set(theme_minimal() +
          theme(text = element_text(size = 12),
                axis.title = element_text(size = 10),
                plot.title = element_text(size = 14, face = "bold")))

# Function to create standard MCA plots with ethological interpretations
create_mca_plots <- function(mca_result, name) {
    tryCatch({
        cat("\nCreating plots for", name, "...\n")
        
        # 1. Scree plot
        cat("Creating scree plot...\n")
        p1 <- fviz_screeplot(mca_result$mca, addlabels = TRUE) +
            ggtitle(paste(name, "- Behavioral Pattern Dimensions")) +
            xlab("Dimensions") +
            ylab("Percentage of Explained Variance")
        
        # 2. Variable categories plot
        cat("Creating variable categories plot...\n")
        p2 <- fviz_mca_var(mca_result$mca,
                          repel = TRUE,
                          title = paste(name, "- Behavioral Associations"))
        
        # 3. Biplot
        cat("Creating biplot...\n")
        p3 <- fviz_mca_biplot(mca_result$mca,
                             repel = TRUE,
                             title = paste(name, "- Individual Dogs and Behaviors"),
                             label = "var")
        
        # Save individual plots
        cat("Saving individual plots...\n")
        ggsave(file.path(figures_path, paste0(tolower(name), "_scree.png")), p1,
               width = 8, height = 6)
        ggsave(file.path(figures_path, paste0(tolower(name), "_categories.png")), p2,
               width = 10, height = 8)
        ggsave(file.path(figures_path, paste0(tolower(name), "_biplot.png")), p3,
               width = 12, height = 8)
        
        # Create and save combined plot
        cat("Creating and saving combined plot...\n")
        combined <- grid.arrange(p1, p2, p3, ncol = 2,
                               top = paste("MCA Analysis -", name))
        ggsave(file.path(figures_path, paste0(tolower(name), "_combined.png")),
               combined, width = 15, height = 10)
        
        cat("Successfully created all plots for", name, "\n")
    }, error = function(e) {
        cat("Error creating plots for", name, ":", conditionMessage(e), "\n")
    })
}

# Function to analyze and plot variable contributions
create_contribution_plots <- function(mca_result, name) {
    tryCatch({
        cat("\nCreating contribution plots for", name, "...\n")
        
        # Contributions to primary behavioral pattern
        p1 <- fviz_contrib(mca_result$mca, choice = "var", axes = 1,
                          top = 20) +
            ggtitle(paste(name, "- Contributions to Primary Pattern")) +
            theme(axis.text.x = element_text(angle = 45, hjust = 1))
        
        # Contributions to secondary behavioral pattern
        p2 <- fviz_contrib(mca_result$mca, choice = "var", axes = 2,
                          top = 20) +
            ggtitle(paste(name, "- Contributions to Secondary Pattern")) +
            theme(axis.text.x = element_text(angle = 45, hjust = 1))
        
        # Save contribution plots
        ggsave(file.path(figures_path, paste0(tolower(name), "_contrib_dim1.png")), p1,
               width = 10, height = 6)
        ggsave(file.path(figures_path, paste0(tolower(name), "_contrib_dim2.png")), p2,
               width = 10, height = 6)
        
        cat("Successfully created contribution plots for", name, "\n")
    }, error = function(e) {
        cat("Error creating contribution plots for", name, ":", conditionMessage(e), "\n")
    })
}

# Create visualizations for each behavioral aspect
if (!is.null(grow_mca)) {
    cat("\nVisualizing growling behavior patterns...\n")
    create_mca_plots(grow_mca, "Growling")
    create_contribution_plots(grow_mca, "Growling")
}

if (!is.null(howl_mca)) {
    cat("\nVisualizing howling behavior patterns...\n")
    create_mca_plots(howl_mca, "Howling")
    create_contribution_plots(howl_mca, "Howling")
}

if (!is.null(keep_mca)) {
    cat("\nVisualizing keeping conditions patterns...\n")
    create_mca_plots(keep_mca, "Keeping")
    create_contribution_plots(keep_mca, "Keeping")
}

if (!is.null(problems_mca)) {
    cat("\nVisualizing behavioral problems patterns...\n")
    create_mca_plots(problems_mca, "Problems")
    create_contribution_plots(problems_mca, "Problems")
}

# Create an HTML report with interpretations
cat("Creating HTML report...\n")
report_content <- sprintf('
<!DOCTYPE html>
<html>
<head>
<title>Dog Vocalization Behavior MCA Analysis Results</title>
<style>
body { font-family: Arial, sans-serif; max-width: 1200px; margin: auto; padding: 20px; }
img { max-width: 100%%; height: auto; }
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
')

writeLines(report_content, file.path(results_path, "mca_analysis_report.html"))

# Print completion message
cat("\nMCA visualization completed. Results saved in:", results_path, "\n")
cat("Open mca_analysis_report.html to view the complete analysis report.\n")
