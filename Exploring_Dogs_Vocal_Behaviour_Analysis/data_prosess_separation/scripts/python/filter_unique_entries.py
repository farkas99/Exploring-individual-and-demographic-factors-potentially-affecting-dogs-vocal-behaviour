"""
Filter Unique Entries Script
---------------------------
This script filters the main dataset to keep only unique entries
where fill=1 and repfilt_full=1.

Author: Cline
Date: 2024
"""

import pandas as pd
from datetime import datetime
from pathlib import Path

def filter_unique_entries():
    # Set up paths
    base_dir = Path(__file__).parent.parent.parent.parent
    input_file = base_dir / "base_data" / "raw" / "DATA_STONE_BASE.xlsx"
    
    # Get current date for output filename
    current_date = datetime.now().strftime('%Y%m%d')
    output_file = base_dir / "base_data" / "raw" / f"DATA_STONE_BASE_{current_date}.xlsx"
    
    print(f"Reading data from: {input_file}")
    
    # Read the Excel file
    df = pd.read_excel(input_file)
    
    # Print original shape
    print(f"\nOriginal dataset shape: {df.shape}")
    
    # Filter for unique entries (fill=1 and repfilt_full=1)
    filtered_df = df[
        (df['fill'] == 1) & 
        (df['repfilt_full'] == 1)
    ]
    
    # Print filtered shape
    print(f"Filtered dataset shape: {filtered_df.shape}")
    print(f"Removed {df.shape[0] - filtered_df.shape[0]} duplicate/invalid entries")
    
    # Save filtered dataset
    filtered_df.to_excel(output_file, index=False)
    print(f"\nSaved filtered dataset to: {output_file}")

if __name__ == "__main__":
    filter_unique_entries()
