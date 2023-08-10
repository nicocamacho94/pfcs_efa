# title: "Calculate correlations across 3-factors and other vars"
# author: "Nicolas L Camacho"
# created: 1/20/2022
# updated: 7/24/2023

# set up packages
library(tidyverse)
library(VIM)
library(Hmisc)
library(ggcorrplot)
library(apaTables)

# set working directory (where cleaned data exists); combined_data folder
# setwd("X:/Gaffrey/Lab/NTREC/NicolasCamacho/pfc_fa/paper/updated_process/data")
setwd("C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/data")

# pull in the data
corr_vars <- read_csv("corr_vars_with3Factors.csv")

# review missingness of vars for corr matrix
png("C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/visuals/corr_vars_missing_data.png",
    width = 900, height = 600)
summary(aggr(dplyr::select(corr_vars, -subid), 
             numbers = T, prop = c(T, F),
             labels = c("age", "erc_NL", "erc_ER", "bis", "bas", "basDrive", "basFun", "basRew",  
                          "panas_na", "panas_pa", "bdi", "pfc_f1", "pfc_f2", "pfc_f3")))
dev.off()

# make data long to make distribution plots
corr_long <- gather(corr_vars, variable, value, -subid) %>% 
  mutate(., value = as.numeric(value))

corr_long %>% 
  ggplot(., aes(x = value, colour = variable, fill = variable)) +
  geom_density(alpha = 0.7, show.legend = F) +
  facet_wrap(~variable, ncol = 3, scales = "free") +
  ggtitle("Variables for correlation matrix")
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/visuals/corr_vars_distrib.png")

# correlation matrix
corr_matrix <- rcorr(as.matrix(dplyr::select(corr_vars, -subid)))
ggcorrplot(corr_matrix$r, type = "lower", method = "square", 
           p.mat = corr_matrix$P, sig.level = 0.05, insig = "pch", pch = 4, pch.cex = 9,
           lab = TRUE, lab_size = 2, tl.cex = 8) +
  scale_fill_gradient2(low = "#41598F", high = "#C8102E", mid = "#FFFFFF", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab",
                       name = "Pearson\nCorrelation") +
  ggtitle("Pearson Correlation Matrix (p < .05)") +
  coord_fixed()
ggsave(last_plot(), 
       filename = "C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/visuals/corr_matrix_validity.png")

# prep corr matrix for APA corr table
# correlation matrix
corr_vars_only <- dplyr::select(corr_vars, -subid)
colnames(corr_vars_only) <- c("Age", "ERC NL", "ERC ER", "BIS", "BAS", "BAS Drive",
                        "BAS Fun", "BAS Reward", "PANAS NA", "PANAS PA",
                        "Parent BDI", "PFC-S F1", "PFC-S F2", "PFC-S F3")
apa.cor.table(corr_vars_only, show.sig.stars = T,
              filename = "C:/Users/forev/Documents/NicolasCamacho/pfc_fa/paper/updated_process/visuals/corr_plot_apa.doc")

