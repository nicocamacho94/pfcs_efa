# title: "Check assumptions for EFA with the PFC scale"
# author: "Nicolas L Camacho"
# created: 1/14/2022
# updated: 7/18/2023

# Set up packages
library(tidyverse)
library(VIM)
library(psych)
library(ggplot2)
library(scales)
library(ggmosaic)
library(MVN)
library(Hmisc)
library(ggcorrplot)

# set working directory (where cleaned data exists); combined_data folder
# setwd("X:/Gaffrey/Lab/NTREC/NicolasCamacho/pfc_fa/paper/updated_process/data")
setwd("C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/data")

# Pull in the data
edited_final <- read_csv("edited_final_dataset.csv")

# keep only the pfc data
pfc_final <- dplyr::select(edited_final, subid, contains("pfc")) %>% 
  dplyr::select(., -contains("score"))

# make into long format
pfc_scale_long <- gather(pfc_final, vars, scores, -subid) 

# explore missing data
# study proportion of missing data by # of participants & % per item
# png("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/visuals/missing_data.png",
#     width = 900, height = 600)
png("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/pfc_missing_data.png",
    width = 900, height = 600)
summary(aggr(dplyr::select(pfc_final, -subid), numbers = T, prop = c(T, F)))
dev.off()

##### CHECK ASSUMPTIONS OF EFA OF PFC SCALE #####

# Basic descriptives
pfc_table <- psych::describe(dplyr::select(pfc_final, -subid)) 
  # no incorrect values
  # skewness ranges from 0.36 - 3.21
  # kurtosis ranges from -0.06 - 14.96
write.csv(pfc_table,
          "C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/pfc_item_descript.csv",
          row.names = F)

# Distributions of items on the PFC-S -- mosaic plot (ordinal data)
pfc_scale_long <- pfc_scale_long %>% 
  mutate(
    score_ord = ifelse(scores == 0, "0 - Never",
                       ifelse(scores == 1, "1 - Rarely",
                              ifelse(scores == 2, "2 - Sometimes",
                                     ifelse(scores == 3, "3 - Often",
                                            ifelse(scores == 4, "4 - Most of the time", NA))))))

pfc_scale_long %>%
  group_by(vars) %>% 
  ggplot(.) +
  geom_mosaic(aes(x = product(score_ord, vars), fill = score_ord), offset = 0.015) +
  labs(x = "Items", y = "",  title = "Mosaic Plot of PFC Scale Items", fill = "Scores (ordinal)") +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1))
# ggsave("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/paper/visuals/pfc_item_mosaic.png",
#        last_plot())
ggsave("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/pfc_item_mosaic.png",
       last_plot())

# Create a table specifying the endorsement percentage of each response option
pfc_s_perc_table <- pfc_scale_long %>% 
  group_by(vars) %>% 
  summarise(never_perc = sum(str_count(score_ord, "0 - Never"), na.rm = T)/length(score_ord),
            rarely_perc = sum(str_count(score_ord, "1 - Rarely"), na.rm = T)/length(score_ord),
            sometimes_perc = sum(str_count(score_ord, "2 - Sometimes"), na.rm = T)/length(score_ord),
            often_perc = sum(str_count(score_ord, "3 - Often"), na.rm = T)/length(score_ord),
            most_perc = sum(str_count(score_ord, "4 - Most of the time"), na.rm = T)/length(score_ord),
            na_perc = sum(is.na(score_ord))/length(score_ord))

# Mardia's Test of Multivariate Normality
mardia_pfc_scale <- mvn(dplyr::select(pfc_final, -subid), mvnTest = "mardia",
                        univariateTest = NULL)
mardia_pfc_scale$multivariateNormality

# Polychoric correlation plot -- must be conducted with NO NA's
poly_matrix_nona_pfc <- na.omit(dplyr::select(pfc_final, -subid))
poly_pfc <- polychoric(poly_matrix_nona_pfc, smooth = FALSE, ML = FALSE, correct = 0.1)

ggcorrplot(poly_pfc$rho, type = "lower", method = "square",
           lab = TRUE, lab_size = 2, tl.cex = 5) +
  scale_fill_gradient2(low = "#41598F", high = "#C8102E", mid = "#FFFFFF", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab",
                       name = "Polychoric\nCorrelation") +
  ggtitle("Polychoric Correlation of all PFC Scale Items") +
  coord_fixed()
# ggsave("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/paper/visuals/polycorr_pfc_items.png", 
#        plot = last_plot())
ggsave("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/polycorr_pfc_items.png",
       last_plot())

# sampling adequacy
## given lack of multivariate normality, KMO used instead of Bartlett's test
### polychoric correlation
poly_kmo_pfc <- psych::KMO(poly_pfc$rho)
poly_kmo_pfc # overall = 0.86
