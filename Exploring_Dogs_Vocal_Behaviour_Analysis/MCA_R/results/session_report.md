# Multiple Correspondence Analysis (MCA) Session Report
## Analysis of Dog Vocalization Behavior

### 1. Methodology Overview
We conducted Multiple Correspondence Analysis (MCA) using R's FactoMineR package to analyze patterns in dog vocalization behavior. MCA was chosen because:
- It's suitable for categorical data analysis
- Our data consisted of binary (yes/no) responses
- We needed to analyze relationships between multiple variables simultaneously
- It provides dimensional reduction while preserving important relationships

### 2. Data Structure
We analyzed four distinct behavioral aspects:
1. Growling behavior patterns
2. Howling behavior patterns
3. Keeping conditions
4. Behavioral problems

Each dataset was processed to:
- Remove ID columns
- Convert variables to factors
- Handle any missing values
- Ensure proper formatting for MCA

### 3. Analysis Process
The analysis was conducted in three main steps:

#### Step 1: Data Preparation
- Loaded raw data from CSV files
- Cleaned and standardized variable names
- Converted all variables to factors
- Handled missing values where present

#### Step 2: MCA Calculations
- Used FactoMineR's MCA function
- Created Burt matrix for correlation analysis
- Calculated eigenvalues and contributions
- Generated dimensional coordinates

#### Step 3: Visualization
- Created scree plots showing explained variance
- Generated variable categories plots
- Produced biplots showing relationships
- Created contribution plots

### 4. Key Results

#### Growling Behavior Analysis
- First dimension explains 34.81% of variance
- Second dimension explains 14.54% of variance
- Strong associations found between adult-directed growling behaviors

#### Howling Behavior Analysis
- First dimension explains 55.79% of variance
- Second dimension explains 22.85% of variance
- Clear patterns in response to different sound stimuli

#### Keeping Conditions Analysis
- First dimension explains 30.78% of variance
- Second dimension explains 20.17% of variance
- Distinct patterns between indoor and outdoor keeping conditions

#### Behavioral Problems Analysis
- First dimension explains 20.64% of variance
- Second dimension explains 13.33% of variance
- Complex relationships between different behavioral issues

### 5. Visualization Outputs
All visualizations were saved in the results/figures directory:
- Individual scree plots
- Variable category plots
- Biplots
- Contribution plots
- Combined visualization plots

### 6. Technical Implementation
- Used R version 4.3.2
- Key packages:
  - FactoMineR for MCA calculations
  - factoextra for visualization
  - gridExtra for plot arrangement
  - missMDA for handling missing values

### 7. Data Storage
Results are stored in:
- Individual RData files for each behavioral aspect
- Combined workspace file (mca_workspace.RData)
- HTML report with interactive visualizations
- PNG files for all plots

### 8. Conclusions
The MCA analysis revealed distinct patterns in dog vocalization behavior:
- Clear groupings in growling behavior based on targets
- Strong correlations in howling responses to different stimuli
- Distinct patterns in keeping conditions and their relationships
- Complex interactions between different behavioral problems

This analysis provides valuable insights into the relationships between different aspects of dog vocal behavior and their associated factors.

### 9. Future Recommendations
- Consider additional demographic variables
- Analyze temporal patterns if data becomes available
- Investigate specific breed-related patterns
- Consider interaction effects between different behavioral aspects
