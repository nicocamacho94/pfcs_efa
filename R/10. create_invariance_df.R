# title: "PFC EFA -- create dataframes for invariance assessments"
# author: "Nicolas L Camacho"
# created: 7/20/2023
# updated: 7/21/2023

# Set up packages
library(tidyverse)
library(multiplex)

# set working directory (where cleaned data exists); combined_data folder
# setwd("X:/Gaffrey/Lab/NTREC/NicolasCamacho/pfc_fa/paper/updated_process/data")
setwd("C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/data")

# Pull in the data
final_dataset <- read_csv("edited_final_dataset.csv")

# keep only the subid, pfc scale scores, child age and sex
pfc_final_mi <- dplyr::select(final_dataset, subid, contains("pfc"), child_age,
                           child_sex) %>% dplyr::select(., !contains("score"))

# create coding variables to specify age and sex groups
pfc_final_mi <- pfc_final_mi %>% 
  mutate(age_group = case_when(child_age < 5.99 ~ 1,
                               child_age > 5.99 ~ 2),
         gender_group = case_when(child_sex == "Female" ~ 1,
                                  child_sex == "Male" ~ 2)) %>% 
  dplyr::select(., subid, age_group, gender_group, contains("pfc"))

# check to see where items have mis-matching category coverage
## age grouping
pfc_final_mi %>% 
  pivot_longer(., -c(subid, age_group), names_to = "items", values_to = "scores") %>% 
  mutate(age_group = factor(age_group)) %>% 
  ggplot(data = ., aes(x = scores, fill = age_group)) +
  geom_bar(position = position_dodge()) +
  facet_wrap(~items)

## gender grouping
pfc_final_mi %>% 
  pivot_longer(., -c(subid, gender_group), names_to = "items", values_to = "scores") %>% 
  mutate(gender_group = factor(gender_group)) %>% 
  ggplot(data = ., aes(x = scores, fill = gender_group)) +
  geom_bar(position = position_dodge()) +
  facet_wrap(~items)

# create two files, one for each grouping variable, with matched category coverage
## age grouping
pfc_mi_age <- pfc_final_mi %>% 
  mutate(pfc08 = if_else(age_group == 1 & pfc08 == 4, 3, pfc08),
         pfc09 = if_else(age_group == 2 & pfc09 == 4, 2, pfc09),
         pfc11 = if_else(age_group == 1 & pfc11 == 4, 3, pfc11),
         pfc17 = if_else(age_group == 1 & pfc17 == 3, 2, pfc17),
         pfc19 = if_else(age_group == 1 & pfc19 == 4, 3, pfc19),
         pfc20 = if_else(age_group == 1 & pfc20 == 4, 3, pfc20),
         pfc21 = if_else(age_group == 2 & pfc21 == 4, 3, pfc21),
         pfc22 = if_else(age_group == 1 & pfc22 == 4, 3, pfc22),
         pfc23 = if_else(age_group == 1 & pfc23 == 4, 3, pfc23))
### check updated category coverage
pfc_mi_age %>% 
  pivot_longer(., -c(subid, age_group), names_to = "items", values_to = "scores") %>% 
  mutate(age_group = factor(age_group)) %>% 
  ggplot(data = ., aes(x = scores, fill = age_group)) +
  geom_bar(position = position_dodge()) +
  facet_wrap(~items)

## gender grouping
pfc_mi_gender <- pfc_final_mi %>% 
  mutate(pfc09 = if_else(gender_group == 1 & pfc09 == 4, 2, pfc09),
         pfc12 = if_else(gender_group == 2 & pfc12 == 4, 3, pfc12),
         pfc17 = if_else(gender_group == 2 & pfc17 == 3, 2, pfc17),
         pfc19 = if_else(gender_group == 2 & pfc19 == 4, 3, pfc19),
         pfc20 = if_else(gender_group == 2 & pfc20 == 4, 3, pfc20))
### check updated category coverage
pfc_mi_gender %>% 
  pivot_longer(., -c(subid, gender_group), names_to = "items", values_to = "scores") %>% 
  mutate(gender_group = factor(gender_group)) %>% 
  ggplot(data = ., aes(x = scores, fill = gender_group)) +
  geom_bar(position = position_dodge()) +
  facet_wrap(~items)

# find exactly where there are NA's
cbind(lapply(lapply(pfc_mi_age, is.na), sum))
cbind(lapply(lapply(pfc_mi_gender, is.na), sum))

# replace NA's with 99 in order to be recognized by Mplus
pfc_mi_age <- pfc_mi_age %>% replace_na(list(
  pfc04 = 99, pfc06 = 99, pfc07 = 99, pfc08 = 99, pfc09 = 99,
  pfc10 = 99, pfc11 = 99, pfc12 = 99, pfc13 = 99, pfc14 = 99,
  pfc15 = 99, pfc16 = 99, pfc17 = 99, pfc18 = 99, pfc19 = 99,
  pfc20 = 99, pfc21 = 99, pfc22 = 99, pfc23 = 99))
pfc_mi_gender <- pfc_mi_gender %>% replace_na(list(
  pfc04 = 99, pfc06 = 99, pfc07 = 99, pfc08 = 99, pfc09 = 99,
  pfc10 = 99, pfc11 = 99, pfc12 = 99, pfc13 = 99, pfc14 = 99,
  pfc15 = 99, pfc16 = 99, pfc17 = 99, pfc18 = 99, pfc19 = 99,
  pfc20 = 99, pfc21 = 99, pfc22 = 99, pfc23 = 99))

# create .dat file to be imputed and analyzed in Mplus
# write.dat(pfc_mi_age,
#           "X:/Gaffrey/Lab/NTREC/NicolasCamacho/pfc_fa/paper/updated_process/data/pfc_final_mi")
write.dat(pfc_mi_age,
          "C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/data")
# write.dat(pfc_mi_gender,
#           "X:/Gaffrey/Lab/NTREC/NicolasCamacho/pfc_fa/paper/updated_process/data/pfc_final_mi")
write.dat(pfc_mi_gender,
          "C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/data")


