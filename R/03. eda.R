# title: "Explore variables of interest data"
# author: "Nicolas L Camacho"
# created: 1/21/2022
# updated: 8/11/2022

# set up packages
library(tidyverse)
library(VIM)
library(see)
library(ggmosaic)

# set working directory (where cleaned data exists); combined_data folder
# setwd("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/analysis_data")
setwd("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data")

# pull in the data
final_dataset <- read_csv("edited_final_dataset.csv")

# keep variables of interest + demos
voi_demos <- dplyr::select(final_dataset, subid, child_sex, child_age, child_race,
                          child_ethnicity, parent_education, fam_income, contains("pfc"), 
                          bditotalscore, panaspa, panasna, erc_subscale_1,
                          erc_emotreg, c_totalbis, c_totalbas, c_totalbasdrive, 
                          c_totalbasfunseek, c_totalbasreward) %>% 
  mutate(s_pfc_score = pfc01 + pfc02 + pfc03 + pfc04 + pfc05 + pfc06 + pfc07 +
           pfc08 + pfc09 + pfc10 + pfc11 + pfc12 + pfc13 + pfc14 + pfc15 + pfc16 +
           pfc17 + pfc18 + pfc19 + pfc20 + pfc21 + pfc22 + pfc23) %>% 
  dplyr::select(-contains("pfc"), s_pfc_score, ch_pfc_score)

# investigate differences in scale and checklist scores from PFC
voi_demos_long <- gather(voi_demos, variable, value, -subid) 

## PFC risk
voi_demos %>% 
  mutate(pfc_risk = if_else(ch_pfc_score > 2, "high-risk",
                            if_else(ch_pfc_score < 3, "low-risk", "NA"))) %>%
  ggplot(., aes(x = pfc_risk, y = s_pfc_score, fill = pfc_risk)) +
  geom_boxplot(show.legend = F) +
  geom_jitter(shape = 16, alpha = 0.15, width = 0.1, height = 0, show.legend = F)

## age
voi_demos %>% 
  ggplot(., aes(x = child_age, y = s_pfc_score)) +
  geom_point()

## sex
voi_demos %>% 
  ggplot(., aes(x = child_sex, y = s_pfc_score, fill = child_sex)) +
  geom_boxplot() +
  geom_jitter(shape = 16, alpha = 0.15, width = 0, height = 0.3)

## ethnicity
voi_demos %>% 
  ggplot(., aes(x = child_ethnicity, y = s_pfc_score, fill = child_ethnicity)) +
  geom_boxplot() +
  geom_jitter(shape = 16, alpha = 0.15, width = 0, height = 0.3)

## race
voi_demos %>% 
  ggplot(., aes(y = child_race, x = s_pfc_score, fill = child_race)) +
  geom_boxplot() +
  geom_jitter(shape = 16, alpha = 0.15, width = 0, height = 0.3)

## parent edu
voi_demos %>% 
  ggplot(., aes(y = parent_education, x = s_pfc_score, fill = parent_education)) +
  geom_boxplot() +
  geom_jitter(shape = 16, alpha = 0.15, width = 0, height = 0.3)

## age x risk
voi_demos %>% 
  mutate(pfc_risk = if_else(ch_pfc_score > 2, "high-risk",
                            if_else(ch_pfc_score < 3, "low-risk", "NA"))) %>% 
  ggplot(., aes(x = child_age, y = s_pfc_score, colour = pfc_risk)) +
  geom_point()

## age x ethnicity
voi_demos %>% 
  ggplot(., aes(x = child_age, y = s_pfc_score)) +
  geom_point() +
  facet_wrap(~child_ethnicity)

## age x race
voi_demos %>% 
  ggplot(., aes(x = child_age, y = s_pfc_score)) +
  geom_point() +
  facet_wrap(~child_race)

## age x parent edu
voi_demos %>% 
  ggplot(., aes(x = child_age, y = s_pfc_score)) +
  geom_point()+
  facet_wrap(~parent_education)

## sex x ethnicity
voi_demos %>% 
  ggplot(., aes(x = child_sex, y = s_pfc_score, fill = child_ethnicity)) +
  geom_boxplot() +
  geom_point(alpha = 0.2, shape = 16, position = position_jitterdodge(jitter.width = 0))

## sex x race
voi_demos %>% 
  ggplot(., aes(x = child_sex, y = s_pfc_score, fill = child_race)) +
  geom_boxplot() +
  geom_point(alpha = 0.2, shape = 16, position = position_jitterdodge(jitter.width = 0))

## sex x parent edu
voi_demos %>% 
  ggplot(., aes(x = child_sex, y = s_pfc_score, fill = parent_education)) +
  geom_boxplot() +
  geom_point(alpha = 0.2, shape = 16, position = position_jitterdodge(jitter.width = 0))

# explore age, sex, ethnicity, race, and parent edu differences within item-level PFC
item_pfc_eda <- final_dataset %>% 
  dplyr::select(., contains("pfc"), child_age, child_sex, child_ethnicity,
                child_race, parent_education, -ch_pfc_score) %>% 
  gather(., key = "pfc_items", value = "value", contains("pfc")) 

## age
item_pfc_eda %>% 
  ggplot(., aes(x = as.factor(value), y = child_age, fill = as.factor(value))) +
  geom_boxplot(show.legend = F) +
  facet_wrap(~pfc_items)

## sex
item_pfc_eda %>% 
  ggplot(., aes(x = child_sex, fill = as.factor(value)))+
  geom_bar(show.legend = T, position = "fill") +
  facet_wrap(~pfc_items)

## ethnicity
item_pfc_eda %>% 
  ggplot(., aes(y = child_ethnicity, fill = as.factor(value)))+
  geom_bar(show.legend = T, position = "fill") +
  facet_wrap(~pfc_items)

## race
item_pfc_eda %>% 
  ggplot(., aes(y = child_race, fill = as.factor(value)))+
  geom_bar(show.legend = T, position = "fill") +
  facet_wrap(~pfc_items)

## parent_edu
item_pfc_eda %>% 
  ggplot(., aes(y = parent_education, fill = as.factor(value)))+
  geom_bar(show.legend = T, position = "fill") +
  facet_wrap(~pfc_items)

