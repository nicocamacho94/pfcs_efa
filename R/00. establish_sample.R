# title: "PFC EFA -- narrow down sample from eligible individuals"
# author: "Nicolas L Camacho"
# created: 12/13/2021
# updated: 1/13/2022

# Set up packages
library(tidyverse)
library(VIM)

# set working directory
# setwd("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/analysis_data")
setwd("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data")

# Pull in the data
temp = list.files(pattern="*_data*")
list2env(
  lapply(setNames(temp, make.names(gsub("*.csv$", "", temp))), 
         read_csv), envir = .GlobalEnv)

# Keep only subid and eligible_final columns from eligibility data
screen_bds <- screen_data_bds_NLC_final %>% dplyr::select(., subid, eligible_final)
screen_dpap <- screen_data_dpap_NLC_final %>% dplyr::select(., subid, eligible_final)
screen_washu <- screen_data_ntrecWashu_NLC_final %>% dplyr::select(., subid, eligible_final)
screen_duke <- screen_data_ntrecDuke_NLC_final %>% dplyr::select(., subid, eligible_final)

# combine eligibility data
screen_data <- bind_rows(screen_bds, screen_dpap, screen_washu, screen_duke) # N = 1005

# separate out eligible and ineligible individuals
eligible <- filter(screen_data, eligible_final == 1) # N = 674
ineligible <- filter(screen_data, eligible_final == 0) # N = 331

# keep data gathered by CHF for participants who are eligible and narrow down dataset
chf_data <- inner_join(eligible, full_df_withCorrVars_data, by = "subid") 
## all eligible participants inside data gathered by CHF - N = 467
## delete "sc_pfc#_recode" columns and other unnecessary sc_pfc columns
chf_data <- dplyr::select(chf_data, -pfctotal, -pfcnotes, -contains("preschool"))

# remove a few participants
## due to incidental findings remove 7610_ntrec_duke; 7702_ntrec_duke has a chiari malformation, this was
## reported to the clinical interviewer by parent; has been identified as ineligible previously
inc_finding_duke <- filter(chf_data, subid == "7610_ntrec_duke")
## due to discrepancies in clerical notes for the visits of 7131_ntrec_washu, removing them
clerical_error_washu <- filter(chf_data, subid == "7131_ntrec_washu")
## remove them from chf_data
chf_data_2 <- filter(chf_data, subid != "7131_ntrec_washu" & subid != "7610_ntrec_duke")

## check missing data to see who participated and who did not
aggr(dplyr::select(chf_data_2, contains("pfc") & !contains("score")), numbers = TRUE, prop = c(TRUE, FALSE), cex.axis = 0.8)
### 436 individuals with 100% complete PFC data
### 15 individuals participated but did not complete the PFC-S
### 14 individuals have some missing data for the PFC-S
## separate these groups out
### gather usable missing data info
percentmissing = function (x){sum(is.na(x))/length(x)*100}
missing_sc_pfc_chf = apply(dplyr::select(chf_data_2, contains("pfc") & !contains("score")), 1, percentmissing)
table(missing_sc_pfc_chf)
### included sample, with 4-74% missing data
chf_include <- filter(chf_data_2, missing_sc_pfc_chf < 99) # N = 452
#### specific excluded groups
chf_exclude_noData <- filter(chf_data_2, missing_sc_pfc_chf > 99) # N = 15

# find participants eligible not in CHF initial dataset
inElig_notCHFinit <- filter(eligible, as.numeric((eligible$subid %in% full_dataset_102821$subid)) == 0) # N = 207
## this number is larger than the difference between the amount of participants in each dataset, N = 170 (no data at all)
## this may indicate that these are ~37 individuals who came in yet were not eligible
inCHFinit_notInElig <- filter(full_dataset_102821, as.numeric((full_dataset_102821$subid %in% eligible$subid)) == 0) # N = 37, 
## 11 of them are in ineligible (5 - DPAP; 4 - WASHU; 2 - DUKE); 2 are "b" datasets; 23 are "P" BDS participants; 1 seems to be a test person for ntrec_washu
## therefore, 26 of these datasets should NOT be considered in total dataset numbers

### FINAL NUMBERS FOR DATASETS ###
# Screened: 1005
# Eligible: 674; Ineligible: 331
# Have data for: 504-26 = 478
# Participated & Eligible: 467
# Removed post participantion: 2 (IF; clerical error)
# Final inclusion dataset: 465
# Included but no PFC-S data: 15 (removed due to 100% missing data)
# Included & has SOME PFC-S data: 450

# save these datasets
write.csv(screen_data, "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data/screen_dataset.csv",
          row.names = F)
write.csv(eligible, "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data/eligible_dataset.csv",
          row.names = F)
write.csv(ineligible, "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data/ineligible_dataset.csv",
          row.names = F)
write.csv(chf_data_2, "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data/inclusion_dataset.csv",
          row.names = F)
write.csv(chf_exclude_noData, "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data/missing100pfc_dataset.csv",
          row.names = F)
write.csv(chf_include, "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data/final_dataset.csv",
          row.names = F)
