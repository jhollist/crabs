library(tidyverse)
library(here)
library(ggplot2)
library(psych)

crab_corr_data <- read_csv(here("data/crab_corr_data.csv"))

bcb_corr <- crab_corr_data %>%
  spread(variable, value) %>%
  filter(habitat == "bcb") %>%
  select(-habitat,-site_id) %>%
  corr.test(use="pairwise")

bcb_corr_r <- data.frame(bcb_corr$r) %>%
  mutate(variables = row.names(.)) %>%
  select(variables,burrow_density,carcinus_cpue,sesarma_cpue,uca_cpue)
bcb_corr_n <- data.frame(bcb_corr$n) %>%
  mutate(variables = row.names(.)) %>%
  select(variables,burrow_density,carcinus_cpue,sesarma_cpue,uca_cpue)
bcb_corr_p <- data.frame(bcb_corr$p) %>%
  mutate(variables = row.names(.)) %>%
  select(variables,burrow_density,carcinus_cpue,sesarma_cpue,uca_cpue)
  
  
  data.frame(.$r) %>%
  mutate(variables = row.names(.)) %>%
  select(variables,burrow_density,carcinus_cpue,sesarma_cpue,uca_cpue)
bcb_corr

  


