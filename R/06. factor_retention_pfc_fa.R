# title: "Decide # of factors to retain for the EFA of the PFC scale"
# author: "Nicolas L Camacho"
# created: 1/14/2022
# updated: 8/11/2022

# Set up packages
library(tidyverse)
library(psych)

# set working directory (where cleaned data exists); combined_data folder
# setwd("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/analysis_data")
setwd("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data")

# Pull in the data
edited_final <- read_csv("edited_final_dataset.csv")

# keep only the pfc data
pfc_final <- dplyr::select(edited_final, subid, contains("pfc")) %>% 
  dplyr::select(., -contains("score"))

# assess scree plot
png("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/scree_plot.png",
    width = 900, height = 600)
scree(dplyr::select(pfc_final, -subid), factors = F, pc = T)
dev.off()
# PC -- scree suggests 1; KGC suggests 5

# polychoric
## using Weighted Least Squares
fa_wls_parallel <- fa.parallel(
  na.omit(dplyr::select(pfc_final, -subid)),
  fm = "wls", fa = "pc", use = "all.obs", cor = "poly", correct = 0.1,
  se.bars = TRUE, error.bars = TRUE,
  ylabel = "Eigenvalues of Principal Components",
  main = "Parallel Analysis on\nPolychoric Correlation Matrix of PFC-S Items") 
# 3 factors (PCA)