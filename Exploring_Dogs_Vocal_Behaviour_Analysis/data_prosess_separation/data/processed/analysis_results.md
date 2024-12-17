# Dog Vocalization Analysis Results

## Overview
This document contains the comprehensive results of our analysis of dog vocalization patterns and their relationships with various environmental and demographic factors. The analysis is based on data from 5,718 dogs.

## Contents
1. [Data Overview](#data-overview)
2. [Growling Patterns Analysis](#growling-patterns)
3. [Origin Impact Analysis](#origin-impact)
4. [Keeping Conditions Analysis](#keeping-conditions)
5. [Statistical Relationships](#statistical-relationships)
6. [Conclusions](#conclusions)

## Data Overview
### Dataset Information

#### growl_to_whom.csv
- Number of records: 5718
- Number of features: 10
- Features: ID_full, growl_to_whom_Adult_man, growl_to_whom_Another_dog, growl_to_whom_Adult_woman, growl_to_whom_Postman, growl_to_whom_He_she_doesn't_growl, growl_to_whom_Children_less_than_10_years_old, growl_to_whom_A_man_with_a_beard, growl_to_whom_A_person_who_walks_unusually_limping_walking_with_a_cane_staggering, growl_to_whom_veterinarian

#### keep.csv
- Number of records: 5718
- Number of features: 6
- Features: ID_full, keep_Kennel_or_Fenced_Run, keep_Other_e.g._boarding_house, keep_In_the_garden, keep_Chained, keep_Inside_your_home_flat_apartment_house

#### origin.csv
- Number of records: 5718
- Number of features: 6
- Features: ID_full, origin_From_a_friend_not_breeder, origin_You_found_him_her, origin_From_a_breeder, origin_From_a_shelter, origin_He_she_was_born_at_my_home

#### problems.csv
- Number of records: 5718
- Number of features: 11
- Features: ID_full, problems_It_is_hard_or_impossible_to_call_him_her_back, problems_Separation_anxiety, problems_Noise_sensitive_thunder_firecrackers_etc., problems_Aggression_towards_other_dogs, problems_He_she_barks_too_much, problems_Jumps_on_people, problems_Shy, problems_Aggression_towards_people, problems_No_behavioral_problems, problems_Hyperactive

## Growling Patterns Analysis
### Growling Target Analysis

Percentage of dogs that growl at each target:
- growl_to_whom_Another_dog: 39.6%
- growl_to_whom_He_she_doesn't_growl: 24.2%
- growl_to_whom_A_person_who_walks_unusually_limping_walking_with_a_cane_staggering: 21.7%
- growl_to_whom_Adult_man: 12.0%
- growl_to_whom_Postman: 10.8%
- growl_to_whom_Children_less_than_10_years_old: 9.5%
- growl_to_whom_A_man_with_a_beard: 6.5%
- growl_to_whom_veterinarian: 6.3%
- growl_to_whom_Adult_woman: 5.6%

### Behavioral Clusters

#### Cluster 0 (66.1% of dogs)
Average standardized values:
- growl_to_whom_Adult_man: -0.195821
- growl_to_whom_Another_dog: 0.231331
- growl_to_whom_Adult_woman: -0.231548
- growl_to_whom_Postman: -0.074250
- growl_to_whom_He_she_doesn't_growl: -0.565098
- growl_to_whom_Children_less_than_10_years_old: -0.033354
- growl_to_whom_A_man_with_a_beard: -0.263030
- growl_to_whom_A_person_who_walks_unusually_limping_walking_with_a_cane_staggering: 0.026273
- growl_to_whom_veterinarian: -0.016322

#### Cluster 1 (24.2% of dogs)
Average standardized values:
- growl_to_whom_Adult_man: -0.369837
- growl_to_whom_Another_dog: -0.790675
- growl_to_whom_Adult_woman: -0.243074
- growl_to_whom_Postman: -0.343762
- growl_to_whom_He_she_doesn't_growl: 1.769605
- growl_to_whom_Children_less_than_10_years_old: -0.323925
- growl_to_whom_A_man_with_a_beard: -0.260089
- growl_to_whom_A_person_who_walks_unusually_limping_walking_with_a_cane_staggering: -0.521499
- growl_to_whom_veterinarian: -0.250272

#### Cluster 2 (3.6% of dogs)
Average standardized values:
- growl_to_whom_Adult_man: 2.539763
- growl_to_whom_Another_dog: 0.629263
- growl_to_whom_Adult_woman: 3.712108
- growl_to_whom_Postman: 1.792053
- growl_to_whom_He_she_doesn't_growl: -0.553764
- growl_to_whom_Children_less_than_10_years_old: 2.640052
- growl_to_whom_A_man_with_a_beard: 2.460044
- growl_to_whom_A_person_who_walks_unusually_limping_walking_with_a_cane_staggering: 1.403937
- growl_to_whom_veterinarian: 2.139103

#### Cluster 3 (6.1% of dogs)
Average standardized values:
- growl_to_whom_Adult_man: 2.080366
- growl_to_whom_Another_dog: 0.253292
- growl_to_whom_Adult_woman: 1.275668
- growl_to_whom_Postman: 1.104512
- growl_to_whom_He_she_doesn't_growl: -0.558427
- growl_to_whom_Children_less_than_10_years_old: 0.085402
- growl_to_whom_A_man_with_a_beard: 2.419790
- growl_to_whom_A_person_who_walks_unusually_limping_walking_with_a_cane_staggering: 0.949112
- growl_to_whom_veterinarian: -0.094525

## Origin Impact Analysis

#### origin_From_a_friend_not_breeder
- Chi-square statistic: 1.22
- p-value: 0.7484
Distribution across clusters:
|   Cluster |       0 |       1 |
|----------:|--------:|--------:|
|         0 | 85.2381 | 14.7619 |
|         1 | 85.7453 | 14.2547 |
|         2 | 83.0097 | 16.9903 |
|         3 | 84.5714 | 15.4286 |

#### origin_You_found_him_her
- Chi-square statistic: 4.44
- p-value: 0.2174
Distribution across clusters:
|   Cluster |       0 |       1 |
|----------:|--------:|--------:|
|         0 | 93.6243 | 6.37566 |
|         1 | 95.152  | 4.84805 |
|         2 | 93.6893 | 6.31068 |
|         3 | 94.5714 | 5.42857 |

#### origin_From_a_breeder
- Chi-square statistic: 51.15
- p-value: 0.0000
Distribution across clusters:
|   Cluster |       0 |       1 |
|----------:|--------:|--------:|
|         0 | 59.9735 | 40.0265 |
|         1 | 54.1968 | 45.8032 |
|         2 | 71.8447 | 28.1553 |
|         3 | 71.7143 | 28.2857 |

#### origin_From_a_shelter
- Chi-square statistic: 19.53
- p-value: 0.0002
Distribution across clusters:
|   Cluster |       0 |       1 |
|----------:|--------:|--------:|
|         0 | 79.127  | 20.873  |
|         1 | 79.3054 | 20.6946 |
|         2 | 74.2718 | 25.7282 |
|         3 | 69.7143 | 30.2857 |

#### origin_He_she_was_born_at_my_home
- Chi-square statistic: 2.49
- p-value: 0.4777
Distribution across clusters:
|   Cluster |       0 |       1 |
|----------:|--------:|--------:|
|         0 | 96.6667 | 3.33333 |
|         1 | 97.1056 | 2.89436 |
|         2 | 95.6311 | 4.36893 |
|         3 | 97.7143 | 2.28571 |

## Keeping Conditions Impact Analysis

Correlation analysis between keeping conditions and vocalization problems:

#### keep_Kennel_or_Fenced_Run correlations:
- problems_He_she_barks_too_much: 0.006 (p=0.6681)
- problems_Aggression_towards_people: 0.005 (p=0.6781)
- problems_Aggression_towards_other_dogs: 0.031 (p=0.0173)*

#### keep_Other_e.g._boarding_house correlations:
- problems_He_she_barks_too_much: 0.005 (p=0.6914)
- problems_Aggression_towards_people: -0.011 (p=0.4065)
- problems_Aggression_towards_other_dogs: -0.021 (p=0.1070)

#### keep_In_the_garden correlations:
- problems_He_she_barks_too_much: -0.000 (p=0.9897)
- problems_Aggression_towards_people: -0.035 (p=0.0088)*
- problems_Aggression_towards_other_dogs: 0.005 (p=0.7251)

#### keep_Chained correlations:
- problems_He_she_barks_too_much: -0.012 (p=0.3551)
- problems_Aggression_towards_people: 0.000 (p=0.9799)
- problems_Aggression_towards_other_dogs: 0.007 (p=0.6206)

#### keep_Inside_your_home_flat_apartment_house correlations:
- problems_He_she_barks_too_much: -0.002 (p=0.9087)
- problems_Aggression_towards_people: 0.007 (p=0.6056)
- problems_Aggression_towards_other_dogs: -0.011 (p=0.4007)

*Note: Asterisk (*) indicates statistically significant correlation (p < 0.05)

## Conclusions

### Key Statistical Findings

1. **Growling Patterns**
   - Most common target: Another dog (39.6%)
   - Four distinct behavioral clusters identified
   - Largest cluster (66.1%) shows selective growling mainly towards other dogs

2. **Origin Effects**
   - Significant relationship with breeder origin (p < 0.0001)
   - Significant relationship with shelter origin (p = 0.0002)
   - Other origins show no significant relationships

3. **Keeping Conditions**
   - Kennel/Fenced Run significantly correlates with dog aggression (r = 0.031, p = 0.0173)
   - Garden keeping significantly correlates with reduced human aggression (r = -0.035, p = 0.0088)
   - Other keeping conditions show no significant correlations

### Visualization References
All supporting visualizations can be found in the 'processed' directory:
- Growling patterns distribution
- Cluster analysis results
- Correlation matrices
- Origin impact distributions
- Keeping conditions relationships

*Note: All statistical values and distributions are preserved from the original analysis for reference and further study.*
