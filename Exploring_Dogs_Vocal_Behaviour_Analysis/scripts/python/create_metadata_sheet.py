import pandas as pd

# Load the dataset
file_path = r"C:\Users\Farkas\Documents\Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour\Exploring_Dogs_Vocal_Behaviour_Analysis\base_data\raw\DATA_Base_stone.xlsx"
data = pd.read_excel(file_path)

# Generate basic statistics
metadata = data.describe(include='all')

# Save the metadata to a new Excel file
metadata_file_path = r"C:\Users\Farkas\Documents\Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour\Exploring_Dogs_Vocal_Behaviour_Analysis\base_data\raw\metadata_sheet.xlsx"
metadata.to_excel(metadata_file_path)

print("Metadata sheet created successfully.")
