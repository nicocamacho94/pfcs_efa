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

# Univariate and Multivariate Normality
## univariate
### visually -- distribution plots (continuous data)
pfc_scale_long %>% 
  group_by(vars) %>% 
  ggplot(., aes(x = scores, fill = vars))+
  geom_density(alpha = 0.2, show.legend = FALSE) + facet_wrap(vars ~ .) +
  scale_x_continuous(breaks = pretty_breaks(n = 5)) +
  ggtitle("Distribution Plots of PFC Scale Items")
# ggsave("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/visuals/pfc_item_distrib.png",
#        last_plot())
ggsave("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/pfc_item_distrib.png",
       last_plot())

### visually -- mosaic plot (ordinal data)
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

## Pearson's correlation plot
corr_pfc <- rcorr(as.matrix(dplyr::select(pfc_final, -subid)))
ggcorrplot(corr_pfc$r, type = "lower", method = "square", 
           p.mat = corr_pfc$P, sig.level = 0.05, insig = "blank", lab = TRUE,
           lab_size = 2, tl.cex = 5) +
  scale_fill_gradient2(low = "#41598F", high = "#C8102E", mid = "#FFFFFF", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab",
                       name = "Pearson\nCorrelation") +
  ggtitle("Pearson Correlation of all PFC Scale Items (p < .05)") +
  coord_fixed()
# ggsave("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/paper/visuals/corrplot_pfc_items.png", 
#        plot = last_plot())
ggsave("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/pearson_corrplot_pfc_items.png",
       last_plot())

ggcorrplot(corr_pfc$r, type = "lower", method = "square", 
           p.mat = -(corr_pfc$r), sig.level = -.3, insig = "blank", lab = TRUE,
           lab_size = 2, tl.cex = 5) +
  scale_fill_gradient2(low = "#41598F", high = "#C8102E", mid = "#FFFFFF", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab",
                       name = "Pearson\nCorrelation") +
  ggtitle("Pearson Correlation of all PFC Scale Items (coeff > 0.3)") +
  coord_fixed()
# ggsave("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/paper/visuals/corrplot_pfc_items.png", 
#        plot = last_plot())
ggsave("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/pearson0.3_corrplot_pfc_items.png",
       last_plot())

## Spearman's correlation plot
spear_pfc <- rcorr(as.matrix(dplyr::select(pfc_final,-subid)), type = "spearman")
ggcorrplot(spear_pfc$r, type = "lower", method = "square",
           p.mat = spear_pfc$P, sig.level = 0.05, insig = "blank", lab = TRUE,
           lab_size = 2, tl.cex = 5) +
  scale_fill_gradient2(low = "#41598F", high = "#C8102E", mid = "#FFFFFF", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab",
                       name = "Spearman's\nCorrelation") +
  ggtitle("Spearman's Correlation of all PFC Scale Items (p < .05)") +
  coord_fixed()
# ggsave("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/paper/visuals/spearcorr_pfc_items.png", 
#        plot = last_plot())
ggsave("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/spearcorr_pfc_items.png",
       last_plot())

ggcorrplot(spear_pfc$r, type = "lower", method = "square",
           p.mat = -(spear_pfc$r), sig.level = -0.3, insig = "blank", lab = TRUE,
           lab_size = 2, tl.cex = 5) +
  scale_fill_gradient2(low = "#41598F", high = "#C8102E", mid = "#FFFFFF", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab",
                       name = "Spearman's\nCorrelation") +
  ggtitle("Spearman's Correlation of all PFC Scale Items (coeff > 0.3)") +
  coord_fixed()
# ggsave("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/paper/visuals/spearcorr_pfc_items.png", 
#        plot = last_plot())
ggsave("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/spearcorr0.3_pfc_items.png",
       last_plot())

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
  ggtitle("Polychoric Correlation of all PFC Scale Items") +
  coord_fixed()
# ggsave("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/paper/visuals/polycorr_pfc_items.png", 
#        plot = last_plot())
ggsave("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/polycorr_pfc_items.png",
       last_plot())

ggcorrplot(poly_pfc$rho, type = "lower", method = "square",
           p.mat = -(poly_pfc$rho), sig.level = -0.3, insig = "blank", lab = TRUE,
           lab_size = 2, tl.cex = 5) +
  scale_fill_gradient2(low = "#41598F", high = "#C8102E", mid = "#FFFFFF", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab",
                       name = "Polychoric\nCorrelation") +
  ggtitle("Polychoric Correlation of all PFC Scale Items (coeff > 0.3)") +
  coord_fixed()
# ggsave("X:/Gaffrey/Lab/NTREC/Nicolas/pfc_fa/paper/visuals/polycorr_pfc_items.png", 
#        plot = last_plot())
ggsave("C:/Users/forev/Documents/Nicolas/pfc_fa/paper/visuals/polycorr0.3_pfc_items.png",
       last_plot())

# sampling adequacy
## given lack of multivariate normality, KMO used instead of Bartlett's test
### polychoric correlation
poly_kmo_pfc <- psych::KMO(poly_pfc$rho)
poly_kmo_pfc # overall = 0.86

## KMO again with different package
### polychoric correlation
poly_kmo_2_pfc <- EFAtools::KMO(poly_pfc$rho,
                           use = "na.or.complete") # similar outcome
poly_kmo_2_pfc # overall = 0.856; matches above

