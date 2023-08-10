# title: "Calculate internal consistency"
# author: "Nicolas L Camacho"
# created: 1/22/2022
# updated: 7/24/2023

# set up packages
library(tidyverse)
library(psych)

# set working directory (where cleaned data exists); combined_data folder
# setwd("X:/Gaffrey/Lab/NTREC/NicolasCamacho/pfc_fa/paper/updated_process/data")
setwd("C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/data")

# pull in the data
final_dataset <- read_csv("edited_final_dataset.csv")

# keep only PFC-S data
pfc_data <- dplyr::select(final_dataset, subid, contains("pfc"))

# create separate dataframes per PFC-S factor
## full scale
full_scale <- dplyr::select(pfc_data, -subid, -ch_pfc_score)
## 3-factor (with only cardinal loadings)
f1_3factor <- dplyr::select(pfc_data, pfc01, pfc03, pfc05, pfc09, pfc10, pfc17, pfc22) # cross = pfc17, pfc22
f2_3factor <- dplyr::select(pfc_data, pfc04, pfc06, pfc07, pfc08, pfc11, pfc14, pfc21, pfc22, pfc23) # cross = pfc21, pfc22
f3_3factor <- dplyr::select(pfc_data, pfc02, pfc12, pfc13, pfc15, pfc17, pfc18, pfc19, pfc20, pfc21) # cross = pfc17, pfc21

# calculate Cronbach's ordinal alpha for each PFC-S factor using polychoric correl
## polychoric correl matrices
poly_full <- polychoric(full_scale, smooth = FALSE, ML = FALSE, correct = 0.1)
poly_f1 <- polychoric(f1_3factor, smooth = FALSE, ML = FALSE, correct = 0.1)
poly_f2 <- polychoric(f2_3factor, smooth = FALSE, ML = FALSE, correct = 0.1)
poly_f3 <- polychoric(f3_3factor, smooth = FALSE, ML = FALSE, correct = 0.1)
## full scale
ord_a_full <- psych::alpha(poly_full$rho, use = "pairwise", n.obs = 436) # a= 0.93
## 3-factor
a_f1_3_factor <- psych::alpha(poly_f1$rho, use = "pairwise", n.obs = 442) # a = 0.83
a_f2_3_factor <- psych::alpha(poly_f2$rho, use = "pairwise", n.obs = 439) # a = 0.88
a_f3_3_factor <- psych::alpha(poly_f3$rho, use = "pairwise", n.obs = 441) # a = 0.89

# calculate average inter-item correlations for each PFC-S factor using polychoric correl
aic_f1_3_factor <- poly_f1$rho %>% na_if(., 1) %>% colMeans(., na.rm = T) %>% mean(.) # aic = 0.42
aic_f2_3_factor <- poly_f2$rho %>% na_if(., 1) %>% colMeans(., na.rm = T) %>% mean(.) # aic = 0.44
aic_f3_3_factor <- poly_f3$rho %>% na_if(., 1) %>% colMeans(., na.rm = T) %>% mean(.) # aic = 0.48

# calculate Cronbach's alpha and aic's for construct validation variables
## BDI
bdi_data <- dplyr::select(final_dataset, contains("bdi"), -bdi_mean)
poly_bdi <- polychoric(bdi_data, smooth = FALSE, ML = FALSE, correct = 0.1)
a_bdi <- psych::alpha(poly_bdi$rho, use = "pairwise", n.obs = 447) # a = 0.95
aic_bdi <- poly_bdi$rho %>% na_if(., 1) %>% colMeans(., na.rm = T) %>% mean(.) # a = 0.49

## ERC
### Lability/Negativity
erc_ln_data <- final_dataset %>% 
  dplyr::select(., erc2, erc4, erc5, erc6, erc8, erc9, erc10, erc11, erc13, 
                erc14, erc17, erc19, erc20, erc22, erc24)
poly_erc_ln <- polychoric(erc_ln_data, smooth = FALSE, ML = FALSE, correct = 0.1)
a_erc_ln <- psych::alpha(poly_erc_ln$rho, use = "pairwise", n.obs = 442) # a = 0.93
aic_erc_ln <- poly_erc_ln$rho %>% na_if(., 1) %>% colMeans(., na.rm = T) %>% mean(.) # a = 0.46
### Emotion Regulation
erc_er_data <- final_dataset %>% 
  dplyr::select(., erc1, erc3, erc7, erc15, erc16, erc18, erc21, erc23) 
poly_erc_er <- polychoric(erc_er_data, smooth = FALSE, ML = FALSE, correct = 0.1)
a_erc_er <- psych::alpha(poly_erc_er$rho, use = "pairwise", n.obs = 446) # a = 0.84
aic_erc_er <- poly_erc_er$rho %>% na_if(., 1) %>% colMeans(., na.rm = T) %>% mean(.) # a = 0.40

## BIS/BAS
bis_data <- final_dataset %>% 
  dplyr::select(., c_bisbas1, c_bisbas4, c_bisbas5, c_bisbas6, c_bisbas8, c_bisbas13, c_bisbas16) 
poly_bis <- polychoric(bis_data, smooth = FALSE, ML = FALSE, correct = 0.1)
a_bis <- psych::alpha(poly_bis$rho, use = "pairwise", n.obs = 354) # a = 0.72
aic_bis <- poly_bis$rho %>% na_if(., 1) %>% colMeans(., na.rm = T) %>% mean(.) # a = 0.27

bas_data <- final_dataset %>% 
  dplyr::select(., c_bisbas7, c_bisbas14, c_bisbas19, c_bisbas20, c_bisbas10, 
                c_bisbas15, c_bisbas17, c_bisbas18, c_bisbas2, c_bisbas3, 
                c_bisbas9, c_bisbas11, c_bisbas12)
poly_bas <- polychoric(bas_data, smooth = FALSE, ML = FALSE, correct = 0.1)
a_bas <- psych::alpha(poly_bas$rho, use = "pairwise", n.obs = 348) # a = 0.86
aic_bas <- poly_bas$rho %>% na_if(., 1) %>% colMeans(., na.rm = T) %>% mean(.) # a = 0.32

bas_drive_data <- final_dataset %>% 
  dplyr::select(., c_bisbas7, c_bisbas14, c_bisbas19, c_bisbas20) 
poly_bas_drive <- polychoric(bas_drive_data, smooth = FALSE, ML = FALSE, correct = 0.1)
a_bas_drive <- psych::alpha(poly_bas_drive$rho, use = "pairwise", n.obs = 357) # a = 0.84
aic_bas_drive <- poly_bas_drive$rho %>% na_if(., 1) %>% colMeans(., na.rm = T) %>% mean(.) # a = 0.57

bas_funseek_data <- final_dataset %>% 
  dplyr::select(., c_bisbas10, c_bisbas15, c_bisbas17, c_bisbas18) 
poly_bas_funseek <- polychoric(bas_funseek_data, smooth = FALSE, ML = FALSE, correct = 0.1)
a_bas_funseek <- psych::alpha(poly_bas_funseek$rho, use = "pairwise", n.obs = 357) # a = 0.69
aic_bas_funseek <- poly_bas_funseek$rho %>% na_if(., 1) %>% colMeans(., na.rm = T) %>% mean(.) # a = 0.36


bas_reward_data <- final_dataset %>% 
  dplyr::select(., c_bisbas2, c_bisbas3, c_bisbas9, c_bisbas11, c_bisbas12) 
poly_bas_reward <- polychoric(bas_reward_data, smooth = FALSE, ML = FALSE, correct = 0.1)
a_bas_reward <- psych::alpha(poly_bas_reward$rho, use = "pairwise", n.obs = 357) # a = 0.81
aic_bas_reward <- poly_bas_reward$rho %>% na_if(., 1) %>% colMeans(., na.rm = T) %>% mean(.) # a = 0.46

## PANAS
panas_pa_data <- final_dataset %>% 
  dplyr::select(., panas1, panas3, panas5, panas9, panas10, panas12, panas14, 
                panas16, panas17, panas19) 
poly_pa <- polychoric(panas_pa_data, smooth = FALSE, ML = FALSE, correct = 0.1)
a_panas_pa <- psych::alpha(poly_pa$rho, use = "pairwise", n.obs = 365) # a = 0.92
aic_panas_pa <- poly_pa$rho %>% na_if(., 1) %>% colMeans(., na.rm = T) %>% mean(.) # a = 0.54

panas_na_data <- final_dataset %>% 
  dplyr::select(., panas2, panas4, panas6, panas7, panas8, panas11, panas13, 
                panas15, panas18, panas20)
poly_na <- polychoric(panas_na_data, smooth = FALSE, ML = FALSE, correct = 0.1)
a_panas_na <- psych::alpha(poly_na$rho, use = "pairwise", n.obs = 365) # a = 0.90
aic_panas_na <- poly_na$rho %>% na_if(., 1) %>% colMeans(., na.rm = T) %>% mean(.) # a = 0.48

# create mean scores for factors from 3-factor model
## assess missingness 
percentmissing = function (x){sum(is.na(x))/length(x)*100} ## missing function
final_dataset_with3Factors <- final_dataset %>% 
  mutate(., 
         missing_f1_3factor =
           apply(select(., pfc01, pfc03, pfc05, pfc09, pfc10, pfc17, pfc22), 1, percentmissing), # cross = pfc17, pfc22
         missing_f2_3factor = 
           apply(select(., pfc04, pfc06, pfc07, pfc08, pfc11, pfc14, pfc21, pfc22, pfc23), 1, percentmissing), # cross = pfc21, pfc22
         missing_f3_3factor = 
           apply(select(., pfc02, pfc12, pfc13, pfc15, pfc17, pfc18, pfc19, pfc20, pfc21), 1, percentmissing)) # cross = pfc17, pfc21
table(final_dataset_with3Factors$missing_f1_3factor) # 0 participant missing > 57% data
table(final_dataset_with3Factors$missing_f2_3factor) # 1 participant missing 77% data
table(final_dataset_with3Factors$missing_f3_3factor) # 1 participant missing 88% data
## create subscale mean scores
final_dataset_with3Factors <- final_dataset_with3Factors %>% 
  mutate(., 
         f1_3factor_mean =
           case_when(missing_f1_3factor < 75 ~ 
                       rowMeans(select(., pfc01, pfc03, pfc05, pfc09, pfc10, pfc17, pfc22), na.rm = T)), # cross = pfc17, pfc22
         f2_3factor_mean =
           case_when(missing_f2_3factor < 75 ~ 
                       rowMeans(select(., pfc04, pfc06, pfc07, pfc08, pfc11, pfc14, pfc21, pfc22, pfc23), na.rm = T)), # cross = pfc21, pfc22
         f3_3factor_mean =
           case_when(missing_f3_3factor < 75 ~ 
                       rowMeans(select(., pfc02, pfc12, pfc13, pfc15, pfc17, pfc18, pfc19, pfc20, pfc21), na.rm = T))) # cross = pfc17, pfc21

# collect basic descriptive info of the variables to be used in the correlation matrix
corr_vars_descript <- as.data.frame(psych::describe(
  dplyr::select(final_dataset_with3Factors, child_age, contains("mean")))) %>% 
  rownames_to_column(., "var_names")

write_excel_csv(corr_vars_descript,
                file = "C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/visuals/corr_vars_descript.csv")

# create a dataframe with only the varibles for the correlation matrix
corr_vars_with3factors <- dplyr::select(final_dataset_with3Factors, subid,
                                        child_age, contains("mean"))
# save corr matrix dataframe
write.csv(corr_vars_with3factors, "C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/data/corr_vars_with3Factors.csv",
          row.names = F)
