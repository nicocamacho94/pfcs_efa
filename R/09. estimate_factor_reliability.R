# title: "PFC EFA -- calculate reliability statistics for best model"
# author: "Nicolas L Camacho"
# created: 7/21/2023
# updated: 7/21/2023

# Set up packages
library(tidyverse)
library(BifactorIndicesCalculator)

# set working directory (where cleaned data exists); combined_data folder
# setwd("X:/Gaffrey/Lab/NTREC/NicolasCamacho/pfc_fa/paper/updated_process/code")
setwd("C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/code")

# estimate omega, omegaH, and ECV
## function will open a dialog box to choose the output file
bifactorIndicesMplus_ESEM(LoadMin = 0.3)
