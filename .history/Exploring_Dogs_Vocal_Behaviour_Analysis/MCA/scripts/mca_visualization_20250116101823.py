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

def safe_get_contributions(contributions):
    """
    Safely extract contributions data with multiple fallback strategies
    """
    contrib_data = {}
    columns = contributions.get('columns', [])
    
    # Debug print
    print("Contributions structure:")
    print(json.dumps(contributions, indent=2))
    
    try:
        # Strategy 1: Direct dictionary access
        if isinstance(contributions.get('contributions'), dict):
            for col in columns:
                contrib_data[col] = contributions['contributions'].get(col, [0, 0, 0])
        
        # Strategy 2: List-based access
        elif isinstance(contributions.get('contributions'), list):
            for i, col in enumerate(columns):
                contrib_data[col] = contributions['contributions'][i] if i < len(contributions['contributions']) else [0, 0, 0]
        
        # Strategy 3: Nested list access
        elif isinstance(contributions.get('contributions'), dict) and any(isinstance(v, list) for v in contributions['contributions'].values()):
            for col in columns:
                contrib_data[col] = contributions['contributions'].get(col, [0, 0, 0])
        
        else:
            # Fallback: Create dummy data
            contrib_data = {col: [0, 0, 0] for col in columns}
    
    except Exception as e:
        print(f"Error processing contributions: {e}")
        contrib_data = {col: [0, 0, 0] for col in columns}
    
    # Debug print
    print("Extracted contrib_data:")
    print(json.dumps(contrib_data, indent=2))
    
    return contrib_data

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
    
    # Safely get contributions
    contrib_data = safe_get_contributions(contributions)
    
    # Create DataFrame
    contrib_df = pd.DataFrame.from_dict(contrib_data, orient='index').transpose()
    contrib_df.index = list(contrib_data.keys())
    
    # Ensure we're using the first 3 columns
    if contrib_df.shape[1] >= 3:
        contrib_subset = contrib_df.iloc[:, :3]
    else:
        contrib_subset = contrib_df
    
    # Create heatmap with row labels
    sns.heatmap(contrib_subset, 
                cmap='YlGnBu', 
                annot=True, 
                fmt='.2f',
                cbar_kws={'label': 'Contribution %'})
    plt.title('Variable Contributions')
    plt.yticks(range(len(contrib_subset.index)), contrib_subset.index, rotation=0)
    
    # Scatter Plot Subplot
    plt.subplot(2, 2, 4)
    
    # Compute point sizes based on contributions
    point_sizes = np.full(len(mca_df), 500)  # Default size
    point_colors = np.zeros(len(mca_df))
    max_contrib = 0
    
    for i, idx in enumerate(mca_df.index):
        try:
            # Find the index in the contributions
            contrib_index = list(contributions['columns']).index(idx)
            
            # Scale point size based on contribution
            point_sizes[i] = max(contrib_data[idx][0] * 1000, 100)
            
            # Use first dimension's contribution for color
            point_colors[i] = contrib_data[idx][0]
            max_contrib = max(max_contrib, point_colors[i])
        except (KeyError, ValueError, IndexError):
            pass
    
    # Normalize colors
    point_colors = point_colors / max_contrib if max_contrib > 0 else point_colors
    
    # Scatter plot with variable sizes and colors
    scatter = plt.scatter(mca_df['Dim1'], mca_df['Dim2'], 
                          alpha=0.7, 
                          c=point_colors, 
                          s=point_sizes, 
                          cmap='viridis')
    
    plt.colorbar(scatter, label='Normalized Contribution')
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
