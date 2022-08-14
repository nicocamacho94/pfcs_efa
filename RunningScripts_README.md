# Understanding the Dimensions and Structure of the Preschool Feeling Checklist – Scale: A Factor Analysis

### This README file acts provides information that facilitates the use of the scripts in this repo.
### The analysis scripts were written by Nicolas L. Camacho.

## Preparing to run the scripts

### In order to run the scripts in this repo, you will need to have access to R and Mplus.
### - To download R for free, visit [this page](https://www.r-project.org/).
### - To purchase Mplus, visit [this page](https://www.statmodel.com/).

### Note that the scripts are written in such a way that they require the specification of folders to access data and deposit tables and figures. Make sure you are updating these sections to match the file structure on your device.
### - In R, look for "setwd" or any section that starts with "C:/Users/"
### - In Mplus, look for the section "DATA:"

## Order of scripts

#### Note that we de-identified the dataset provided in this repo before uploading it. Therefore, the R scripts "00. establish_sample" and "01. standardize_data" will not be compatible with this dataset. These two scripts are provided for the purposes of full transparency and were written as data wrangling scripts that the user of this repo will not need.

### First, we ran a few R scripts:
#### - The first four scripts (02a. - 02d.) can be run independently. These will provide the user with the summary of the demographics of the sample found in Tables 1 and 2 of the manuscript.
#### - The "03. eda" script is provided to show the visualizations and exploratory data analysis that we conducted to better understand the data with which we were working.
#### - The "04. create_dat_mplus" script creates a .dat file that Mplus can read. Note that missing values are changed from "NA" to "99" in the resulting file.
#### - The "check_assumptions_pfc_fa" script was written to run diagnostics of the PFC-S data. Here you will find ways to visualize missing data, find descriptives of each item, visualize the distribution of the responses for each item, test for multivariate normality, calculate polychoric correlations, and test for sampling adequacy to conduct a factor analysis. The visualizations and results that this script produces can be seen in the Supplementary Materials associated with the manuscript.

### Next, we ran a few Mplus scripts:
#### - The "cfa_wlsmv_1_allvars" script runs the 1-factor CFA using all items from the PFC-S

### Email: nicolas.camacho@duke.edu

## Software & Versions

### Analyses were conducted in R version 4.1.3 and Mplus version 8.6 using Windows 11 Pro via a Lenovo Thinkpad E490s.
