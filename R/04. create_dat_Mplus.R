# title: "PFC EFA -- make df to be analyzed in Mplus"
# author: "Nicolas L Camacho"
# created: 6/18/2021
# updated: 8/10/2023

# Set up packages
library(tidyverse)
library(multiplex)

# set working directory (where cleaned data exists); combined_data folder
# setwd("X:/Gaffrey/Lab/NTREC/NicolasCamacho/pfc_fa/paper/updated_process/data")
setwd("C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/data")

# Pull in the data
final_dataset <- read_csv("edited_final_dataset.csv")

# keep only the subid and pfc scale scores
pfc_final <- dplyr::select(final_dataset, subid, contains("pfc")) %>% 
  dplyr::select(., !contains("score"))

# find exactly where there are NA's
cbind(lapply(lapply(pfc_final, is.na), sum))

# replace NA's with 99 in order to be recognized by Mplus
pfc_final <- pfc_final %>% replace_na(list(
  pfc04 = 99, pfc06 = 99, pfc07 = 99, pfc08 = 99, pfc09 = 99,
  pfc10 = 99, pfc11 = 99, pfc12 = 99, pfc13 = 99, pfc14 = 99,
  pfc15 = 99, pfc16 = 99, pfc17 = 99, pfc18 = 99, pfc19 = 99,
  pfc20 = 99, pfc21 = 99, pfc22 = 99, pfc23 = 99))

# create .dat file to be imputed and analyzed in Mplus
# write.dat(pfc_scale_sample,
#           "X:/Gaffrey/Lab/NTREC/NicolasCamacho/pfc_fa/paper/updated_process/data")
write.dat(pfc_final,
          "C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/data")
