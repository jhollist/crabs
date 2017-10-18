# Packages
library(sf)
#library(quickmapr)
library(mapview)
library(here)
library(tidyverse)

# Read in marsh hab
crab_marsh_hab <- st_read(here("data/crab_marsh_hab.shp")) %>%
  mutate(tot_area = st_area(.)) %>% 
  arrange(desc(tot_area)) %>%
  slice(-1)

crab_marsh_hab_summ <- crab_marsh_hab %>%
  group_by(HabClass) %>%
  summarize(tot_hab_area = sum(tot_area))
