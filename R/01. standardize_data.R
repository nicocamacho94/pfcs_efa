# title: "PFC EFA -- standardize the dataset to be usable"
# author: "Nicolas L Camacho"
# created: 1/13/2022
# updated: 8/11/2022

# set up packages
library(tidyverse)
library(car)

# set working directory (where cleaned data exists); combined_data folder
# setwd("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/analysis_data")
setwd("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data")

# pull in the data
final_dataset <- read_csv("final_dataset.csv")

# adjust datatypes for necessary columns (BDI & PFC)
adjusted_dataset <- final_dataset %>% 
  dplyr::select(., subid, contains("pfc") | contains("bdi")) %>% 
  dplyr::select(., -pfc01, -pfc03, -pfc09, -ch_pfc_score, -bditotalscore, -bdinotes, -contains("complete")) %>% 
  mutate_at(vars(-contains("subid")), ~substr(., 1,1)) %>% 
  mutate_at(vars(-contains("subid")), ~as.numeric(.))

# bring data back to main dataset
edited_temp <- right_join(adjusted_dataset, final_dataset, by = "subid") %>% 
  dplyr::select(., -contains(".y")) %>% rename_all(~str_replace_all(., ".x", ""))

# reverse code items 1, 3, and 9 from the PFC-S, when the data is in label format
# leave all other data the same
edited_final = edited_temp %>%
  mutate(pfc01 = case_when(pfc01 == "0.  Never" ~ 4,
                           pfc01 == "1.  Rarely" ~ 3,
                           pfc01 == "2.  Sometimes" ~ 2,
                           pfc01 == "3.  Often" ~ 1,
                           pfc01 == "4.  Most of the Time"~ 0,
                           pfc01 == 0 ~ 0, pfc01 == 1 ~ 1, pfc01 == 2 ~ 2, pfc01 == 3 ~ 3, pfc01 == 4 ~ 4),
         pfc03 = case_when(pfc03 == "0.  Never" ~ 4,
                           pfc03 == "1.  Rarely" ~ 3,
                           pfc03 == "2.  Sometimes" ~ 2,
                           pfc03 == "3.  Often" ~ 1,
                           pfc03 == "4.  Most of the Time"~ 0,
                           pfc03 == 0 ~ 0, pfc03 == 1 ~ 1, pfc03 == 2 ~ 2, pfc03 == 3 ~ 3, pfc03 == 4 ~ 4),
         pfc09 = case_when(pfc09 == "0.  Never" ~ 4,
                           pfc09 == "1.  Rarely" ~ 3,
                           pfc09 == "2.  Sometimes" ~ 2,
                           pfc09 == "3.  Often" ~ 1,
                           pfc09 == "4.  Most of the Time"~ 0,
                           pfc09 == 0 ~ 0, pfc09 == 1 ~ 1, pfc09 == 2 ~ 2, pfc09 == 3 ~ 3, pfc09 == 4 ~ 4))

# relocate the 3 pfc variables that got moved around
edited_final <- edited_final %>% relocate(pfc01, .before = pfc02) %>% 
  relocate(pfc03, .before = pfc04) %>% relocate(pfc09, .before = pfc10)

# remove unnecessary columns & rename some columns
edited_final <- dplyr::select(edited_final,
                              -bdinotes, -beck_depression_inventory_2_bdiii_complete,
                              -panasnotes, -ercnotes, -emotional_regulation_checklist_erc_complete,
                              -bisbas_for_children_complete, -cbisbas, -contains("kbit"),
                              -has_child_lived_last_6_mo_w_you, -assessmentyear) %>% 
  rename(., reporter = Reporter, depend_household = ppl_dependent_on_household_income_screening, 
         child_sex = child_gender)

# clean various variables
## child bio sex -- 3201_dpap & 7811_ntrec_duke (both female)
edited_final <- edited_final %>% mutate(child_sex = if_else(is.na(child_sex), "Female", child_sex))

## dates
edited_final <- edited_final %>% mutate(date_parent_visit = word(dateofparentinterview, 1)) %>% 
  dplyr::select(., -dateofparentinterview) ## on 9 occasions, child and parent visit dates differ

edited_final$childsdate_of_birth = as.Date(edited_final$childsdate_of_birth, "%m/%d/%Y")
edited_final$date_parent_visit = as.Date(edited_final$date_parent_visit, "%m/%d/%Y")

edited_final$child_age = as.numeric(difftime(edited_final$date_parent_visit, edited_final$childsdate_of_birth, units = "auto")/365)

edited_final <- dplyr::select(edited_final, -childsdate_of_birth)

## child ethnicity
edited_final <- edited_final %>% 
  mutate(child_ethnicity = if_else(child_race == "white/hispanic" | child_race == "hispanic", "Hispanic/Latino", child_ethnicity)) %>% 
  mutate(child_ethnicity = case_when(child_ethnicity == "FALSE" ~ "Not Hispanic/Latino",
                                     child_ethnicity == "TRUE" ~ "Hispanic/Latino",
                                     child_ethnicity == "Hispanic or Latino" ~ "Hispanic/Latino",
                                     child_ethnicity == "Not Hispanic or Latino origin" ~ "Not Hispanic/Latino",
                                     child_ethnicity == "Hispanic/Latino" ~ "Hispanic/Latino")) 

## child race
edited_final <- edited_final %>% 
  mutate(child_race = case_when(child_race == "white" ~ "Caucasian",
                                child_race == "african-american" ~ "AfricanAmerican",
                                child_race == "hispanic" ~ "Other (unspec)",
                                child_race == "white/hispanic" ~ "Caucasian",
                                child_race == "white/african-american" ~ "Mixed (unspec)",
                                child_race == "White" ~ "Caucasian",
                                child_race == "Mixed racial background" ~ "Mixed (unspec)",
                                child_race == "African American" ~ "AfricanAmerican",
                                child_race == "Other" ~ "Other (unspec)",
                                child_race == "American Indian/Alaskan Native" ~ "AmerIndAlaskNative")) 

### race missing for 7563_ntrec_duke, 7593_ntrec_duke, 7623_ntrec_duke; gathered from REDCap
edited_final$child_race[edited_final$subid == "7563_ntrec_duke"] <- "Asian"
edited_final$child_race[edited_final$subid == "7593_ntrec_duke"] <- "Asian"
edited_final$child_race[edited_final$subid == "7623_ntrec_duke"] <- "Asian"

## parent edu
edited_final <- edited_final %>% 
  mutate(parent_education = if_else(is.na(parent_education), "NA - BDS + 2 NTREC",
                                    if_else(str_ends(subid, "_bds"), "NA - BDS + 2 NTREC",
                                            if_else(parent_education == "high school diploma", "High school diploma",
                                                    if_else(parent_education == "Some school beyond college", "Professional or graduate degree", parent_education)))))

## family income
edited_final <- edited_final %>% 
  mutate(fam_income = if_else(is.na(household_income_screening), family_income, household_income_screening)) %>% 
  mutate(fam_income = if_else(is.na(fam_income), "NA (BDS only)", fam_income)) %>% 
  mutate(fam_income = if_else(str_starts(fam_income, "At"), "$30,000-$60,000 per year (DPAP only)",
                                      if_else(str_starts(fam_income, "Less"), "<$30,000 per year (DPAP only)",
                                              if_else(str_starts(fam_income, "less"), "NA (BDS only)", fam_income)))) %>% 
  mutate(fam_income = if_else(fam_income == "$60,000 or more a year (>5000/month, >1154/week)", "$60,000+ per year (DPAP only)", fam_income)) %>% 
  mutate(fam_income = str_remove(.$fam_income, " per year")) %>% 
  dplyr::select(., -household_income_screening, -family_income) %>% 
  mutate(fam_income = if_else(fam_income == "Refused", "Refused or Don't know",
                              if_else(fam_income == "Don't know", "Refused or Don't know", fam_income))) %>%
  mutate(fam_income = 
           if_else(str_starts(fam_income, "No") | fam_income == "$5001-$10,000" |
                     fam_income == "$10,001-$15,000" | fam_income == "$15,001-$20,000", "$0-$20,000",
                   if_else(fam_income == "$20,001-$25,000" | fam_income == "$25,001-$30,000" |
                             fam_income == "$30,001-$35,000" | fam_income == "$35,001-$40,000", "$20,001-$40,000",
                           if_else(fam_income == "$40,001-$45,000" | fam_income == "$45,001-$50,000" |
                                     fam_income == "$50,001-$55,000" | fam_income == "$55,001-$60,000", "$40,001-$60,000",
                                   if_else(fam_income == "$60,001-$65,000" | fam_income == "$65,001-$70,000" |
                                             fam_income == "$70,001-$75,000" | fam_income == "$75,001-$80,000", "$60,001-$80,000",
                                           if_else(fam_income == "$80,001-$85,000" | fam_income == "$85,001-$90,000" |
                                                     fam_income == "$90,001-$95,000" | fam_income == "$95,001-$100,000", "$80,001-$100,000", fam_income))))))

## reporter
edited_final <- edited_final %>% 
  dplyr::select(., -are_you_biological_mother, -are_you_primary_caregiver) %>% 
  mutate(reporter = case_when(reporter == "Other" ~ "Other", # there is 1 NA (5001_bds) and 1 Other (5314_bds) -- find out who they are???
                              reporter == "Mother" ~ "BioMom",
                              reporter == "Father" ~ "BioDad",
                              reporter == "Biological_Mother" ~ "BioMom",
                              reporter == "Biological_Father" ~ "BioDad",
                              reporter == "Grandmother" ~ "Grandmother"))
### there is one participant from BDS (5001) that was brought in by bio mother - adding info here
edited_final$reporter[edited_final$subid == "5001_bds"] <- "BioMom"

##### GATHER THE VARIABLES FOR THE CORRELATION MATRIX AND ADD TO DATAFRAME #####
# set working directory
# setwd("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/paper/raw_data")
setwd("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/raw_data")

# Pull in the data
temp = list.files(pattern="*correlvars*")
list2env(
  lapply(setNames(temp, make.names(gsub("*.csv$", "", temp))), 
         read_csv), envir = .GlobalEnv)

# bds
## clean up vars
bds_first <- dplyr::select(bds_firstentry_2022_02_02_correlvars, -contains("redcap"),
                           -contains("notes"), -contains("complete"), -c_bisbas)
bds_second <- dplyr::select(bds_secondentry_2022_02_02_correlvars, -contains("redcap"),
                            -contains("notes"), -contains("complete"), -cbisbas)
## combine dataframes based on all variables; shouldn't have duplicates if all match
bds_all <- full_join(bds_first, bds_second)
### check if duplicates created because of mismatched data
bds_all$subid[as.numeric(duplicated(bds_all$subid)) == 1] # "5363" "5436" "5438" "5458" "P512"
### assess differences
bds_5363 <- bds_all[bds_all$subid == "5363",] # one does not have PANAS data
bds_5436 <- bds_all[bds_all$subid == "5436",] # one does not have PANAS data
bds_5438 <- bds_all[bds_all$subid == "5438",] # one does not have PANAS data
bds_5458 <- bds_all[bds_all$subid == "5458",] # one does not have PANAS data
bds_P512 <- bds_all[bds_all$subid == "P512",] # one does not have any data
### remove rows without PANAS/any data
bds_all_nodup <- bds_all %>% 
  filter(., !(subid == "5363" & is.na(panas1))) %>% 
  filter(., !(subid == "5436" & is.na(panas1))) %>% 
  filter(., !(subid == "5438" & is.na(panas1))) %>% 
  filter(., !(subid == "5458" & is.na(panas1))) %>% 
  filter(., !(subid == "P512" & is.na(erc1)))

## rename subid's
bds_all_nodup$subid <- paste(bds_all_nodup$subid, "_bds", sep = "")

# dpap
## clean up vars
dpap_first <- dplyr::select(dpap_firstentry_2022_02_02_correlvars, -contains("notes"),
                            -contains("complete"), -cbisbas)
dpap_second <- dplyr::select(dpap_secondentry_2022_02_02_correlvars, -contains("notes"),
                             -contains("complete"), -cbisbas)
## combine dataframes based on all variables; shouldn't have duplicates if all match
dpap_all <- full_join(dpap_first, dpap_second)
### check if duplicates created because of mismatched data
dpap_all$subid[as.numeric(duplicated(dpap_all$subid)) == 1] 
#### duplicates: "3005" "3026" "3030" "3036" "3051" "3073" "3151" "3187" "3205" "3208"
### assess differences
dpap_3005 <- dpap_all[dpap_all$subid == "3005",] # diff in cbisbas10/c_totalfunseek; keep one with 6/21
dpap_3026 <- dpap_all[dpap_all$subid == "3026",] # diff in panas18/19/pa/na; keep one with 5/1/38/21
dpap_3030 <- dpap_all[dpap_all$subid == "3030",] # diff in erc3; keep one with 1
dpap_3036 <- dpap_all[dpap_all$subid == "3036",] # diff in erc vars; keep one with 16/10 for subscales
dpap_3051 <- dpap_all[dpap_all$subid == "3051",] # one does not have PANAS data; keep one with data
dpap_3073 <- dpap_all[dpap_all$subid == "3073",] # diff in erc9/erc_subscale_1; keep one with 2/23
dpap_3151 <- dpap_all[dpap_all$subid == "3151",] # diff in panas14/15/pa/na; keep one with NA's
dpap_3187 <- dpap_all[dpap_all$subid == "3187",] # diff in erc23/erc_emotreg; keep one with 3/25
dpap_3205 <- dpap_all[dpap_all$subid == "3205",] # diff in panas12/pa; keep one with 5/50
dpap_3208 <- dpap_all[dpap_all$subid == "3208",] # diff in erc23/erc_emotreg; keep one with 3/26
### remove rows according to findings above
dpap_all_nodup <- dpap_all %>% 
  filter(., !(subid == "3005" & c_bisbas10 != 6)) %>% 
  filter(., !(subid == "3026" & panaspa != 38)) %>% 
  filter(., !(subid == "3030" & erc3 != 1)) %>% 
  filter(., !(subid == "3036" & erc_emotreg != 10)) %>% 
  filter(., !(subid == "3051" & is.na(panas1))) %>%
  filter(., !(subid == "3073" & erc9 != 2)) %>% 
  filter(., !(subid == "3151" & is.na(panaspa))) %>% 
  filter(., !(subid == "3187" & erc_emotreg != 25)) %>% 
  filter(., !(subid == "3205" & panaspa != 50)) %>% 
  filter(., !(subid == "3208" & erc_emotreg != 26))

## rename subid's
dpap_all_nodup$subid <- paste(dpap_all_nodup$subid, "_dpap", sep = "")

# ntrec
## duke
### clean up vars
ntrec_duke <- dplyr::select(ntrec_duke_2022_02_02_correlvars, -contains("redcap"),
                            -contains("timestamp"), -contains("notes"),
                            -contains("complete"), -cbisbas)
### rename subid's
ntrec_duke$subid <- paste(ntrec_duke$subid, "_ntrec_duke", sep = "")

## washu
### clean up vars
ntrec_washu <- dplyr::select(ntrec_washu_2022_02_02_correlvars, -contains("notes"),
                             -contains("complete"), -cbisbas)
### rename subid's
ntrec_washu$subid <- paste(ntrec_washu$subid, "_ntrec_washu", sep = "")

# check that column names match
colnames(bds_all_nodup) == colnames(dpap_all_nodup)
colnames(ntrec_duke) == colnames(ntrec_washu)
colnames(bds_all_nodup) == colnames(ntrec_duke)

# merge all dataframes
## ensure all subid's are characters
bds_all_nodup$subid <- as.character(bds_all_nodup$subid)
dpap_all_nodup$subid <- as.character(dpap_all_nodup$subid)
ntrec_washu$subid <- as.character(ntrec_washu$subid)
ntrec_duke$subid <- as.character(ntrec_duke$subid)
## merge
all_corr_vars <- bind_rows(bds_all_nodup, dpap_all_nodup, 
                           ntrec_washu, ntrec_duke)

# create mean scores for each variable
## assess missingness per questionnaire subscale
percentmissing = function (x){sum(is.na(x))/length(x)*100} # missing function
### Emotion Regulation Checklist
#### Negativity / Lability
all_corr_vars <- all_corr_vars %>% 
  mutate(., missing_erc_nl = apply(dplyr::select(., erc2, erc4, erc5, erc6, erc8, erc9,
                                          erc10, erc11, erc13, erc15, erc17, erc19,
                                          erc20, erc22, erc24), 1, percentmissing))
table(all_corr_vars$missing_erc_nl) # 20 participants missing >53%+ data
all_corr_vars <- all_corr_vars %>% 
  mutate(., erc_nl_mean = case_when(missing_erc_nl < 100 ~ 
                                      rowMeans(dplyr::select(., erc2, erc4, erc5, erc6, erc8, erc9,
                                                      erc10, erc11, erc13, erc15, erc17, erc19,
                                                      erc20, erc22, erc24), na.rm = T)))
#### Emotion Regulation
all_corr_vars <- all_corr_vars %>% 
  mutate(., missing_erc_er = apply(dplyr::select(., erc1, erc3, erc7, erc15, erc16, erc18,
                                          erc21, erc23), 1, percentmissing))
table(all_corr_vars$missing_erc_er) # 22 participants missing 87%+ data
all_corr_vars <- all_corr_vars %>% 
  mutate(., erc_er_mean = case_when(missing_erc_er < 75 ~ 
                                      rowMeans(dplyr::select(., erc1, erc3, erc7, erc15, 
                                                      erc16, erc18, erc21, erc23), na.rm = T)))
### BIS/BAS
#### Total BIS
all_corr_vars <- all_corr_vars %>% 
  mutate(., missing_totalbis = apply(dplyr::select(., c_bisbas1, c_bisbas4, c_bisbas5, 
                                            c_bisbas6, c_bisbas8, c_bisbas13, 
                                            c_bisbas16), 1, percentmissing))
table(all_corr_vars$missing_totalbis) # 124 participants missing 100% data
all_corr_vars <- all_corr_vars %>% 
  mutate(., total_bis_mean = case_when(missing_totalbis < 100 ~ 
                                         rowMeans(dplyr::select(., c_bisbas1, c_bisbas4, c_bisbas5, 
                                                         c_bisbas6, c_bisbas8, c_bisbas13, 
                                                         c_bisbas16), na.rm = T)))
#### Total BAS
all_corr_vars <- all_corr_vars %>% 
  mutate(., missing_totalbas = apply(dplyr::select(., c_bisbas7, c_bisbas14, c_bisbas19, 
                                            c_bisbas20, c_bisbas10, c_bisbas15, 
                                            c_bisbas17, c_bisbas18, c_bisbas2,
                                            c_bisbas3, c_bisbas9, c_bisbas11, c_bisbas12), 1, percentmissing))
table(all_corr_vars$missing_totalbas) # 124 participants missing 100% data
all_corr_vars <- all_corr_vars %>% 
  mutate(., total_bas_mean = case_when(missing_totalbas < 100 ~ 
                                         rowMeans(dplyr::select(., c_bisbas7, c_bisbas14, c_bisbas19, 
                                                         c_bisbas20, c_bisbas10, c_bisbas15, 
                                                         c_bisbas17, c_bisbas18, c_bisbas2,
                                                         c_bisbas3, c_bisbas9, c_bisbas11, c_bisbas12), na.rm = T)))
#### BAS Drive
all_corr_vars <- all_corr_vars %>% 
  mutate(., missing_bas_drive = apply(dplyr::select(., c_bisbas7, c_bisbas14, c_bisbas19, 
                                             c_bisbas20), 1, percentmissing))
table(all_corr_vars$missing_bas_drive) # 124 participants missing 100% data
all_corr_vars <- all_corr_vars %>% 
  mutate(., bas_drive_mean = case_when(missing_bas_drive < 100 ~ 
                                         rowMeans(dplyr::select(., c_bisbas7, c_bisbas14, c_bisbas19, 
                                                         c_bisbas20), na.rm = T)))
#### BAS Fun Seeking
all_corr_vars <- all_corr_vars %>% 
  mutate(., missing_bas_funseek = apply(dplyr::select(., c_bisbas10, c_bisbas15, c_bisbas17, 
                                               c_bisbas18), 1, percentmissing))
table(all_corr_vars$missing_bas_funseek) # 124 participants missing 100%+ data
all_corr_vars <- all_corr_vars %>% 
  mutate(., bas_funseek_mean = case_when(missing_bas_funseek < 100 ~ 
                                           rowMeans(dplyr::select(., c_bisbas10, c_bisbas15, c_bisbas17, 
                                                           c_bisbas18), na.rm = T)))
#### BAS Reward Responsiveness
all_corr_vars <- all_corr_vars %>% 
  mutate(., missing_bas_reward = apply(dplyr::select(., c_bisbas2, c_bisbas3, c_bisbas9, 
                                              c_bisbas11, c_bisbas12), 1, percentmissing))
table(all_corr_vars$missing_bas_reward) # 124 participants missing 100%+ data
all_corr_vars <- all_corr_vars %>% 
  mutate(., bas_reward_mean = case_when(missing_bas_reward < 100 ~ 
                                          rowMeans(dplyr::select(., c_bisbas2, c_bisbas3, c_bisbas9, 
                                                          c_bisbas11, c_bisbas12), na.rm = T)))
### PANAS - child
#### Negative Affect
all_corr_vars <- all_corr_vars %>% 
  mutate(., missing_panas_na = apply(dplyr::select(., panas2, panas4, panas6, panas7,
                                            panas8, panas11, panas13, panas15, 
                                            panas18, panas20), 1, percentmissing))
table(all_corr_vars$missing_panas_na) # 122 participants missing 100%+ data
all_corr_vars <- all_corr_vars %>% 
  mutate(., panas_na_mean = case_when(missing_panas_na < 100 ~ 
                                        rowMeans(dplyr::select(., panas2, panas4, panas6, panas7,
                                                        panas8, panas11, panas13, panas15, 
                                                        panas18, panas20), na.rm = T)))
#### Positive Affect
all_corr_vars <- all_corr_vars %>% 
  mutate(., missing_panas_pa = apply(dplyr::select(., panas1, panas3, panas5, panas9,
                                            panas10, panas12, panas14, panas16, 
                                            panas17, panas19), 1, percentmissing))
table(all_corr_vars$missing_panas_pa) # 122 participants missing 100%+ data
all_corr_vars <- all_corr_vars %>% 
  mutate(., panas_pa_mean = case_when(missing_panas_pa < 100 ~ 
                                        rowMeans(dplyr::select(., panas1, panas3, panas5, panas9,
                                                        panas10, panas12, panas14, panas16, 
                                                        panas17, panas19), na.rm = T)))

# delete unnecessary pre-existing subscale columns & missing columns
all_corr_vars_means <- all_corr_vars %>% 
  dplyr::select(., -erc_subscale_1, -erc_emotreg, -c_totalbas, -c_totalbis, -c_totalbasdrive,
         -c_totalbasfunseek, -c_totalbasreward, -panasna, -panaspa, -contains("missing"))

##### FIX EDITED FINAL AND COMBINE DATAFRAMES #####
final_nocorrvars <- dplyr::select(edited_final, -contains("erc"),
                                  -contains("bis"), -contains("bas"), -contains("panas"),
                                  -bditotalscore)

edited_final_2 <- left_join(final_nocorrvars, all_corr_vars_means, by = "subid")

# generate BDI means for each participant
edited_final_2 <- edited_final_2 %>% 
  mutate(., missing_bdi = apply(dplyr::select(., contains("bdi")), 1, percentmissing))
table(edited_final_2$missing_bdi) # 3 participants missing 100%+ data
edited_final_2 <- edited_final_2 %>% 
  mutate(., bdi_mean = case_when(missing_bdi < 100 ~ 
                                   rowMeans(dplyr::select(., contains("bdi")), na.rm = T))) %>% 
  dplyr::select(., -missing_bdi)

# delete dates and re-order columns in final dataset
edited_final_2 <- edited_final_2 %>% 
  dplyr::select(., -contains("date")) %>% 
  dplyr::select(., subid, eligible_final, child_age, child_sex, child_race, child_ethnicity,
                reporter, parent_education, fam_income, ch_pfc_score, contains("pfc"), 
                contains("erc"), contains("bisbas"), total_bis_mean, contains("bas_"),
                contains("panas"), contains("panas_"), contains("bdi"), bdi_mean)

# save dataset
write.csv(edited_final_2, "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data/edited_final_dataset.csv",
          row.names = F)
