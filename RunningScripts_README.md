# Understanding the Dimensions and Structure of the Preschool Feelings Checklist – Scale: A Factor Analysis

### This README file acts provides information that facilitates the use of the scripts in this repo.
### The analysis scripts were written by Nicolas L. Camacho.

## Preparing to run the scripts

### In order to run the scripts in this repo, you will need to have access to R and Mplus.
### - To download R for free, visit [this page](https://www.r-project.org/).
### - To purchase Mplus, visit [this page](https://www.statmodel.com/).

### Analyses were conducted in R version 4.1.3 and Mplus version 8.6 using Windows 11 Pro via a Lenovo Thinkpad E490s.

### Note that the scripts are written in such a way that they require the specification of folders to access data and deposit tables and figures. Make sure you are updating these sections to match the file structure on your device.
### - In R, look for "setwd" or any section that starts with "C:/Users/"
### - In Mplus, look for the section "DATA:"

### When running R scripts, you will need to make sure that the packages specified at the top of each script have been installed on your local R. To do so, run "install.packages([enter package name here])" in the R Console.

## Order of scripts

#### Note that we de-identified the dataset provided in this repo before uploading it. Therefore, the R scripts "00. establish_sample" and "01. standardize_data" will not be compatible with this dataset. These two scripts are provided for the purposes of full transparency and were written as data wrangling scripts that the user of this repo will not need.

## First, we ran a few R scripts:
#### - The first four scripts (02a. - 02d.) can be run independently. These will provide the user with the summary of the demographics of the sample found in Tables 1 and 2 of the manuscript.
#### - The "03. eda" script is provided to show the visualizations and exploratory data analysis that we conducted to better understand the data with which we were working.
#### - The "04. create_dat_mplus" script creates a .dat file that Mplus can read. Note that missing values are changed from "NA" to "99" in the resulting file.
#### - The "check_assumptions_pfc_fa" script was written to run diagnostics of the PFC-S data. Here you will find ways to visualize missing data, find descriptives of each item, visualize the distribution of the responses for each item, test for multivariate normality, calculate polychoric correlations, and test for sampling adequacy to conduct a factor analysis. The visualizations and results that this script produces can be seen in the Supplementary Materials associated with the manuscript.

## Next, we ran the CFA Mplus script:
#### Note that there are two kinds of Mplus scripts in the folder in this repo: .inp and .out files. The .inp files are the files that Mplus will read as input material to run an analysis. The .out files are files that are created when a .inp file is run - it contains both the script and the analysis results.
#### - The "cfa_wlsmv_1_allvars" script runs the 1-factor CFA (WLSMV estimation) using all items from the PFC-S.

## Returning to R:
#### Because we found that the 1-factor CFA model of the PFC-S did not fit the data well, we conducted a visual inspection of the scree plot of the eigenvalues of the PFC-S data, using the Kaiser-Guttman Criterion and bend in the plot as initial assessments. We also conducted a parallel analysis on the principal components of the data. The "06. factor_retention_pfc_fa" script will do this for you. We used the information from these assessments to conduct the EFAs.

## Conducting EFAs in Mplus:
#### - The remaining scripts all run EFAs of the PFC-S data.
#### - The "efa_wlsmv_2_4_allvars" script runs 2, 3, and 4-factor EFA models (CF-Varimax oblique rotation, WLSMV estimation) on the data at once, providing results for each.
#### - The remaining scripts are iterations of the same analysis for a specific model, after an item was removed due to having a communality < 0.20 and/or no factor loadings > 0.30. These scripts are organized by version (e.g., v2.1, v2.2). The highest version (e.g., v2.2) shows the results reported in the manuscript in Table 3.
#### - Because we wanted to ensure that the results were robust to different rotation options, you will also find a "sensitivity_analyses" folder that conducts the same EFA analyses as specified above using oblique Direct-Oblimin rotation.

## Finishing up in R:
#### - The "07. calc_alpha_prep_corr_matrix" script was used to calculate the internal consistency of the estimated single factor and the explored 3 factors of the PFC-S. The internal consistencies of the scales and subscales of the other measures of interest were also calculated. A new file is created with the final versions of the mean composite scores of all scales and subscales.
#### - The last script, "08. correl_matrix", runs the Pearson's correlations among the mean composite scores of all the scales and subscales shown in Table 4 of the manuscript.

## Questions?

### Email: nicolas.camacho@duke.edu

