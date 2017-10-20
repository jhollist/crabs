library(tidyverse)
library(here)
library(ggplot2)

crab_corr_data <- read_csv(here("data/crab_corr_data.csv"))

bcb_corr <- crab_corr_data %>%
  spread(variable, value) %>%
  filter(habitat == "bcb") %>%
  select(-habitat,-site_id) %>%
  cor(use="pairwise.complete.obs") %>%
  data.frame %>%
  mutate(variables = row.names(.)) %>%
  select(variables,burrow_density,carcinus_cpue,sesarma_cpue,uca_cpue)
bcb_corr

  


