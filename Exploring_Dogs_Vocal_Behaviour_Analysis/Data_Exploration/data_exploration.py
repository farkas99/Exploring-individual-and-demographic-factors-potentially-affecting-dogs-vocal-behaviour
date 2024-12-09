# data_exploration.py

import pandas as pd
import os

def load_data(filepath):
    """
    Load data from the specified filepath.
    
    Args:
        filepath (str): Path to the data file.
        
    Returns:
        pd.DataFrame: Loaded data as a pandas DataFrame, or None if loading fails.
    """
    if not os.path.exists(filepath):
        print(f"File does not exist: {filepath}")
        return None

    try:
        df_loaded = pd.read_excel(filepath)
        print(f"Data loaded successfully from {filepath}")
        return df_loaded
    except pd.errors.EmptyDataError:
        print(f"No data found in: {filepath}")
    except Exception as e:
        print(f"An error occurred while loading data: {e}")

def explore_data(df):
    """
    Perform exploratory data analysis on the DataFrame.
    
    Args:
        df (pd.DataFrame): The data to analyze.
    """
    print("First five rows of the dataset:")
    print(df.head())

    print("\nSummary statistics:")
    print(df.describe())

    print("\nMissing values in each column:")
    print(df.isnull().sum())

def visualize_data(df):
    """
    Create visualizations for the data.
    
    Args:
        df (pd.DataFrame): The data to visualize.
    """
    plt.figure(figsize=(10, 6))
    sns.countplot(data=df, x='SomeCategoryColumn')
    plt.title('Distribution of Some Category')
    plt.show()

if __name__ == "__main__":
    data_filepath = "C:\\Users\\Farkas\\Documents\\Exploring-individual-and-demographic-factors-potentially-affecting-dogs-vocal-behaviour\\Exploring_Dogs_Vocal_Behaviour_Analysis\\base_data\\raw\\DATA_Base_stone.xlsx"
    data = load_data(data_filepath)
    if data is not None:
        explore_data(data)
        visualize_data(data)
