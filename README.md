# project

This project aims to analyze self-reported health data from the NHANES 1999-2000 survey and link it with follow-up mortality data. We will explore the significance of “self-reported health” as a health indicator through this analysis.

## Project Objectives

1. **Create a Public GitHub Repository**:
   - Set up a repository named `NHANES_SelfReportedHealth_Analysis` to facilitate collaboration and discussion.

2. **Utilize Publicly Available Data**:
   - Use NHANES 1999-2000 survey data and NCHS follow-up mortality data for the analysis.

3. **Documentation and Transparency**:
   - Document the project comprehensively using `README.md` and other necessary documentation to ensure transparency and reproducibility.

## Data Acquisition and Preparation

## Data Sources

### Survey Data

- Import demographic data from the 1999-2000 National Health and Nutrition Examination Survey (NHANES):
  - `DEMO.XPT` - Demographic data
  - Source: [NHANES 1999-2000 DEMO.XPT](https://wwwn.cdc.gov/Nchs/Nhanes/1999-2000/DEMO.XPT)

### Mortality Follow-up Data

- Obtain follow-up mortality data to analyze over a 20-year period from the National Center for Health Statistics (NCHS):
  - `NHANES_1999_2000_MORT_2019_PUBLIC.dat`
  - Source: [NHANES 1999-2000 Mortality Data](https://ftp.cdc.gov/pub/health_statistics/nchs/datalinkage/linked_mortality/NHANES_1999_2000_MORT_2019_PUBLIC.dat)

## Analysis Plan

1. **Import and Merge Data**:
   - Download and prepare the mortality follow-up data and link it to the demographic data using Stata.

2. **Create followup_mortality.do filw**:
    - use the do file from NCHS
    - edit the absolute file path
    - edit ```SURVEY``` and change it into ```NHANES_1999_2000```
    - save it as ```followup_mortality.do```
      
3. **Merge Data between NHANES and NCHS**:
    - use the following stata commands
    ```stata
      //use your own username/project repo instead of the class repo below
      global repo "https://raw.githubusercontent.com/Kristen6666/project/main/"
      do ${repo}followup.do
      save followup, replace 
      import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/1999-2000/DEMO.XPT", clear
      merge 1:1 seqn using followup
      lookfor follow
    ```

4. **Label variable**：
   - Excellent,
   - Very good,
   - Good,
   - Fair, 
   - Poor

   ```
   replace huq010=. if huq010==9
   label define huq 1 "Excellent" 2 "Very Good" 3 "Good" 4 "Fair" 5 "Poor"
   label values huq010 huq 
   ```

4. **Statistical Analysis**:
   - Use 95% confidence intervals and p-values to analyze the relationship between self-reported health and mortality.

5. **Visualization**:
   - Create survival curves and perform Cox regression analysis.

## Analysis Results

### Survival Analysis

Survival curves and Cox regression results are provided to analyze the impact of self-reported health on mortality.

![Survival Curve](path/to/survival_curve.png)

## Contact

- For any questions or suggestions, please use GitHub Discussions or Issues.

