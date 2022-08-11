# title: "Calculate reliability for 3-factor solution"
# author: "Nicolas L Camacho"
# created: 1/22/2022
# updated: 8/9/2022

# set up packages
library(tidyverse)
library(psych)

# set working directory (where cleaned data exists); combined_data folder
# setwd("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/analysis_data")
setwd("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data")

# pull in the data
final_dataset <- read_csv("edited_final_dataset.csv")

# keep only pfc data
pfc_data <- dplyr::select(final_dataset, subid, contains("pfc"))

# create separate dataframes per PFC factor
## full scale
full_scale <- dplyr::select(pfc_data, -subid, -ch_pfc_score)
## 3-factor (with only cardinal loadings)
f1_3factor <- dplyr::select(pfc_data, pfc01, pfc03, pfc05, pfc09, pfc10) # cross = pfc17, pfc22 not included
f2_3factor <- dplyr::select(pfc_data, pfc04, pfc06, pfc07, pfc08, pfc11, pfc14, pfc23) # cross = pfc21, pfc22 not included
f3_3factor <- dplyr::select(pfc_data, pfc02, pfc12, pfc13, pfc15, pfc18, pfc19, pfc20) # cross = pfc17, pfc21 not included

# calculate Cronbach's ordinal alpha for each PFC factor using polychoric correl
## polychoric correl matrices
poly_full <- polychoric(full_scale, smooth = FALSE, ML = FALSE, correct = 0.1)
poly_f1 <- polychoric(f1_3factor, smooth = FALSE, ML = FALSE, correct = 0.1)
poly_f2 <- polychoric(f2_3factor, smooth = FALSE, ML = FALSE, correct = 0.1)
poly_f3 <- polychoric(f3_3factor, smooth = FALSE, ML = FALSE, correct = 0.1)
## full scale
a_full <- psych::alpha(full_scale, use = "pairwise", n.obs = 436) # a = 0.89
ord_a_full <- psych::alpha(poly_full$rho, use = "pairwise", n.obs = 436) # a= 0.93
## 3-factor
a_f1_3_factor_cross <- psych::alpha(poly_f1$rho, use = "pairwise", n.obs = 447) # a = 0.79
a_f2_3_factor_cross <- psych::alpha(poly_f2$rho, use = "pairwise", n.obs = 440) # a = 0.84
a_f3_3_factor_cross <- psych::alpha(poly_f3$rho, use = "pairwise", n.obs = 442) # a = 0.88

# calculate Cronbach's alpha for related variables
## BDI
a_bdi <- final_dataset %>% dplyr::select(., contains("bdi"), -bdi_mean) %>% 
  psych::alpha(.) # a = 0.9

## ERC
### 2-factor model
a_erc_ln <- final_dataset %>% dplyr::select(., erc2, erc4, erc5, erc6, erc8, erc9, 
                                            erc10, erc11, erc13, erc14, erc17, erc19, 
                                            erc20, erc22, erc24) %>% psych::alpha(.) # a = 0.89
a_erc_er <- final_dataset %>% dplyr::select(., erc1, erc3, erc7, erc15, erc16, erc18,
                                            erc21, erc23) %>% psych::alpha(.) # a = 0.74

## BIS/BAS
a_bis <- final_dataset %>% dplyr::select(., c_bisbas1, c_bisbas4, c_bisbas5,
                                         c_bisbas6, c_bisbas8, c_bisbas13, c_bisbas16) %>% 
  psych::alpha(.) # a = 0.70
a_bas <- final_dataset %>% dplyr::select(., c_bisbas7, c_bisbas14, c_bisbas19,
                                         c_bisbas20, c_bisbas10, c_bisbas15, c_bisbas17,
                                         c_bisbas18, c_bisbas2, c_bisbas3, c_bisbas9,
                                         c_bisbas11, c_bisbas12) %>% psych::alpha(.) # a = 0.82
a_bas_drive <- final_dataset %>% dplyr::select(., c_bisbas7, c_bisbas14, c_bisbas19,
                                         c_bisbas20) %>% psych::alpha(.) # a = 0.80
a_bas_funseek <- final_dataset %>% dplyr::select(., c_bisbas10, c_bisbas15, c_bisbas17,
                                               c_bisbas18) %>% psych::alpha(.) # a = 0.65
a_bas_reward <- final_dataset %>% dplyr::select(., c_bisbas2, c_bisbas3, c_bisbas9,
                                               c_bisbas11, c_bisbas12) %>% psych::alpha(.) # a = 0.75

## PANAS
a_panas_pa <- final_dataset %>% dplyr::select(., panas1, panas3, panas5, panas9,
                                              panas10, panas12, panas14, panas16,
                                              panas17, panas19) %>% psych::alpha(.) # a = 0.90
a_panas_na <- final_dataset %>% dplyr::select(., panas2, panas4, panas6, panas7,
                                              panas8, panas11, panas13, panas15,
                                              panas18, panas20) %>% psych::alpha(.) # a = 0.84

# create mean scores for factors from 3-factor model
## assess missingness 
percentmissing = function (x){sum(is.na(x))/length(x)*100} ## missing function
final_dataset_with3Factors <- final_dataset %>% 
  mutate(., 
         missing_f1_3factor =
           apply(select(., pfc01, pfc03, pfc05, pfc09, pfc10), 1, percentmissing), # cross = pfc17, pfc22 not included
         missing_f2_3factor = 
           apply(select(., pfc04, pfc06, pfc07, pfc08, pfc11, pfc14, pfc23), 1, percentmissing), # cross = pfc21, pfc22 not included
         missing_f3_3factor = 
           apply(select(., pfc02, pfc12, pfc13, pfc15, pfc18, pfc19, pfc20), 1, percentmissing)) # cross = pfc17, pfc21 not included
table(final_dataset_with3Factors$missing_f1_3factor) # 0 participant missing > 40% data
table(final_dataset_with3Factors$missing_f2_3factor) # 1 participant missing 71% data
table(final_dataset_with3Factors$missing_f3_3factor) # 1 participant missing 85% data
## create subscale mean scores
final_dataset_with3Factors <- final_dataset_with3Factors %>% 
  mutate(., 
         f1_3factor_mean =
           case_when(missing_f1_3factor < 75 ~ 
                       rowMeans(select(., pfc01, pfc03, pfc05, pfc09, pfc10), na.rm = T)),  # cross = pfc17, pfc22 not included
         f2_3factor_mean =
           case_when(missing_f2_3factor < 75 ~ 
                       rowMeans(select(., pfc04, pfc06, pfc07, pfc08, pfc11, pfc14, pfc23), na.rm = T)), # cross = pfc21, pfc22 not included
         f3_3factor_mean =
           case_when(missing_f3_3factor < 75 ~ 
                       rowMeans(select(., pfc02, pfc12, pfc13, pfc15, pfc18, pfc19, pfc20), na.rm = T))) # cross = pfc17, pfc21 not included

# collect basic descriptive info of the variables to be used in the correlation matrix
corr_vars_descript <- as.data.frame(psych::describe(
  dplyr::select(final_dataset_with3Factors, child_age, contains("mean")))) %>% 
  rownames_to_column(., "var_names")

write_excel_csv(corr_vars_descript,
                file = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/corr_vars_descript.csv")

# create a dataframe with only the varibles for the correlation matrix
corr_vars_with3factors <- dplyr::select(final_dataset_with3Factors, subid,
                                        child_age, contains("mean"))
# save corr matrix dataframe
write.csv(corr_vars_with3factors, "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data/corr_vars_with3Factors.csv",
          row.names = F)
