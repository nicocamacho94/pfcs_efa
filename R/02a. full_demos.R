# title: "Gather demographics data - for entire sample"
# author: "Nicolas L Camacho"
# created: 1/20/2022
# updated: 8/11/2022

# set up packages
library(tidyverse)
library(VIM)

# set working directory (where cleaned data exists); combined_data folder
# setwd("X:/Gaffrey/Lab/NTREC/NicolasCamacho/pfc_fa/paper/updated_process/data")
setwd("C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/data")

# pull in the data
final_dataset <- read_csv("edited_final_dataset.csv")

# review missingness of demographics data
png("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_missing_data.png",
    width = 900, height = 600)
summary(aggr(dplyr::select(final_dataset, child_age, child_sex, child_ethnicity, child_race,
                           ch_pfc_score, reporter, parent_education, fam_income), numbers = T, prop = c(T, F),
             labels = c("ch_age", "ch_sex", "ch_ethnic", "ch_race", "pfc_ch", 
                        "reporter", "p_edu", "fam_inc")))
dev.off()

# create a cutoff variable for PFC checklist scores
final_dataset <- final_dataset %>% 
  mutate(pfc_ch_cutoff = if_else(ch_pfc_score < 3, "Less than 3", 
                                 if_else(ch_pfc_score >= 3, "3+", "NA")))

# make data long to make distribution plots
final_long <- gather(final_dataset, variable, value, -subid)

# Sex
final_long %>% 
  filter(variable == "child_sex") %>% 
  ggplot(., aes(x = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), vjust = -0.2, show.legend = F) +
  ggtitle("Child Bio Sex")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/child_bio_sex.png")

# Age
final_dataset %>% 
ggplot(., aes(child_age)) +
  geom_density(fill = "magenta", alpha = 0.4, show.legend = F) +
  ggtitle("Child Age (in years)")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/child_age.png")

# Ethnicity
final_long %>% 
  filter(variable == "child_ethnicity") %>% 
  ggplot(., aes(x = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), vjust = -0.2, show.legend = F) +
  ggtitle("Child Ethnicity")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/child_ethnicity.png")

# Race
final_long %>% 
  filter(variable == "child_race") %>% 
  ggplot(., aes(y = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), hjust = -0.2, show.legend = F) +
  ggtitle("Child Race")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/child_race.png")

# PFC Checklist
## Distribution
final_dataset %>% 
  ggplot(., aes(ch_pfc_score)) +
  geom_density(fill = "purple", alpha = 0.4, show.legend = F) +
  ggtitle("Child PFC score")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/child_pfc_ch.png")
## Cutoff of 3
final_long %>% 
  filter(variable == "pfc_ch_cutoff") %>% 
  ggplot(., aes(x = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), vjust = -0.2, show.legend = F) +
  ggtitle("Child PFC Checklist Cutoff")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/child_pfc_ch_cutoff.png")

# Reporter
final_long %>% 
  filter(variable == "reporter") %>% 
  ggplot(., aes(x = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), vjust = -0.2, show.legend = F) +
  ggtitle("Reporter")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/parent_reporter.png")

# Parent edu
final_long %>% 
  filter(variable == "parent_education") %>% 
  ggplot(., aes(y = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), hjust = -0.1, show.legend = F, size = 4) +
  ggtitle("Parent Education")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/parent_edu.png")

# Fam income
final_long %>% 
  filter(variable == "fam_income") %>% 
  ggplot(., aes(y = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), hjust = -0.3, show.legend = F, size = 3.5) +
  ggtitle("Family Income (per year)")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/fam_income.png")

# generate stats for continuous variables for entire sample
full_sample_stats <- final_dataset %>% 
  summarize(., 
            min_age = min(child_age),
            max_age = max(child_age),
            mean_age = mean(child_age),
            sd_age = sd(child_age),
            min_pfc_ch = min(na.omit(ch_pfc_score)),
            max_pfc_ch = max(na.omit(ch_pfc_score)),
            mean_pfc_ch = mean(na.omit(ch_pfc_score)),
            sd_pfc_ch = sd(na.omit(ch_pfc_score)),
            perc_pfc_less3 = sum(as.numeric(final_dataset$pfc_ch_cutoff == "Less than 3"))/length(final_dataset$pfc_ch_cutoff),
            perc_pfc_3more = sum(as.numeric(final_dataset$pfc_ch_cutoff == "3+"))/length(final_dataset$pfc_ch_cutoff),
            perc_male = sum(as.numeric(final_dataset$child_sex == "Male"))/length(final_dataset$child_sex),
            perc_female = sum(as.numeric(final_dataset$child_sex == "Female"))/length(final_dataset$child_sex),
            perc_hispanic = sum(as.numeric(final_dataset$child_ethnicity == "Hispanic/Latino"))/length(final_dataset$child_ethnicity),
            perc_nonHisp = sum(as.numeric(final_dataset$child_ethnicity == "Not Hispanic/Latino"))/length(final_dataset$child_ethnicity),
            perc_otherRace = sum(as.numeric(final_dataset$child_race == "Other (unspec)"))/length(final_dataset$child_race),
            perc_mixedRace = sum(as.numeric(final_dataset$child_race == "Mixed (unspec)"))/length(final_dataset$child_race),
            perc_caucasian = sum(as.numeric(final_dataset$child_race == "Caucasian"))/length(final_dataset$child_race),
            perc_asian = sum(as.numeric(final_dataset$child_race == "Asian"))/length(final_dataset$child_race),
            perc_aian = sum(as.numeric(final_dataset$child_race == "AmerIndAlaskNative"))/length(final_dataset$child_race),
            perc_aa = sum(as.numeric(final_dataset$child_race == "AfricanAmerican"))/length(final_dataset$child_race),
            perc_dad = sum(as.numeric(final_dataset$reporter == "BioDad"))/length(final_dataset$reporter),
            perc_mom = sum(as.numeric(final_dataset$reporter == "BioMom"))/length(final_dataset$reporter),
            perc_gma = sum(as.numeric(final_dataset$reporter == "Grandmother"))/length(final_dataset$reporter),
            perc_otherRep = sum(as.numeric(final_dataset$reporter == "Other"))/length(final_dataset$reporter),
            perc_gradeSchool = sum(as.numeric(final_dataset$parent_education == "Completed grade school"))/length(final_dataset$parent_education),
            perc_someHighSchool = sum(as.numeric(final_dataset$parent_education == "Some high school"))/length(final_dataset$parent_education),
            perc_hsDiploma = sum(as.numeric(final_dataset$parent_education == "High school diploma"))/length(final_dataset$parent_education),
            perc_someCollege = sum(as.numeric(final_dataset$parent_education == "Some college or a 2-year degree"))/length(final_dataset$parent_education),
            perc_college = sum(as.numeric(final_dataset$parent_education == "4-year college degree"))/length(final_dataset$parent_education),
            perc_proGrad = sum(as.numeric(final_dataset$parent_education == "Professional or graduate degree"))/length(final_dataset$parent_education),
            perc_naEdu = sum(as.numeric(final_dataset$parent_education == "NA - BDS + 2 NTREC"))/length(final_dataset$parent_education),
            perc_dkIncome = sum(as.numeric(final_dataset$fam_income == "Refused or Don't know"))/length(final_dataset$fam_income),
            perc_naBDS = sum(as.numeric(final_dataset$fam_income == "NA (BDS only)"))/length(final_dataset$fam_income),
            perc_less30kDPAP = sum(as.numeric(final_dataset$fam_income == "<$30,000 (DPAP only)"))/length(final_dataset$fam_income),
            perc_30_60DPAP = sum(as.numeric(final_dataset$fam_income == "$30,000-$60,000 (DPAP only)"))/length(final_dataset$fam_income),
            perc_60kDPAP = sum(as.numeric(final_dataset$fam_income == "$60,000+ (DPAP only)"))/length(final_dataset$fam_income),
            perc_0_20income = sum(as.numeric(final_dataset$fam_income == "$0-$20,000"))/length(final_dataset$fam_income),
            perc_20_40income = sum(as.numeric(final_dataset$fam_income == "$20,001-$40,000"))/length(final_dataset$fam_income),
            perc_40_60income = sum(as.numeric(final_dataset$fam_income == "$40,001-$60,000"))/length(final_dataset$fam_income),
            perc_60_80income = sum(as.numeric(final_dataset$fam_income == "$60,001-$80,000"))/length(final_dataset$fam_income),
            perc_80_100income = sum(as.numeric(final_dataset$fam_income == "$80,001-$100,000"))/length(final_dataset$fam_income),
            perc_100income = sum(as.numeric(final_dataset$fam_income == "$100,001+"))/length(final_dataset$fam_income))

# save stats of continuous data
write.csv(full_sample_stats,
          "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/full_sample_stats.csv",
          row.names = F)

