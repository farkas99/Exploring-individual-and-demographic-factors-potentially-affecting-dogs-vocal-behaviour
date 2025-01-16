import pandas as pd
import numpy as np
from prince import MCA
import os
import json

def load_data(filepath):
    """
    Load CSV file and preprocess
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

def save_mca_results(filepath, df, mca, mca_results):
    """
    Save MCA results to a JSON file for later plotting
    """
    # Column coordinates
    col_coords = mca.column_coordinates(df)
    col_coords_dict = {
        'coordinates': col_coords.tolist(),
        'columns': list(df.columns)
    }
    
    # Contributions
    contributions = mca.column_contributions_
    contributions_dict = {
        'contributions': contributions.to_dict(),
        'columns': list(contributions.columns)
    }
    
    # Eigenvalues and explained inertia
    total_inertia = sum(mca.eigenvalues_)
    explained_inertia = [val / total_inertia * 100 for val in mca.eigenvalues_]
    
    results = {
        'column_coordinates': col_coords_dict,
        'contributions': contributions_dict,
        'eigenvalues': mca.eigenvalues_.tolist(),
        'explained_inertia': explained_inertia
    }
    
    # Ensure directory exists
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    
    # Save results
    with open(filepath, 'w') as f:
        json.dump(results, f, indent=2)
    
    print(f"MCA results saved to {filepath}")

def main():
    # Define input and output paths
    base_dir = 'Exploring_Dogs_Vocal_Behaviour_Analysis/MCA'
    input_files = [
        f'{base_dir}/data/raw/keep.csv',
        f'{base_dir}/data/raw/howl_on_sound.csv',
        f'{base_dir}/data/raw/grow_to_whom.csv',
        f'{base_dir}/data/raw/problems.csv'
    ]
    
    # Process each file
    for input_file in input_files:
        # Extract filename without extension
        filename = os.path.splitext(os.path.basename(input_file))[0]
        
        # Load data
        df = load_data(input_file)
        
        # Perform MCA
        mca, mca_results = perform_mca(df)
        
        # Define output path
        output_file = f'{base_dir}/data/processed/mca_{filename}_results.json'
        
        # Save results
        save_mca_results(output_file, df, mca, mca_results)

if __name__ == "__main__":
    main()
