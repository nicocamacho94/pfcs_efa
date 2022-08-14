# title: "Check assumptions for EFA with the PFC scale"
# author: "Nicolas L Camacho"
# created: 1/14/2022
# updated: 8/11/2022

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
library(EFAtools)

# set working directory (where cleaned data exists); combined_data folder
# setwd("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/analysis_data")
setwd("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/analysis_data")

# Pull in the data
edited_final <- read_csv("edited_final_dataset.csv")

# keep only the pfc data
pfc_final <- dplyr::select(edited_final, subid, contains("pfc")) %>% 
  dplyr::select(., -contains("score"))

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

# Distributions of PFC-S items -- mosaic plot (ordinal data)
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
  geom_mosaic(aes(x = product(score_ord, vars), 
                  fill = score_ord), 
              offset = 0.015) +
  labs(x = "Items",
       y = "", 
       title = "Mosaic Plot of PFC Scale Items",
       fill = "Scores (ordinal)") +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.x = element_text(angle = 45,
                                   hjust = 1))
# ggsave("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/paper/visuals/pfc_item_mosaic.png",
#        last_plot())
ggsave("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/pfc_item_mosaic.png",
       last_plot())

## multivariate (none show multivariate normality)
### statistically
#### Mardia's Test
mardia_pfc_scale <- mvn(dplyr::select(pfc_final, -subid),
                        mvnTest = "mardia",
                        univariateTest = NULL)
mardia_pfc_scale$multivariateNormality

## Polychoric correlation plot -- must be conducted with NO NA's
poly_matrix_nona_pfc <- na.omit(dplyr::select(pfc_final, -subid))
poly_pfc <- polychoric(
  poly_matrix_nona_pfc,
  smooth = FALSE,
  ML = FALSE,
  correct = 0.1
)

ggcorrplot(poly_pfc$rho, type = "lower", method = "square",
           lab = TRUE, lab_size = 2, tl.cex = 5) +
  scale_fill_gradient2(low = "#41598F", high = "#C8102E", mid = "#FFFFFF", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab",
                       name = "Polychoric\nCorrelation") +
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
