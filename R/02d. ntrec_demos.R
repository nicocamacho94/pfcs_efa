# title: "Gather demographics data -- for NTREC sub-sample"
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

# make separate df's for NTREC (WashU + Duke together)
ntrec_final <- filter(final_dataset, str_ends(subid, "washu") | str_ends(subid, "duke"))

# review missingness of demographics data
png("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/ntrec/demos_missing_data.png",
    width = 900, height = 600)
summary(aggr(dplyr::select(ntrec_final, child_age, child_sex, child_ethnicity, child_race,
                           ch_pfc_score,reporter, parent_education, fam_income,), numbers = T, prop = c(T, F),
             labels = c("ch_age", "ch_sex", "ch_ethnic", "ch_race",
                        "pfc_ch","reporter", "p_edu", "fam_inc")))
dev.off()

# create a cutoff variable for PFC checklist scores
ntrec_final <- ntrec_final %>% 
  mutate(pfc_ch_cutoff = if_else(ch_pfc_score < 3, "Less than 3", 
                                 if_else(ch_pfc_score >= 3, "3+", "NA")))

# make data long to make distribution plots
ntrec_long <- gather(ntrec_final, variable, value, -subid)

# Sex
ntrec_long %>% 
  filter(variable == "child_sex") %>% 
  ggplot(., aes(x = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), vjust = -0.2, show.legend = F) +
  ggtitle("Child Bio Sex")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/ntrec/child_bio_sex.png")

# Age
ntrec_final %>% 
  ggplot(., aes(child_age)) +
  geom_density(fill = "magenta", alpha = 0.4, show.legend = F) +
  ggtitle("Child Age (in years)")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/ntrec/child_age.png")

# Ethnicity
ntrec_long %>% 
  filter(variable == "child_ethnicity") %>% 
  ggplot(., aes(x = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), vjust = -0.2, show.legend = F) +
  ggtitle("Child Ethnicity")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/ntrec/child_ethnicity.png")

# Race
ntrec_long %>% 
  filter(variable == "child_race") %>% 
  ggplot(., aes(y = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), hjust = -0.2, show.legend = F) +
  ggtitle("Child Race")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/ntrec/child_race.png")

# PFC Checklist
## Distribution
ntrec_final %>% 
  ggplot(., aes(ch_pfc_score)) +
  geom_density(fill = "purple", alpha = 0.4, show.legend = F) +
  ggtitle("Child PFC score")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/ntrec/child_pfc_ch.png")
## Cutoff of 3
ntrec_long %>% 
  filter(variable == "pfc_ch_cutoff") %>% 
  ggplot(., aes(x = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), vjust = -0.2, show.legend = F) +
  ggtitle("Child PFC Checklist Cutoff")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/ntrec/child_pfc_ch_cutoff.png")

# Reporter
ntrec_long %>% 
  filter(variable == "reporter") %>% 
  ggplot(., aes(x = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), vjust = -0.2, show.legend = F) +
  ggtitle("Reporter")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/ntrec/parent_reporter.png")

# Parent edu
ntrec_long %>% 
  filter(variable == "parent_education") %>% 
  ggplot(., aes(y = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), hjust = -0.1, show.legend = F, size = 4) +
  ggtitle("Parent Education")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/ntrec/parent_edu.png")

# Fam income
ntrec_long %>% 
  filter(variable == "fam_income") %>% 
  ggplot(., aes(y = value, colour = value, fill = value)) +
  geom_bar(alpha = 0.7, show.legend = F) +
  geom_text(stat ='count', aes(label = ..count..), hjust = -0.3, show.legend = F, size = 3.5) +
  ggtitle("Family Income (per year)")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/ntrec/fam_income.png")

# generate stats for continuous variables for entire sample
ntrec_stats <- ntrec_final %>% 
  summarize(., 
            min_age = min(child_age),
            max_age = max(child_age),
            mean_age = mean(child_age),
            sd_age = sd(child_age),
            min_pfc_ch = min(na.omit(ch_pfc_score)),
            max_pfc_ch = max(na.omit(ch_pfc_score)),
            mean_pfc_ch = mean(na.omit(ch_pfc_score)),
            sd_pfc_ch = sd(na.omit(ch_pfc_score)),
            perc_pfc_less3 = sum(as.numeric(ntrec_final$pfc_ch_cutoff == "Less than 3"))/length(ntrec_final$pfc_ch_cutoff),
            perc_pfc_3more = sum(as.numeric(ntrec_final$pfc_ch_cutoff == "3+"))/length(ntrec_final$pfc_ch_cutoff),
            perc_male = sum(as.numeric(ntrec_final$child_sex == "Male"))/length(ntrec_final$child_sex),
            perc_female = sum(as.numeric(ntrec_final$child_sex == "Female"))/length(ntrec_final$child_sex),
            perc_hispanic = sum(as.numeric(ntrec_final$child_ethnicity == "Hispanic/Latino"))/length(ntrec_final$child_ethnicity),
            perc_nonHisp = sum(as.numeric(ntrec_final$child_ethnicity == "Not Hispanic/Latino"))/length(ntrec_final$child_ethnicity),
            perc_otherRace = sum(as.numeric(ntrec_final$child_race == "Other (unspec)"))/length(ntrec_final$child_race),
            perc_mixedRace = sum(as.numeric(ntrec_final$child_race == "Mixed (unspec)"))/length(ntrec_final$child_race),
            perc_caucasian = sum(as.numeric(ntrec_final$child_race == "Caucasian"))/length(ntrec_final$child_race),
            perc_asian = sum(as.numeric(ntrec_final$child_race == "Asian"))/length(ntrec_final$child_race),
            perc_aian = sum(as.numeric(ntrec_final$child_race == "AmerIndAlaskNative"))/length(ntrec_final$child_race),
            perc_aa = sum(as.numeric(ntrec_final$child_race == "AfricanAmerican"))/length(ntrec_final$child_race),
            perc_dad = sum(as.numeric(ntrec_final$reporter == "BioDad"))/length(ntrec_final$reporter),
            perc_mom = sum(as.numeric(ntrec_final$reporter == "BioMom"))/length(ntrec_final$reporter),
            perc_gma = sum(as.numeric(ntrec_final$reporter == "Grandmother"))/length(ntrec_final$reporter),
            perc_otherRep = sum(as.numeric(ntrec_final$reporter == "Other"))/length(ntrec_final$reporter),
            perc_gradeSchool = sum(as.numeric(ntrec_final$parent_education == "Completed grade school"))/length(ntrec_final$parent_education),
            perc_someHighSchool = sum(as.numeric(ntrec_final$parent_education == "Some high school"))/length(ntrec_final$parent_education),
            perc_hsDiploma = sum(as.numeric(ntrec_final$parent_education == "High school diploma"))/length(ntrec_final$parent_education),
            perc_someCollege = sum(as.numeric(ntrec_final$parent_education == "Some college or a 2-year degree"))/length(ntrec_final$parent_education),
            perc_college = sum(as.numeric(ntrec_final$parent_education == "4-year college degree"))/length(ntrec_final$parent_education),
            perc_proGrad = sum(as.numeric(ntrec_final$parent_education == "Professional or graduate degree"))/length(ntrec_final$parent_education),
            perc_naEdu = sum(as.numeric(ntrec_final$parent_education == "NA - BDS + 2 NTREC"))/length(ntrec_final$parent_education),
            perc_dkIncome = sum(as.numeric(ntrec_final$fam_income == "Refused or Don't know"))/length(ntrec_final$fam_income),
            perc_naBDS = sum(as.numeric(ntrec_final$fam_income == "NA (BDS only)"))/length(ntrec_final$fam_income),
            perc_less30kDPAP = sum(as.numeric(ntrec_final$fam_income == "<$30,000 (DPAP only)"))/length(ntrec_final$fam_income),
            perc_30_60DPAP = sum(as.numeric(ntrec_final$fam_income == "$30,000-$60,000 (DPAP only)"))/length(ntrec_final$fam_income),
            perc_60kDPAP = sum(as.numeric(ntrec_final$fam_income == "$60,000+ (DPAP only)"))/length(ntrec_final$fam_income),
            perc_0_20income = sum(as.numeric(ntrec_final$fam_income == "$0-$20,000"))/length(ntrec_final$fam_income),
            perc_20_40income = sum(as.numeric(ntrec_final$fam_income == "$20,001-$40,000"))/length(ntrec_final$fam_income),
            perc_40_60income = sum(as.numeric(ntrec_final$fam_income == "$40,001-$60,000"))/length(ntrec_final$fam_income),
            perc_60_80income = sum(as.numeric(ntrec_final$fam_income == "$60,001-$80,000"))/length(ntrec_final$fam_income),
            perc_80_100income = sum(as.numeric(ntrec_final$fam_income == "$80,001-$100,000"))/length(ntrec_final$fam_income),
            perc_100income = sum(as.numeric(ntrec_final$fam_income == "$100,001+"))/length(ntrec_final$fam_income))

# save stats of continuous data
write.csv(ntrec_stats,
          "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/demos_per_study/ntrec/ntrec_stats.csv",
          row.names = F)

