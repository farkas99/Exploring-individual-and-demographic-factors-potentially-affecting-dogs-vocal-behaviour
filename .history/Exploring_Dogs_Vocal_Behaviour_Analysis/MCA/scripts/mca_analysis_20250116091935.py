        # Compute point sizes based on contribution
        contributions = mca.column_contributions_
        
        # Ensure we're using the first dimension's contributions
        if isinstance(contributions, pd.DataFrame):
            # Ensure point_sizes matches the number of points in mca_df
            point_sizes = np.full(len(mca_df), 500)  # Default size
            
            # Map contributions to point sizes
            for idx, row in mca_df.iterrows():
                try:
                    contrib_index = contributions.index.get_loc(idx)
                    point_sizes[mca_df.index.get_loc(idx)] = contributions.iloc[contrib_index, 0] * 1000
                except (KeyError, IndexError):
                    pass  # Keep default size if no contribution found
        else:
            # Fallback if contributions is not a DataFrame
            point_sizes = np.ones(len(mca_df)) * 500
        
        # Color mapping based on contribution
        import matplotlib.cm as cm
        
        # Scatter plot with variable sizes and colors
        scatter = plt.scatter(mca_df['Dim1'], mca_df['Dim2'], 
                              alpha=0.7, 
                              c=point_sizes, 
                              s=point_sizes, 
                              cmap='viridis')
