# title: "Gather demographics data -- for BDS sub-sample"
# author: "Nicolas L Camacho"
# created: 3/8/2022
# updated: 8/11/2022

# set up packages
library(tidyverse)
library(VIM)

# set working directory (where cleaned data exists); combined_data folder
# setwd("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/analysis_data")
setwd("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data")

# pull in the data
final_dataset <- read_csv("edited_final_dataset.csv")

# make separate df's for BDS
bds_final <- filter(final_dataset, str_starts(subid, "bds"))

# review missingness of demographics data
png("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/bds/demos_missing_data.png",
    width = 900, height = 600)
summary(aggr(dplyr::select(bds_final, child_age, child_sex, child_ethnicity, child_race,
                           ch_pfc_score, reporter, parent_education, fam_income), numbers = T, prop = c(T, F),
             labels = c("ch_age", "ch_sex", "ch_ethnic", "ch_race", "pfc_ch", "reporter",
                        "p_edu", "fam_inc")))
dev.off()

# create a cutoff variable for PFC checklist scores
bds_final <- bds_final %>% 
  mutate(pfc_ch_cutoff = if_else(ch_pfc_score < 3, "Less than 3", 
                                 if_else(ch_pfc_score >= 3, "3+", "NA")))

# make data long to make distribution plots
bds_long <- gather(bds_final, variable, value, -subid)

# Sex
bds_long %>% 
  filter(variable == "child_sex") %>% 
  ggplot(., aes(x = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), vjust = -0.2, show.legend = F) +
  ggtitle("Child Bio Sex")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/bds/child_bio_sex.png")

# Age
bds_final %>% 
  ggplot(., aes(child_age)) +
  geom_density(fill = "magenta", alpha = 0.4, show.legend = F) +
  ggtitle("Child Age (in years)")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/bds/child_age.png")

# Ethnicity
bds_long %>% 
  filter(variable == "child_ethnicity") %>% 
  ggplot(., aes(x = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), vjust = -0.2, show.legend = F) +
  ggtitle("Child Ethnicity")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/bds/child_ethnicity.png")

# Race
bds_long %>% 
  filter(variable == "child_race") %>% 
  ggplot(., aes(y = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), hjust = -0.2, show.legend = F) +
  ggtitle("Child Race")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/bds/child_race.png")

# PFC Checklist
## Distribution
bds_final %>% 
  ggplot(., aes(ch_pfc_score)) +
  geom_density(fill = "purple", alpha = 0.4, show.legend = F) +
  ggtitle("Child PFC score")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/bds/child_pfc_ch.png")
## Cutoff of 3
bds_long %>% 
  filter(variable == "pfc_ch_cutoff") %>% 
  ggplot(., aes(x = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), vjust = -0.2, show.legend = F) +
  ggtitle("Child PFC Checklist Cutoff")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/bds/child_pfc_ch_cutoff.png")

# Reporter
bds_long %>% 
  filter(variable == "reporter") %>% 
  ggplot(., aes(x = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), vjust = -0.2, show.legend = F) +
  ggtitle("Reporter")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/bds/parent_reporter.png")

# Parent edu
bds_long %>% 
  filter(variable == "parent_education") %>% 
  ggplot(., aes(y = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), hjust = -0.1, show.legend = F, size = 4) +
  ggtitle("Parent Education")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/bds/parent_edu.png")

# Fam income
bds_long %>% 
  filter(variable == "fam_income") %>% 
  ggplot(., aes(y = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), hjust = -0.3, show.legend = F, size = 3.5) +
  ggtitle("Family Income (per year)")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/bds/fam_income.png")

# generate stats for continuous variables for entire sample
bds_stats <- bds_final %>% 
  summarize(., 
            min_age = min(child_age),
            max_age = max(child_age),
            mean_age = mean(child_age),
            sd_age = sd(child_age),
            min_pfc_ch = min(na.omit(ch_pfc_score)),
            max_pfc_ch = max(na.omit(ch_pfc_score)),
            mean_pfc_ch = mean(na.omit(ch_pfc_score)),
            sd_pfc_ch = sd(na.omit(ch_pfc_score)),
            perc_pfc_less3 = sum(as.numeric(bds_final$pfc_ch_cutoff == "Less than 3"))/length(bds_final$pfc_ch_cutoff),
            perc_pfc_3more = sum(as.numeric(bds_final$pfc_ch_cutoff == "3+"))/length(bds_final$pfc_ch_cutoff),
            perc_male = sum(as.numeric(bds_final$child_sex == "Male"))/length(bds_final$child_sex),
            perc_female = sum(as.numeric(bds_final$child_sex == "Female"))/length(bds_final$child_sex),
            perc_hispanic = sum(as.numeric(bds_final$child_ethnicity == "Hispanic/Latino"))/length(bds_final$child_ethnicity),
            perc_nonHisp = sum(as.numeric(bds_final$child_ethnicity == "Not Hispanic/Latino"))/length(bds_final$child_ethnicity),
            perc_otherRace = sum(as.numeric(bds_final$child_race == "Other (unspec)"))/length(bds_final$child_race),
            perc_mixedRace = sum(as.numeric(bds_final$child_race == "Mixed (unspec)"))/length(bds_final$child_race),
            perc_caucasian = sum(as.numeric(bds_final$child_race == "Caucasian"))/length(bds_final$child_race),
            perc_asian = sum(as.numeric(bds_final$child_race == "Asian"))/length(bds_final$child_race),
            perc_aian = sum(as.numeric(bds_final$child_race == "AmerIndAlaskNative"))/length(bds_final$child_race),
            perc_aa = sum(as.numeric(bds_final$child_race == "AfricanAmerican"))/length(bds_final$child_race),
            perc_dad = sum(as.numeric(bds_final$reporter == "BioDad"))/length(bds_final$reporter),
            perc_mom = sum(as.numeric(bds_final$reporter == "BioMom"))/length(bds_final$reporter),
            perc_gma = sum(as.numeric(bds_final$reporter == "Grandmother"))/length(bds_final$reporter),
            perc_otherRep = sum(as.numeric(bds_final$reporter == "Other"))/length(bds_final$reporter),
            perc_gradeSchool = sum(as.numeric(bds_final$parent_education == "Completed grade school"))/length(bds_final$parent_education),
            perc_someHighSchool = sum(as.numeric(bds_final$parent_education == "Some high school"))/length(bds_final$parent_education),
            perc_hsDiploma = sum(as.numeric(bds_final$parent_education == "High school diploma"))/length(bds_final$parent_education),
            perc_someCollege = sum(as.numeric(bds_final$parent_education == "Some college or a 2-year degree"))/length(bds_final$parent_education),
            perc_college = sum(as.numeric(bds_final$parent_education == "4-year college degree"))/length(bds_final$parent_education),
            perc_proGrad = sum(as.numeric(bds_final$parent_education == "Professional or graduate degree"))/length(bds_final$parent_education),
            perc_naEdu = sum(as.numeric(bds_final$parent_education == "NA - BDS + 2 NTREC"))/length(bds_final$parent_education),
            perc_dkIncome = sum(as.numeric(bds_final$fam_income == "Refused or Don't know"))/length(bds_final$fam_income),
            perc_naBDS = sum(as.numeric(bds_final$fam_income == "NA (BDS only)"))/length(bds_final$fam_income),
            perc_less30kDPAP = sum(as.numeric(bds_final$fam_income == "<$30,000 (DPAP only)"))/length(bds_final$fam_income),
            perc_30_60DPAP = sum(as.numeric(bds_final$fam_income == "$30,000-$60,000 (DPAP only)"))/length(bds_final$fam_income),
            perc_60kDPAP = sum(as.numeric(bds_final$fam_income == "$60,000+ (DPAP only)"))/length(bds_final$fam_income),
            perc_0_20income = sum(as.numeric(bds_final$fam_income == "$0-$20,000"))/length(bds_final$fam_income),
            perc_20_40income = sum(as.numeric(bds_final$fam_income == "$20,001-$40,000"))/length(bds_final$fam_income),
            perc_40_60income = sum(as.numeric(bds_final$fam_income == "$40,001-$60,000"))/length(bds_final$fam_income),
            perc_60_80income = sum(as.numeric(bds_final$fam_income == "$60,001-$80,000"))/length(bds_final$fam_income),
            perc_80_100income = sum(as.numeric(bds_final$fam_income == "$80,001-$100,000"))/length(bds_final$fam_income),
            perc_100income = sum(as.numeric(bds_final$fam_income == "$100,001+"))/length(bds_final$fam_income))

# save stats of continuous data
write.csv(bds_stats,
          "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/bds/bds_stats.csv",
          row.names = F)
