library(tidyverse)
library(here)
library(ggplot2)
library(sf)

crab_data <- read_csv(here("data/crab_corr_data.csv"))

burrows_site_avg <- crab_data %>%
  filter(variable == "burrow_density") %>%
  group_by(marsh) %>%
  summarize(mean(value))

burrows_hab_avg <- crab_data %>%
  filter(variable == "burrow_density") %>%
  group_by(habitat) %>%
  summarize(mean(value))

uca_site_avg <- crab_data %>%
  filter(variable == "uca_cpue") %>%
  group_by(marsh) %>%
  summarize(mean(value))

uca_habitat_avg <- crab_data %>%
  filter(variable == "uca_cpue") %>%
  group_by(habitat) %>%
  summarize(mean(value))

sesarma_site_avg <- crab_data %>%
  filter(variable == "sesarma_cpue") %>%
  group_by(marsh) %>%
  summarize(mean(value))

sesarma_habitat_avg <- crab_data %>%
  filter(variable == "sesarma_cpue") %>%
  group_by(habitat) %>%
  summarize(mean(value))

carcinus_site_avg <- crab_data %>%
  filter(variable == "carcinus_cpue") %>%
  group_by(marsh) %>%
  summarize(mean(value))

carcinus_habitat_avg <- crab_data %>%
  filter(variable == "carcinus_cpue") %>%
  group_by(habitat) %>%
  summarize(mean(value))

burrows_hab_avg
burrows_site_avg
uca_habitat_avg
uca_site_avg
sesarma_habitat_avg
sesarma_site_avg
carcinus_habitat_avg
carcinus_site_avg
