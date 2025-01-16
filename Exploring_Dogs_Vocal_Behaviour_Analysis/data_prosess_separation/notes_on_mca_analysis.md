# Notes on Multiple Correspondence Analysis (MCA) Implementation

## Data Structure
We are working with several CSV files containing binary (0-1) data:

1. `grow_to_whom.csv` (5587 rows × 10 columns):
   - Binary indicators for growling targets
   - Example columns: 'Adult_man', 'Another_dog', etc.
   - Distribution example:
     * Another_dog: No (60.4%), Yes (39.6%)
     * Adult_man: No (87.9%), Yes (12.1%)

2. `howl_on_sound.csv` (5587 rows × 5 columns):
   - Binary indicators for howling triggers
   - Very imbalanced data, e.g.:
     * Ice_cream_truck: No (97.6%), Yes (2.4%)
     * Ambulance_sirens: No (84.7%), Yes (15.3%)

3. `keep.csv` (5587 rows × 6 columns):
   - Binary indicators for keeping conditions
   - Highly imbalanced data:
     * Inside_home: Yes (91.8%), No (8.2%)
     * Garden: No (73.3%), Yes (26.7%)

4. `problems.csv` (5587 rows × 11 columns):
   - Binary indicators for behavioral issues
   - More balanced distributions:
     * No_behavioral_problems: No (69.0%), Yes (31.0%)
     * Noise_sensitive: No (72.5%), Yes (27.5%)

## Current Issues

1. Data Loading Problems:
   - All files contain binary (0-1) data
   - Each row represents one dog
   - ID_full column needs to be removed before analysis
   - Some columns have very imbalanced distributions

2. MCA Implementation Issues:
   - Error with variable name handling (int vs string)
   - Coordinate extraction not working properly
   - Visualization labels need fixing

## Required Changes

1. Data Preprocessing:
   ```python
   # Correct way to load and prepare data
   data = pd.read_csv(file_path)
   data = data.drop('ID_full', axis=1)  # Remove ID column
   data = data.astype(int)  # Ensure binary 0-1 format
   ```

2. MCA Implementation:
   ```python
   # Correct MCA initialization
   mca = prince.MCA(n_components=2)
   coords = mca.fit_transform(data)
   var_coords = mca.column_coordinates(data)
   ```

3. Visualization:
   - Need to handle variable names properly
   - Plot both individual points and variable contributions
   - Add proper labels and legends

## Next Steps

1. Fix data type handling in MCA analysis
2. Implement proper coordinate extraction
3. Improve visualization with correct labels
4. Add interpretation of results

## Important Notes

- The data is already filtered for unique entries (fill=1 and repfilt_full=1)
- Binary variables represent presence (1) or absence (0) of behaviors/conditions
- Some categories are highly imbalanced, which may affect MCA results
- Need to consider the impact of rare categories (e.g., Chained: only 0.3% Yes)

## References

1. MCA Documentation: https://prince.readthedocs.io/en/latest/mca.html
2. Example implementation: https://www.sthda.com/english/articles/31-principal-component-methods-in-r-practical-guide/114-mca-multiple-correspondence-analysis-in-r-essentials/
