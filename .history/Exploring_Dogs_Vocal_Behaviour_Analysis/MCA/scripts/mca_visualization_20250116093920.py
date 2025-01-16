import json
import numpy as np
import matplotlib.pyplot as plt
import networkx as nx
import seaborn as sns
import os
import pandas as pd

def load_mca_results(filepath):
    """
    Load MCA results from JSON file
    """
    with open(filepath, 'r') as f:
        results = json.load(f)
    return results

def plot_mca_results(results, filepath, title):
    """
    Create MCA visualization from loaded results
    """
    # Extract data
    col_coords = np.array(results['column_coordinates']['coordinates'])
    columns = results['column_coordinates']['columns']
    contributions = results['contributions']
    explained_inertia = results['explained_inertia']
    
    # Create DataFrame with coordinates
    mca_df = pd.DataFrame(col_coords, 
                          columns=[f'Dim{i+1}' for i in range(col_coords.shape[1])], 
                          index=columns)
    
    plt.figure(figsize=(20, 15))
    plt.suptitle(f'MCA Analysis: {title}', fontsize=16)
    
    # Network Visualization Subplot
    plt.subplot(2, 2, 2)
    
    # Create graph
    G = nx.Graph()
    
    # Compute pairwise distances between variables
    from scipy.spatial.distance import pdist, squareform
    distances = pdist(mca_df.values)
    dist_matrix = squareform(distances)
    
    # Add nodes with positions
    for idx, row in mca_df.iterrows():
        G.add_node(idx, pos=(row['Dim1'], row['Dim2']))
    
    # Add edges based on proximity
    for i, node1 in enumerate(G.nodes()):
        for j, node2 in enumerate(G.nodes()):
            if i < j:
                distance = dist_matrix[i, j]
                if distance < np.percentile(distances, 20):  # Connect closest 20%
                    G.add_edge(node1, node2, weight=1/distance)
    
    # Draw network
    pos = nx.get_node_attributes(G, 'pos')
    
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
    contrib_df = pd.DataFrame(contributions['contributions'])
    sns.heatmap(contrib_df.iloc[:, :3], 
                cmap='YlGnBu', 
                annot=True, 
                fmt='.2f',
                cbar_kws={'label': 'Contribution %'})
    plt.title('Variable Contributions')
    
    # Scatter Plot Subplot
    plt.subplot(2, 2, 4)
    
    # Compute point sizes based on contributions
    point_sizes = np.full(len(mca_df), 500)  # Default size
    point_colors = np.zeros(len(mca_df))
    
    # Map contributions to point sizes and colors
    for i, idx in enumerate(mca_df.index):
        try:
            contrib_index = list(contributions['columns']).index(idx)
            point_sizes[i] = max(contributions['contributions'][idx][0] * 1000, 100)
            point_colors[i] = contrib_index
        except (KeyError, ValueError):
            pass
    
    # Scatter plot with variable sizes and colors
    scatter = plt.scatter(mca_df['Dim1'], mca_df['Dim2'], 
                          alpha=0.7, 
                          c=point_colors, 
                          s=point_sizes, 
                          cmap='Set1')
    
    plt.colorbar(scatter, label='Variable Categories')
    plt.title('Variable Contributions and Positions')
    plt.xlabel('Dimension 1')
    plt.ylabel('Dimension 2')
    
    # Annotate points
    for idx, row in mca_df.iterrows():
        plt.annotate(idx, 
                     (row['Dim1'], row['Dim2']), 
                     xytext=(5, 5), 
                     textcoords='offset points', 
                     fontsize=8, 
                     alpha=0.8)
    
    plt.tight_layout()
    
    # Save plot
    plt.savefig(filepath, dpi=300, bbox_inches='tight')
    plt.close()

def main():
    # Define paths
    base_dir = 'Exploring_Dogs_Vocal_Behaviour_Analysis/MCA'
    input_files = [
        f'{base_dir}/data/processed/mca_keep_results.json',
        f'{base_dir}/data/processed/mca_howl_on_sound_results.json',
        f'{base_dir}/data/processed/mca_grow_to_whom_results.json',
        f'{base_dir}/data/processed/mca_problems_results.json'
    ]
    
    # Process each file
    for input_file in input_files:
        # Extract filename without extension
        filename = os.path.splitext(os.path.basename(input_file))[0].replace('mca_', '').replace('_results', '')
        
        # Load results
        results = load_mca_results(input_file)
        
        # Define output plot path
        output_plot = f'{base_dir}/results/mca_{filename}_visualization.png'
        
        # Create visualization
        plot_mca_results(results, output_plot, filename.replace('_', ' ').title())

if __name__ == "__main__":
    main()
