def save_mca_results(filepath, df, mca, mca_results):
    """
    Save MCA results to a JSON file for later plotting
    """
    # Column coordinates
    col_coords = mca.column_coordinates(df)
    col_coords_dict = {
        'coordinates': col_coords.values.tolist(),
        'columns': list(col_coords.index)
    }
    
    # Contributions
    contributions = mca.column_contributions_
    contributions_dict = {
        'contributions': {col: contributions[col].tolist() for col in contributions.columns},
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
