"""
Multiple Correspondence Analysis (MCA)
------------------------------------
This script performs MCA on binary (0-1) multiple choice variables to reduce dimensions
and find patterns in dog behavior data.

Analysis Steps:
1. Load and prepare data
2. Perform MCA separately on each category:
   - Growling patterns
   - Howling patterns
   - Keeping conditions
   - Problems
3. Extract and interpret components
4. Visualize results

Author: Cline
Date: 2024
"""

import pandas as pd
import numpy as np
from pathlib import Path
import prince  # For MCA
import matplotlib.pyplot as plt
import seaborn as sns

class MCAAnalysis:
    def __init__(self):
        """Initialize paths and data structures"""
        self.data_dir = Path(__file__).parent.parent.parent / "data"
        self.raw_dir = self.data_dir / "raw"
        self.processed_dir = self.data_dir / "processed"
        self.results_file = self.processed_dir / "mca_results.md"
        
        # Ensure output directory exists
        self.processed_dir.mkdir(parents=True, exist_ok=True)
        
        # Initialize results documentation
        self._initialize_results_file()
    
    def _initialize_results_file(self):
        """Create markdown file for documenting results"""
        with open(self.results_file, 'w') as f:
            f.write("""# Multiple Correspondence Analysis Results

## Overview
This document contains the results of MCA analysis on multiple-choice variables
in the dog behavior study.

## Contents
1. [Growling Patterns Analysis](#growling-patterns)
2. [Howling Patterns Analysis](#howling-patterns)
3. [Keeping Conditions Analysis](#keeping-conditions)
4. [Problems Analysis](#problems)

---
""")
    
    def append_to_results(self, section, content):
        """Add analysis results to markdown file"""
        with open(self.results_file, 'a') as f:
            f.write(f"\n## {section}\n")
            f.write(content + "\n")
    
    def perform_mca(self, data, prefix, n_components=2):
        """
        Perform MCA on a set of binary variables
        
        Parameters:
        -----------
        data : pandas DataFrame
            Binary data to analyze
        prefix : str
            Category prefix for results naming
        n_components : int
            Number of components to extract
            
        Returns:
        --------
        mca : prince.MCA
            Fitted MCA model
        coords : pandas DataFrame
            Component coordinates
        """
        print(f"\nPerforming MCA on {prefix} data...")
        print("-" * 50)
        
        # Remove ID column if present
        if 'ID_full' in data.columns:
            data = data.drop('ID_full', axis=1)
        
        # Convert data to numeric and fill NaN values with 0
        data = data.apply(pd.to_numeric, errors='coerce').fillna(0)
        
        # Print value counts for verification
        print("\nValue counts for first few columns:")
        for col in data.columns[:3]:
            print(f"\n{col}:")
            print(data[col].value_counts())
        
        try:
            # Initialize and fit MCA
            mca = prince.MCA(n_components=n_components, random_state=42)
            
            # Fit and transform the data
            coords = mca.fit_transform(data)
            
            # Get eigenvalues and calculate total inertia
            eigenvalues = mca.eigenvalues_
            total_inertia = np.sum(eigenvalues)
            explained_inertia = eigenvalues / total_inertia
            
            # Print results
            print(f"\nExplained inertia ratios:")
            for i, ratio in enumerate(explained_inertia, 1):
                print(f"Component {i}: {ratio:.3f} ({ratio*100:.1f}%)")
            
            # Get coordinates for variables
            var_coords = mca.column_coordinates(data)
            
            # Create visualization
            plt.figure(figsize=(12, 8))
            
            # Plot individual points (dogs)
            plt.scatter(coords.iloc[:, 0], coords.iloc[:, 1], 
                       alpha=0.1, color='gray', label='Dogs')
            
            # Plot variable points
            for i, (var, coord) in enumerate(var_coords.items()):
                x, y = coord[0], coord[1]
                plt.plot([0, x], [0, y], 'r-', alpha=0.5)
                plt.scatter(x, y, color='red')
                # Clean up variable name for display
                display_name = var.replace('_', ' ').title()
                plt.annotate(
                    display_name,
                    (x, y),
                    xytext=(5, 5), 
                    textcoords='offset points',
                    fontsize=8,
                    alpha=0.8
                )
            
            plt.axhline(y=0, color='k', linestyle='-', alpha=0.3)
            plt.axvline(x=0, color='k', linestyle='-', alpha=0.3)
            plt.grid(True, alpha=0.3)
            
            plt.xlabel(f"Component 1 ({explained_inertia[0]*100:.1f}%)")
            plt.ylabel(f"Component 2 ({explained_inertia[1]*100:.1f}%)")
            plt.title(f"MCA Results: {prefix}")
            
            plt.tight_layout()
            plt.savefig(self.processed_dir / f"mca_{prefix.lower()}.png", 
                       dpi=300, bbox_inches='tight')
            plt.close()
            
            # Create results DataFrame
            correlations = pd.DataFrame(
                var_coords,
                columns=[f'Component_{i+1}' for i in range(n_components)]
            )
            
            # Document results
            results = f"""### {prefix} MCA Results

#### Explained Variance
{pd.Series(explained_inertia, 
          index=[f'Component {i+1}' for i in range(n_components)],
          name='Explained Inertia').to_markdown()}

#### Component Correlations
{correlations.round(3).to_markdown()}

#### Interpretation
The MCA analysis revealed two main components that explain {(explained_inertia[0] + explained_inertia[1])*100:.1f}% 
of the total variance in the data.

- Component 1 ({explained_inertia[0]*100:.1f}%) primarily separates:
{correlations['Component_1'].abs().sort_values(ascending=False).head().to_string()}

- Component 2 ({explained_inertia[1]*100:.1f}%) primarily separates:
{correlations['Component_2'].abs().sort_values(ascending=False).head().to_string()}

![MCA Plot](processed/mca_{prefix.lower()}.png)
"""
            self.append_to_results(prefix, results)
            
            return mca, coords
            
        except Exception as e:
            print(f"Error in MCA analysis: {str(e)}")
            raise
    
    def analyze_all(self):
        """Perform MCA analysis on all variable categories"""
        # Load data
        growl_df = pd.read_csv(self.raw_dir / "grow_to_whom.csv")
        howl_df = pd.read_csv(self.raw_dir / "howl_on_sound.csv")
        keep_df = pd.read_csv(self.raw_dir / "keep.csv")
        problems_df = pd.read_csv(self.raw_dir / "problems.csv")
        
        # Print data info
        print("\nData Overview:")
        print("-" * 50)
        for name, df in [('Growl', growl_df), ('Howl', howl_df), 
                        ('Keep', keep_df), ('Problems', problems_df)]:
            print(f"\n{name} data shape:", df.shape)
            print("Columns:", df.columns.tolist())
            print("Sample of first row:", df.iloc[0].to_dict())
            print("\nValue counts for binary variables:")
            for col in df.columns:
                if col != 'ID_full':
                    print(f"\n{col}:")
                    print(df[col].value_counts(normalize=True).mul(100).round(1))
        
        # Analyze each category
        print("\nStarting MCA Analysis...")
        print("=" * 50)
        
        results = {}
        
        # Growling patterns
        results['growl'] = self.perform_mca(growl_df, "Growling_Patterns")
        
        # Howling patterns
        results['howl'] = self.perform_mca(howl_df, "Howling_Patterns")
        
        # Keeping conditions
        results['keep'] = self.perform_mca(keep_df, "Keeping_Conditions")
        
        # Problems
        results['problems'] = self.perform_mca(problems_df, "Problems")
        
        print("\nAnalysis complete! Results saved in:")
        print(f"- Markdown: {self.results_file}")
        print(f"- Plots: {self.processed_dir}")
        
        return results

def main():
    """Run the complete MCA analysis"""
    analyzer = MCAAnalysis()
    results = analyzer.analyze_all()

if __name__ == "__main__":
    main()
