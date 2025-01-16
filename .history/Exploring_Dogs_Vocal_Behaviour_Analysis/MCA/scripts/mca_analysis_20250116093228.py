import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from prince import MCA
import seaborn as sns
import os
from datetime import datetime

def get_timestamp():
    """Generate a timestamp for file naming"""
    return datetime.now().strftime("%Y%m%d_%H%M%S")

def load_data(filepath):
    """
    Load CSV file
    - Assumes data is already preprocessed
    """
    df = pd.read_csv(filepath)
    
    # Remove ID column if present
    if 'ID_full' in df.columns:
        df = df.drop('ID_full', axis=1)
    
    return df

def perform_mca(df, n_components=3):
    """
    Perform Multiple Correspondence Analysis
    """
    mca = MCA(n_components=n_components)
    mca_results = mca.fit(df)
    
    return mca, mca_results

def plot_mca_results(mca, mca_results, filepath, title, timestamp, original_df):
    """
    Plot MCA results with network-like column coordinates visualization
    """
    try:
        import networkx as nx
        from scipy.spatial.distance import pdist, squareform

        # Ensure the directory exists
        os.makedirs(os.path.dirname(filepath), exist_ok=True)

        # Get absolute path to ensure correct saving
        abs_filepath = os.path.abspath(filepath)
        print(f"Attempting to save plot to: {abs_filepath}")

        plt.figure(figsize=(20, 15))
        plt.suptitle(f'MCA Analysis: {title} ({timestamp})', fontsize=16)
        
        # Compute column coordinates
        col_coords = mca.column_coordinates(original_df)
        
        # Create DataFrame with coordinates
        mca_df = pd.DataFrame(col_coords, 
                              columns=[f'Dim{i+1}' for i in range(col_coords.shape[1])], 
                              index=original_df.columns)
        
        # Ensure finite coordinates
        mca_df = mca_df.replace([np.inf, -np.inf], np.nan).dropna()
        
        # Network Visualization Subplot
        plt.subplot(2, 2, 2)
        
        # Create graph
        G = nx.Graph()
        
        # Compute pairwise distances between variables
        distances = pdist(mca_df.values)
        dist_matrix = squareform(distances)
        
        # Add nodes with positions
        for idx, row in mca_df.iterrows():
            G.add_node(idx, pos=(row['Dim1'], row['Dim2']))
        
        # Add edges based on proximity (inverse of distance)
        for i, node1 in enumerate(G.nodes()):
            for j, node2 in enumerate(G.nodes()):
                if i < j:
                    distance = dist_matrix[i, j]
                    if distance < np.percentile(distances, 20):  # Connect closest 20%
                        G.add_edge(node1, node2, weight=1/distance)
        
        # Draw network
        pos = nx.get_node_attributes(G, 'pos')
        
        # Ensure pos is not empty
        if pos:
            nx.draw_networkx_nodes(G, pos, node_color='lightblue', 
                                    node_size=500, alpha=0.8)
            nx.draw_networkx_edges(G, pos, alpha=0.2)
            nx.draw_networkx_labels(G, pos, font_size=8)
        
        plt.title(f'Network of Behavioral Variables: {title}')
        plt.xlabel('Dimension 1')
        plt.ylabel('Dimension 2')
        
        # Explained Inertia Subplot
        plt.subplot(2, 2, 1)
        eigenvalues = mca.eigenvalues_
        total_inertia = sum(eigenvalues)
        explained_inertia = [val / total_inertia for val in eigenvalues]
        
        bars = plt.bar(range(1, len(explained_inertia) + 1), explained_inertia)
        plt.title('Explained Inertia')
        plt.xlabel('Dimensions')
        plt.ylabel('Proportion of Inertia')
        
        # Color bars with flexible significance
        for i, bar in enumerate(bars):
            if explained_inertia[i] > np.mean(explained_inertia):
                bar.set_color('green')
            else:
                bar.set_color('gray')
        
        # Variable Contributions Subplot
        plt.subplot(2, 2, 3)
        contributions = mca.column_contributions_
        sns.heatmap(contributions.iloc[:, :3], 
                    cmap='YlGnBu', 
                    annot=True, 
                    fmt='.2f',
                    cbar_kws={'label': 'Contribution %'})
        plt.title('Variable Contributions')
        
        # Enhanced Scatter Plot of First Two Dimensions Subplot (Top Right)
        plt.subplot(2, 2, 4)
        
        # Compute point sizes and colors based on contribution
        contributions = mca.column_contributions_
        
        # Ensure we're using the first dimension's contributions
        point_sizes = np.full(len(mca_df), 500)  # Default size
        
        # Use a distinct color palette
        import matplotlib.cm as cm
        import matplotlib.colors as mcolors
        
        # Create a custom colormap with high contrast colors
        colors = ['red', 'blue', 'green', 'purple', 'orange', 'brown', 'pink', 'gray', 'olive', 'cyan']
        n_colors = len(colors)
        
        # Map contributions to point sizes and colors
        point_colors = np.zeros(len(mca_df))
        for i, idx in enumerate(mca_df.index):
            try:
                # Find the index in the contributions DataFrame
                contrib_index = contributions.index.get_loc(idx)
                # Scale the contribution for point size
                point_sizes[i] = max(contributions.iloc[contrib_index, 0] * 1000, 100)  # Ensure minimum size
                # Assign a distinct color based on index
                point_colors[i] = i % n_colors
            except (KeyError, IndexError):
                # Keep default size and color if no contribution found
                point_colors[i] = i % n_colors
        
        # Create custom colormap
        custom_cmap = mcolors.ListedColormap(colors)
        
        # Scatter plot with variable sizes and colors
        scatter = plt.scatter(mca_df['Dim1'], mca_df['Dim2'], 
                              alpha=0.7, 
                              c=point_colors, 
                              s=point_sizes, 
                              cmap=custom_cmap)
        
        # Create a custom colorbar
        cbar = plt.colorbar(scatter, label='Variable Categories', ticks=range(n_colors))
        cbar.set_ticklabels(mca_df.index)
        
        plt.title('Variable Contributions and Positions')
        plt.xlabel('Dimension 1')
        plt.ylabel('Dimension 2')
        
        # Annotate points with more context
        for idx, row in mca_df.iterrows():
            # Safely get contribution
            try:
                contribution_index = contributions.index.get_loc(idx)
                contribution = contributions.iloc[contribution_index, 0]
                plt.annotate(f'{idx}\n({contribution:.2%})', 
                             (row['Dim1'], row['Dim2']), 
                             xytext=(5, 5), 
                             textcoords='offset points', 
                             fontsize=8, 
                             alpha=0.8,
                             bbox=dict(boxstyle='round,pad=0.2', 
                                       fc='yellow', 
                                       alpha=0.3))
            except Exception as e:
                # Fallback annotation if contribution lookup fails
                plt.annotate(idx, 
                             (row['Dim1'], row['Dim2']), 
                             xytext=(5, 5), 
                             textcoords='offset points', 
                             fontsize=8, 
                             alpha=0.8)
                print(f"Error annotating {idx}: {e}")
        
        # Add reference lines
        plt.axhline(y=0, color='k', linestyle='--', linewidth=0.5)
        plt.axvline(x=0, color='k', linestyle='--', linewidth=0.5)
        
        plt.tight_layout()
        
        # Save with additional error handling
        try:
            plt.savefig(abs_filepath, dpi=300, bbox_inches='tight')
            print(f"Successfully saved plot to: {abs_filepath}")
        except Exception as save_error:
            print(f"Error saving plot: {save_error}")
            print(f"Attempting to save with default parameters")
            plt.savefig(abs_filepath)
        
        plt.close()
        
        return explained_inertia
    except Exception as e:
        print(f"Error in plot_mca_results: {e}")
        import traceback
        traceback.print_exc()
        return []

def analyze_mca_results(mca, filepath, timestamp):
    """
    Analyze and save MCA results
    """
    eigenvalues = mca.eigenvalues_
    total_inertia = sum(eigenvalues)
    explained_inertia = [val / total_inertia for val in eigenvalues]
    
    with open(filepath, 'w') as f:
        f.write(f"MCA Analysis Results ({timestamp})\n")
        f.write("===================\n\n")
        
        f.write("Explained Inertia:\n")
        cumulative_inertia = 0
        for i, inertia in enumerate(explained_inertia, 1):
            cumulative_inertia += inertia
            f.write(f"Dimension {i}: {inertia * 100:.2f}% (Cumulative: {cumulative_inertia * 100:.2f}%)\n")
        
        f.write("\nVariable Contributions:\n")
        contributions = mca.column_contributions_
        for col in contributions.columns:
            f.write(f"\n{col} Contributions:\n")
            top_vars = contributions[col].nlargest(5)
            for var, contrib in top_vars.items():
                f.write(f"  {var}: {contrib * 100:.2f}%\n")

def main():
    timestamp = get_timestamp()
    
    os.makedirs('Exploring_Dogs_Vocal_Behaviour_Analysis/MCA/data/processed', exist_ok=True)
    os.makedirs('Exploring_Dogs_Vocal_Behaviour_Analysis/MCA/results', exist_ok=True)
    
    files = [
        'Exploring_Dogs_Vocal_Behaviour_Analysis/MCA/data/raw/keep.csv',
        'Exploring_Dogs_Vocal_Behaviour_Analysis/MCA/data/raw/howl_on_sound.csv',
        'Exploring_Dogs_Vocal_Behaviour_Analysis/MCA/data/raw/grow_to_whom.csv',
        'Exploring_Dogs_Vocal_Behaviour_Analysis/MCA/data/raw/problems.csv'
    ]
    
    for filepath in files:
        print(f"\n{'='*50}")
        print(f"DETAILED MCA ANALYSIS: {filepath.split('/')[-1]}")
        print(f"{'='*50}")
        
        filename = filepath.split('/')[-1].split('.')[0]
        plot_path = f'Exploring_Dogs_Vocal_Behaviour_Analysis/MCA/results/mca_{filename}_{timestamp}.png'
        results_path = f'Exploring_Dogs_Vocal_Behaviour_Analysis/MCA/data/processed/mca_{filename}_{timestamp}_results.txt'
        
        df = load_data(filepath)
        print(f"\nDATA OVERVIEW:")
        print(f"Total Rows: {len(df)}")
        print(f"Columns: {', '.join(df.columns)}")
        print(f"Data Types:\n{df.dtypes}")
        
        mca, mca_results = perform_mca(df)
        
        print("\nMCA ANALYSIS RESULTS:")
        
        eigenvalues = mca.eigenvalues_
        total_inertia = sum(eigenvalues)
        explained_inertia = [val / total_inertia * 100 for val in eigenvalues]
        
        print("\nEigenvalues and Explained Inertia:")
        cumulative_inertia = 0
        for i, (eigenval, inertia) in enumerate(zip(eigenvalues, explained_inertia), 1):
            cumulative_inertia += inertia
            print(f"Dimension {i}:")
            print(f"  Eigenvalue: {eigenval:.4f}")
            print(f"  Explained Inertia: {inertia:.2f}%")
            print(f"  Cumulative Inertia: {cumulative_inertia:.2f}%")
        
        print("\nTop Variable Contributions:")
        contributions = mca.column_contributions_
        for col in contributions.columns[:3]:  # Top 3 dimensions
            print(f"\n{col} Top Contributions:")
            top_vars = contributions[col].nlargest(5)
            for var, contrib in top_vars.items():
                print(f"  {var}: {contrib * 100:.2f}%")
        
        explained_inertia = plot_mca_results(mca, mca_results, plot_path, filename, timestamp, df)
        
        analyze_mca_results(mca, results_path, timestamp)
        
        print(f"\nVisualization saved to: {plot_path}")
        print(f"Detailed results saved to: {results_path}")

if __name__ == "__main__":
    main()
