"""
Dog Vocalization Analysis Script
-------------------------------

This script analyzes patterns in dog vocalization behavior, focusing on:
1. Growling patterns and their targets
2. Keeping conditions' impact on vocalization
3. Origin impact on behavioral patterns
4. Statistical relationships between different factors

The analysis uses clustering to identify distinct behavioral groups and 
statistical tests to validate relationships between variables.

Author: Cline
Date: 2024
"""

import pandas as pd
import numpy as np
from pathlib import Path
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from scipy import stats
import matplotlib.pyplot as plt
import seaborn as sns
import os

class DogVocalizationAnalysis:
    """
    A class to analyze dog vocalization patterns and their relationships with 
    various environmental and demographic factors.
    
    This class handles:
    - Data loading and preprocessing
    - Statistical analysis
    - Visualization generation
    - Results documentation
    """
    
    def __init__(self):
        """
        Initialize the analysis environment with proper paths and data structures.
        Sets up directory structure for raw data and processed results.
        """
        # Set up directory paths
        self.data_dir = Path(__file__).parent.parent.parent / "data"
        self.raw_dir = self.data_dir / "raw"
        self.processed_dir = self.data_dir / "processed"
        
        # Define input files
        self.files = {
            'growl': 'growl_to_whom.csv',      # Contains growling target information
            'keep': 'keep.csv',                 # Contains keeping conditions
            'origin': 'origin.csv',             # Contains dog origin information
            'problems': 'problems.csv'          # Contains behavioral problems
        }
        
        # Initialize storage for loaded data and analysis results
        self.dataframes = {}
        self.clusters = None
        
        # Ensure output directory exists
        os.makedirs(self.processed_dir, exist_ok=True)
        
        # Create results markdown file
        self.results_file = self.processed_dir / "analysis_results.md"
        self._initialize_results_file()
    
    def _initialize_results_file(self):
        """
        Initialize the markdown file for storing analysis results.
        Creates a structured template for organizing findings.
        """
        with open(self.results_file, 'w', encoding='utf-8') as f:
            f.write("""# Dog Vocalization Analysis Results

## Overview
This document contains the comprehensive results of our analysis of dog vocalization patterns
and their relationships with various environmental and demographic factors.

## Contents
1. [Data Overview](#data-overview)
2. [Growling Patterns Analysis](#growling-patterns)
3. [Origin Impact Analysis](#origin-impact)
4. [Keeping Conditions Analysis](#keeping-conditions)
5. [Statistical Relationships](#statistical-relationships)
6. [Conclusions](#conclusions)

---
""")
    
    def append_to_results(self, section, content):
        """
        Append analysis results to the markdown file under the specified section.
        
        Parameters:
        -----------
        section : str
            The section name in the markdown file
        content : str
            The content to append
        """
        with open(self.results_file, 'a', encoding='utf-8') as f:
            f.write(f"\n## {section}\n")
            f.write(content + "\n")
    
    def save_figure(self, fig, filename):
        """
        Safely save matplotlib figure and document it in results.
        
        Parameters:
        -----------
        fig : matplotlib.figure.Figure
            The figure to save
        filename : str
            The filename for the figure
        """
        try:
            fig.savefig(self.processed_dir / filename, bbox_inches='tight', dpi=300)
            plt.close(fig)
            print(f"Saved figure: {filename}")
            
            # Document in markdown
            self.append_to_results("Visualization",
                f"![{filename}](processed/{filename})\n\n"
                f"*Figure: {filename.replace('_', ' ').replace('.png', '')}*\n")
        except Exception as e:
            print(f"Error saving figure {filename}: {str(e)}")
    
    def load_data(self):
        """
        Load all CSV files into dataframes and document basic statistics.
        Performs initial data validation and reports any issues.
        """
        data_overview = "### Dataset Information\n\n"
        
        for key, filename in self.files.items():
            file_path = self.raw_dir / filename
            try:
                df = pd.read_csv(file_path)
                self.dataframes[key] = df
                print(f"\nLoaded {filename}")
                print(f"Shape: {df.shape}")
                
                # Document dataset information
                data_overview += f"#### {filename}\n"
                data_overview += f"- Number of records: {df.shape[0]}\n"
                data_overview += f"- Number of features: {df.shape[1]}\n"
                data_overview += f"- Features: {', '.join(df.columns.tolist())}\n\n"
                
            except Exception as e:
                print(f"Error loading {filename}: {str(e)}")
        
        self.append_to_results("Data Overview", data_overview)
    
    def analyze_vocalization_patterns(self):
        """
        Perform detailed analysis of growling patterns and vocalization behavior.
        
        This includes:
        - Percentage analysis of growling targets
        - Cluster analysis of behavioral patterns
        - Statistical validation of patterns
        """
        if 'growl' not in self.dataframes or 'problems' not in self.dataframes:
            print("Required data not loaded")
            return
            
        growl_df = self.dataframes['growl']
        problems_df = self.dataframes['problems']
        
        # Analyze growling patterns
        growl_cols = [col for col in growl_df.columns if col != 'ID_full']
        
        # Calculate and document percentages
        growl_percentages = (growl_df[growl_cols].sum() / len(growl_df) * 100).sort_values(ascending=False)
        
        results = "### Growling Target Analysis\n\n"
        results += "Percentage of dogs that growl at different targets:\n\n"
        for target, percentage in growl_percentages.items():
            results += f"- {target.replace('growl_to_whom_', '')}: {percentage:.1f}%\n"
        
        # Perform clustering
        X = StandardScaler().fit_transform(growl_df[growl_cols])
        optimal_k = 4
        kmeans = KMeans(n_clusters=optimal_k, random_state=42)
        self.clusters = kmeans.fit_predict(X)
        
        # Analyze clusters
        cluster_df = pd.DataFrame(X, columns=growl_cols)
        cluster_df['Cluster'] = self.clusters
        
        results += "\n### Behavioral Clusters\n\n"
        for i in range(optimal_k):
            cluster_size = (self.clusters == i).sum()
            results += f"#### Cluster {i} ({cluster_size/len(self.clusters)*100:.1f}% of dogs)\n"
            results += "Characteristics:\n"
            
            # Get top features for this cluster
            cluster_means = cluster_df[cluster_df['Cluster'] == i][growl_cols].mean()
            top_features = cluster_means[cluster_means > 0.1].sort_values(ascending=False)
            
            for feature, value in top_features.items():
                results += f"- {feature.replace('growl_to_whom_', '')}: {value:.2f} SD from mean\n"
            results += "\n"
        
        self.append_to_results("Growling Patterns", results)
        return growl_percentages, cluster_df
    
    def analyze_origin_impact(self):
        """
        Analyze how a dog's origin impacts its vocalization patterns.
        
        Performs:
        - Chi-square tests for independence
        - Distribution analysis across behavioral clusters
        - Visual representation of relationships
        """
        if 'origin' not in self.dataframes or self.clusters is None:
            print("Required data not loaded or clustering not performed")
            return
            
        origin_df = self.dataframes['origin']
        origin_df['Cluster'] = self.clusters
        
        results = "### Statistical Analysis of Origin Impact\n\n"
        
        # Analyze each origin type
        origin_cols = [col for col in origin_df.columns if col != 'ID_full' and col != 'Cluster']
        
        for col in origin_cols:
            contingency = pd.crosstab(origin_df['Cluster'], origin_df[col])
            chi2, p_value = stats.chi2_contingency(contingency)[:2]
            
            results += f"#### {col.replace('origin_', '')}\n"
            results += f"- Chi-square statistic: {chi2:.2f}\n"
            results += f"- p-value: {p_value:.4f}\n"
            
            if p_value < 0.05:
                results += "- **Statistically significant relationship found**\n"
            
            # Calculate and document percentages
            percentages = contingency.div(contingency.sum(axis=1), axis=0) * 100
            results += "\nDistribution across clusters:\n"
            results += percentages.to_markdown()
            results += "\n\n"
        
        self.append_to_results("Origin Impact", results)
    
    def analyze_keeping_conditions_impact(self):
        """
        Analyze how keeping conditions affect vocalization behavior.
        
        Performs:
        - Correlation analysis
        - Statistical significance testing
        - Visual representation of relationships
        """
        if 'keep' not in self.dataframes or 'problems' not in self.dataframes:
            print("Required data not loaded")
            return
            
        keep_df = self.dataframes['keep']
        problems_df = self.dataframes['problems']
        
        # Merge datasets
        merged_df = pd.merge(keep_df, problems_df, on='ID_full')
        
        # Focus on vocalization-related problems
        voc_problems = ['problems_He_she_barks_too_much', 
                       'problems_Aggression_towards_people',
                       'problems_Aggression_towards_other_dogs']
                       
        keep_cols = [col for col in keep_df.columns if col != 'ID_full']
        
        # Calculate correlations and p-values
        corr_matrix = merged_df[keep_cols + voc_problems].corr()
        p_values = pd.DataFrame(np.zeros_like(corr_matrix), 
                              index=corr_matrix.index, 
                              columns=corr_matrix.columns)
                              
        results = "### Keeping Conditions Impact Analysis\n\n"
        results += "Correlation analysis between keeping conditions and vocalization problems:\n\n"
        
        for i in keep_cols:
            for j in voc_problems:
                corr, p = stats.pearsonr(merged_df[i], merged_df[j])
                p_values.loc[i, j] = p
                
                results += f"#### {i.replace('keep_', '')} vs {j.replace('problems_', '')}\n"
                results += f"- Correlation coefficient: {corr:.3f}\n"
                results += f"- p-value: {p:.4f}\n"
                if p < 0.05:
                    results += "- **Statistically significant**\n"
                results += "\n"
        
        self.append_to_results("Keeping Conditions", results)
        return corr_matrix, p_values

def main():
    """
    Main execution function that runs the complete analysis pipeline.
    
    The analysis follows these steps:
    1. Load and validate data
    2. Analyze vocalization patterns
    3. Study origin impact
    4. Analyze keeping conditions
    5. Generate comprehensive results
    """
    print("Starting Enhanced Dog Vocalization Analysis")
    print("=" * 50)
    
    # Initialize and run analysis
    analyzer = DogVocalizationAnalysis()
    
    # Load data
    analyzer.load_data()
    
    # Perform analyses
    growl_analysis = analyzer.analyze_vocalization_patterns()
    analyzer.analyze_origin_impact()
    keeping_impact = analyzer.analyze_keeping_conditions_impact()
    
    print("\nAnalysis complete. Results saved in 'analysis_results.md'")

if __name__ == "__main__":
    main()
