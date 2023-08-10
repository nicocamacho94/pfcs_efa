# title: "Decide # of factors to retain for the EFA of the PFC scale"
# author: "Nicolas L Camacho"
# created: 1/14/2022
# updated: 8/10/2023

# Set up packages
library(tidyverse)
library(psych)

# set working directory (where cleaned data exists); combined_data folder
# setwd("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/analysis_data")
setwd("C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/data")

# Pull in the data
edited_final <- read_csv("edited_final_dataset.csv")

# keep only the pfc data
pfc_final <- dplyr::select(edited_final, subid, contains("pfc")) %>% 
  dplyr::select(., -contains("score"))

# polychoric
## using Weighted Least Squares
fa_wls_parallel <- fa.parallel(
  na.omit(dplyr::select(pfc_final, -subid)),
  fm = "wls", fa = "pc", use = "all.obs", cor = "poly", correct = 0.1,
  se.bars = TRUE, error.bars = TRUE,
  ylabel = "Eigenvalues of Principal Components") 
# 3 factors (using principal components)